# Auth & Keys

How DataForSEO authentication works via the MCP server and the REST API directly.

## Auth method — HTTP Basic Auth

DataForSEO uses **HTTP Basic Auth** on every request. There is no OAuth, no API key header, no Bearer token — just a username and password pair.

```
Authorization: Basic base64(username:password)
```

The MCP server reads credentials from two environment variables at startup:

| Env var | Value |
|---|---|
| `DATAFORSEO_USERNAME` | Your DataForSEO account email |
| `DATAFORSEO_PASSWORD` | Your DataForSEO API password (set separately from your login password) |

Get / set your API password at: <https://app.dataforseo.com/api-dashboard>

## MCP server setup

The DataForSEO MCP server is configured as a local stdio server (not a remote HTTP endpoint). Credentials are passed as env vars at launch — not as headers in each tool call.

### Claude Code

In `.claude/settings.json` (project) or `~/.claude/settings.json` (global):

```json
{
  "mcpServers": {
    "dataforseo": {
      "command": "npx",
      "args": ["-y", "@dataforseo/mcp-server"],
      "env": {
        "DATAFORSEO_USERNAME": "your@email.com",
        "DATAFORSEO_PASSWORD": "your_api_password"
      }
    }
  }
}
```

Or using the CLI:

```bash
claude mcp add dataforseo \
  --command "npx" \
  --args "-y,@dataforseo/mcp-server" \
  --env "DATAFORSEO_USERNAME=your@email.com" \
  --env "DATAFORSEO_PASSWORD=your_api_password"
```

### Claude Desktop

`~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or `%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "dataforseo": {
      "command": "npx",
      "args": ["-y", "@dataforseo/mcp-server"],
      "env": {
        "DATAFORSEO_USERNAME": "your@email.com",
        "DATAFORSEO_PASSWORD": "your_api_password"
      }
    }
  }
}
```

### Cursor / Windsurf / VS Code

Same JSON structure — place in `.cursor/mcp.json`, `~/.codeium/windsurf/mcp_config.json`, or VS Code's MCP settings respectively.

## REST API auth (direct, without MCP)

If calling the DataForSEO REST API directly (outside of MCP):

```bash
curl -X POST 'https://api.dataforseo.com/v3/serp/google/organic/live/advanced' \
  -u 'your@email.com:your_api_password' \
  -H 'Content-Type: application/json' \
  -d '[{"keyword": "seo tools", "location_code": 2840, "language_code": "en"}]'
```

`-u` in curl sends Basic Auth. In code, set the `Authorization` header manually:

```python
import base64, requests

credentials = base64.b64encode(b"your@email.com:your_api_password").decode()
headers = {
    "Authorization": f"Basic {credentials}",
    "Content-Type": "application/json",
}
```

```typescript
const credentials = btoa("your@email.com:your_api_password");
const headers = {
  Authorization: `Basic ${credentials}`,
  "Content-Type": "application/json",
};
```

## Liveness check

Cheapest way to confirm credentials are valid (minimal credit cost):

```bash
curl -u 'your@email.com:your_api_password' \
  'https://api.dataforseo.com/v3/appendix/user_data'
```

`200 OK` with account data = credentials are alive. `401 Unauthorized` = wrong username or password.

## Storing credentials safely

- **Never commit credentials to git.** Use `.env` files (gitignored) or a secret manager.
- **For CI/CD:** use GitHub Actions secrets, GitLab CI variables, or your platform's secret store. Inject as env vars at runtime.
- **For Docker:** pass via `--env-file .env`, never bake into the image layer.
- **For local dev:** a `.env` file loaded by `dotenv` (Python) or `dotenv` (Node). Ensure `.env` is in `.gitignore`.

```bash
# .env (gitignored)
DATAFORSEO_USERNAME=your@email.com
DATAFORSEO_PASSWORD=your_api_password
```

## Common auth errors

| HTTP | What it means | Fix |
|---|---|---|
| `401 Unauthorized` | Wrong username, wrong password, or no `Authorization` header. | Verify credentials at <https://app.dataforseo.com/api-dashboard>. Check that the API password is set (it defaults to empty on new accounts). |
| `403 Forbidden` | Account suspended or insufficient plan for the endpoint. | Check account status at the DataForSEO dashboard. |
| `402 Payment Required` | Insufficient API credit balance. | Top up at <https://app.dataforseo.com/billing>. |

## API password vs. login password

DataForSEO has **two separate passwords**:

1. **Login password** — for signing into `app.dataforseo.com`. Not used for API access.
2. **API password** — for all API and MCP calls. Set at: `app.dataforseo.com/api-dashboard` → "Change API password".

New accounts often have no API password set. If you get `401` immediately, this is the most common cause — set the API password first.
