#!/usr/bin/env bash
# install.sh — top-level installer for SEO Skills (DataForSEO edition).
#
# Two jobs:
#   1. Register the DataForSEO MCP server in Claude Code.
#   2. Optionally run the extension installers (firecrawl + google).
#
# Usage:
#   bash install.sh                       # interactive (prompts for credentials + extensions)
#   bash install.sh --all                 # install all extensions
#   bash install.sh --firecrawl --google  # explicit
#   bash install.sh --no-extensions       # MCP registration only
#   bash install.sh --target /some/path   # custom clone target
#
#   curl -fsSL https://raw.githubusercontent.com/DonnaPro/d4s/main/install.sh | bash
#
# Idempotent. Re-running re-registers the MCP and re-runs whichever extension installers you ask for.

set -euo pipefail

REPO_URL="${SEO_SKILLS_REPO_URL:-https://github.com/DonnaPro/d4s.git}"
DEFAULT_TARGET="${HOME}/.local/share/d4s"

red()    { printf '\033[0;31m%s\033[0m\n' "$*"; }
green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$*"; }
bold()   { printf '\033[1m%s\033[0m\n' "$*"; }
dim()    { printf '\033[2m%s\033[0m\n' "$*"; }

# --- 1. Parse flags ----------------------------------------------------------

TARGET=""
INSTALL_FIRECRAWL=0
INSTALL_GOOGLE=0
NO_EXTENSIONS=0
INTERACTIVE=auto

while [ $# -gt 0 ]; do
  case "$1" in
    --target)           TARGET="$2"; shift 2 ;;
    --target=*)         TARGET="${1#*=}"; shift ;;
    --all)              INSTALL_FIRECRAWL=1; INSTALL_GOOGLE=1; shift ;;
    --firecrawl)        INSTALL_FIRECRAWL=1; shift ;;
    --google)           INSTALL_GOOGLE=1; shift ;;
    --no-extensions)    NO_EXTENSIONS=1; shift ;;
    --non-interactive)  INTERACTIVE=no; shift ;;
    --interactive)      INTERACTIVE=yes; shift ;;
    -h|--help)
      sed -n '2,20p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *)
      red "Unknown flag: $1"
      echo "Run 'bash install.sh --help' for usage."
      exit 1
      ;;
  esac
done

if [ "$INTERACTIVE" = "auto" ]; then
  if [ -t 0 ] || [ -t 1 ]; then
    INTERACTIVE=yes
  else
    INTERACTIVE=no
  fi
fi

# --- 2. Base dependencies ----------------------------------------------------

command -v git >/dev/null 2>&1 || { red "Error: 'git' not found on PATH."; exit 1; }
command -v npx >/dev/null 2>&1 || { red "Error: 'npx' not found on PATH (Node.js required for DataForSEO MCP server)."; exit 1; }

# --- 3. Find or clone the repo -----------------------------------------------

REPO_DIR=""
if [ -f "$(pwd)/.claude-plugin/plugin.json" ]; then
  REPO_DIR="$(pwd)"
  green "✓ Running from existing clone at $REPO_DIR"
else
  TARGET="${TARGET:-$DEFAULT_TARGET}"
  if [ -d "$TARGET/.claude-plugin" ] && [ -d "$TARGET/.git" ]; then
    bold "→ Updating existing clone at $TARGET"
    git -C "$TARGET" fetch --depth 1 origin main >/dev/null 2>&1 || true
    git -C "$TARGET" pull --ff-only >/dev/null || yellow "  (pull --ff-only failed; continuing with current state)"
    REPO_DIR="$TARGET"
    green "✓ Updated $TARGET"
  elif [ -d "$TARGET" ] && [ "$(ls -A "$TARGET" 2>/dev/null)" ]; then
    red "Error: target directory '$TARGET' exists and is not empty."
    echo "Pass --target <dir> to choose a different location, or remove the directory first."
    exit 1
  else
    bold "→ Cloning $REPO_URL → $TARGET"
    mkdir -p "$(dirname "$TARGET")"
    git clone --depth 1 "$REPO_URL" "$TARGET"
    REPO_DIR="$TARGET"
    green "✓ Cloned to $TARGET"
  fi
fi

# --- 4. Register DataForSEO MCP server ----------------------------------------

echo ""
bold "DataForSEO MCP Server Registration"
echo ""

TTY_DEV=""
[ -e "/dev/tty" ] && TTY_DEV="/dev/tty"

read_input() {
  local prompt="$1"
  local var
  printf '%s' "$prompt"
  if [ -n "$TTY_DEV" ]; then
    read -r var < "$TTY_DEV" || var=""
  else
    read -r var || var=""
  fi
  echo "$var"
}

read_secret() {
  local prompt="$1"
  local var
  printf '%s' "$prompt"
  if [ -n "$TTY_DEV" ]; then
    read -rs var < "$TTY_DEV" || var=""
  else
    read -rs var || var=""
  fi
  echo ""
  echo "$var"
}

if [ -n "${DATAFORSEO_USERNAME:-}" ] && [ -n "${DATAFORSEO_PASSWORD:-}" ]; then
  green "✓ Using credentials from DATAFORSEO_USERNAME / DATAFORSEO_PASSWORD env vars."
else
  echo "Enter your DataForSEO credentials."
  echo "Find them at https://app.dataforseo.com/api-access"
  echo ""
  if [ "$INTERACTIVE" = "yes" ]; then
    DATAFORSEO_USERNAME=$(read_input "DataForSEO Username (email): ")
    DATAFORSEO_PASSWORD=$(read_secret "DataForSEO Password: ")
  else
    red "Non-interactive mode: set DATAFORSEO_USERNAME and DATAFORSEO_PASSWORD env vars before running."
    exit 1
  fi
fi

if [[ -z "$DATAFORSEO_USERNAME" || -z "$DATAFORSEO_PASSWORD" ]]; then
  red "Error: Username and password are required."
  exit 1
fi

echo ""
bold "→ Registering DataForSEO MCP server..."
claude mcp add \
  --transport stdio \
  --env DATAFORSEO_USERNAME="$DATAFORSEO_USERNAME" \
  --env DATAFORSEO_PASSWORD="$DATAFORSEO_PASSWORD" \
  dataforseo \
  -- npx -y dataforseo-mcp-server

green "✓ DataForSEO MCP server registered."

# --- 5. Decide which extensions to install -----------------------------------

if [ "$NO_EXTENSIONS" -eq 1 ]; then
  INSTALL_FIRECRAWL=0
  INSTALL_GOOGLE=0
elif [ "$INSTALL_FIRECRAWL" -eq 0 ] && [ "$INSTALL_GOOGLE" -eq 0 ]; then
  if [ "$INTERACTIVE" = "yes" ]; then
    echo ""
    bold "Optional extensions:"
    echo "  • Firecrawl  — wires firecrawl-mcp into Claude Code (raw HTML, JSON-LD, JS rendering)."
    echo "                 Used by 11 SEO skills + the seo-firecrawl orchestrator."
    echo "  • Google     — pip-installs Google API libs + sets up ~/.config/seo-skills/."
    echo "                 Required by seo-google."
    echo ""

    prompt_yn() {
      local q="$1" default="$2" answer
      local hint
      if [ "$default" = "y" ]; then hint="[Y/n]"; else hint="[y/N]"; fi
      printf '%s %s ' "$q" "$hint"
      if [ -n "$TTY_DEV" ]; then
        read -r answer < "$TTY_DEV" || answer=""
      else
        read -r answer || answer=""
      fi
      answer="${answer:-$default}"
      case "$answer" in
        [Yy]|[Yy][Ee][Ss]) return 0 ;;
        *) return 1 ;;
      esac
    }

    if prompt_yn "Install Firecrawl extension?" "y"; then INSTALL_FIRECRAWL=1; fi
    if prompt_yn "Install Google APIs extension?" "y"; then INSTALL_GOOGLE=1; fi
  else
    yellow "Non-interactive mode: skipping extensions. Re-run with --all to install them."
  fi
fi

# --- 6. Run extension installers --------------------------------------------

if [ "$INSTALL_FIRECRAWL" -eq 1 ]; then
  echo ""
  bold "→ Installing Firecrawl extension..."
  if [ -f "$REPO_DIR/extensions/firecrawl/install.sh" ]; then
    bash "$REPO_DIR/extensions/firecrawl/install.sh" || red "  Firecrawl install returned non-zero. See messages above."
  else
    red "  $REPO_DIR/extensions/firecrawl/install.sh not found."
  fi
fi

if [ "$INSTALL_GOOGLE" -eq 1 ]; then
  echo ""
  bold "→ Installing Google APIs extension..."
  if [ -f "$REPO_DIR/extensions/google/install.sh" ]; then
    bash "$REPO_DIR/extensions/google/install.sh" || red "  Google install returned non-zero. See messages above."
  else
    red "  $REPO_DIR/extensions/google/install.sh not found."
  fi
fi

# --- 7. Next steps -----------------------------------------------------------

echo ""
green "✓ SEO Skills for DataForSEO — setup complete."
echo ""
bold "Next steps:"
echo ""
echo "  1. In Claude Code, run /seo-api to verify the DataForSEO connection."
echo "     Then try /seo-keywords or /seo-competitive to get started."
echo ""
echo "  2. Plugin dir: $REPO_DIR"
echo "     To load skills in a new Claude Code session:"
echo "     claude --plugin-dir $REPO_DIR"
echo ""

if [ "$INSTALL_GOOGLE" -eq 1 ]; then
  echo "  3. Fill in your Google API credentials:"
  echo "     Edit ~/.config/seo-skills/google-api.json"
  echo "     Walkthrough: $REPO_DIR/skills/seo-google/references/auth-setup.md"
  echo "     Verify:      python3 $REPO_DIR/scripts/google_auth.py --check"
  echo ""
fi

if [ "$INSTALL_FIRECRAWL" -eq 0 ] && [ "$NO_EXTENSIONS" -eq 0 ]; then
  dim "Skipped Firecrawl. To install later: bash $REPO_DIR/extensions/firecrawl/install.sh"
fi
if [ "$INSTALL_GOOGLE" -eq 0 ] && [ "$NO_EXTENSIONS" -eq 0 ]; then
  dim "Skipped Google APIs. To install later: bash $REPO_DIR/extensions/google/install.sh"
fi

echo ""
bold "Repo: $REPO_DIR"
