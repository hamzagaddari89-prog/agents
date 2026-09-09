# Shared MCP Definitions

A **documentation/configuration source of truth** for MCP servers that any
agent on this machine may use. This is NOT an MCP server, and this layer does
not install packages, start processes, or auto-enable anything.

## How this works

- One markdown file per MCP server in `servers/`.
- Files follow the shape of `servers/TEMPLATE.md` (validated by doctor.ps1).
- **No server is enabled by default.** Enabling an MCP server in a given agent
  (Claude Code, Codex, OpenCode, ...) is an explicit, manual step performed in
  that agent's own config, following the definition's instructions.
- If a definition says it is supported by an agent, the definition must include
  the exact config snippet to add (with environment-variable references only).

## Critical security rules

- NEVER store actual credentials, API keys, tokens, or passwords in this
  directory. Environment-variable references only (`${MY_API_KEY}`).
- Never enable an MCP server you have not read and understood the purpose of.
- Verify.ps1 / doctor.ps1 scan this directory for secrets; a failure here is a
  hard error.

## Validation

Run `powershell -File ~\.agents\doctor.ps1` — the MCP section checks that each
definition has all required fields (name, purpose, security considerations,
enabled-by-default flag) and no plaintext secrets.
