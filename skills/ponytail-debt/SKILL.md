---
name: ponytail-debt
description: >
  Harvest every ponytail: comment into a debt ledger, including its known
  ceiling and upgrade trigger. Use for ponytail debt, shortcuts, or
  /ponytail-debt. Read-only unless the user explicitly asks to persist it.
license: MIT
metadata:
  source: https://github.com/DietrichGebert/ponytail
---

# Ponytail Debt

Scan the repository for deliberate shortcut comments marked `ponytail:`. Skip
`.git`, `node_modules`, and build output. Support the comment syntax used by
the repository, including `# ponytail:` and `// ponytail:`.

Report one row per marker, grouped by file:

`<file>:<line>, <what was simplified>. ceiling: <the named limit>. upgrade: <the trigger to revisit>.`

Flag any marker without an upgrade path or trigger with `no-trigger`. End with
`<N> markers, <M> with no trigger.` If none are found, say
`No ponytail: debt. Clean ledger.`

This skill reads and reports only. Persist a ledger only when the user asks for
one, using a file such as `PONYTAIL-DEBT.md`.
