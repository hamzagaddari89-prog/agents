# Coding Rules

Shared, agent-agnostic coding conventions. Every agent on this machine is
expected to follow these when writing or modifying code.

- Read before write: inspect the surrounding code and existing conventions
  before changing anything.
- Match the existing style of each file (naming, structure, error handling);
  do not introduce a second style.
- Use only libraries and frameworks already confirmed in the codebase. Ask
  before adding a new dependency.
- No placeholders, stubs, or omitted code in delivered changes. If something
  is intentionally not implemented, say so explicitly.
- Absolute paths when referring to files outside the working directory.
- Small, focused changes. Do not drive-by refactor unrelated code.
- Never commit secrets, tokens, or credentials. Never hardcode
  machine-specific paths that could break other checkouts.
