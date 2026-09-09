# <server-name> — MCP server definition

Copy this file to define a new MCP server. Delete sections that do not apply,
but keep the required fields.

## Required fields

- **name:** <unique kebab-case name>
- **purpose:** <what capability it provides and why an agent would need it>
- **enabled by default:** no (definitions are never enabled by default)
- **supported agents:** <which runtimes support it, e.g. Claude Code, OpenCode>

## Optional fields (fill in if applicable)

- **endpoint / command:** <exact command or URL>
- **required environment variables:** <e.g. `${MY_API_KEY}` — references only,
  never actual values>
- **security considerations:** <data it exposes, network access, risks>
- **config snippet:** <exact JSON/TOML the user adds to a specific agent>

## Example snippet (Claude Code, illustrative only)

```json
{
  "mcpServers": {
    "<server-name>": {
      "command": "<command>",
      "env": { "MY_API_KEY": "${MY_API_KEY}" }
    }
  }
}
```
