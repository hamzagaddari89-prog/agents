---
name: ponytail-help
description: >
  Show a one-shot quick reference for Ponytail modes, companion skills, and
  deactivation/configuration. Use for /ponytail-help or ponytail help.
license: MIT
metadata:
  source: https://github.com/DietrichGebert/ponytail
---

# Ponytail Help

Display this reference card only. Do not change mode, write files, or persist
state.

## Modes

- `/ponytail lite`: build what was asked and name the lazier alternative.
- `/ponytail`: full ladder, the default: YAGNI, existing code, stdlib, native,
  one line, then minimum.
- `/ponytail ultra`: deletion before addition and requirement challenges.
- `/ponytail off`: disable it.

## Companion skills

- `/ponytail-review`: over-engineering review of the current diff.
- `/ponytail-audit`: repository-wide over-engineering audit.
- `/ponytail-debt`: ledger of `ponytail:` shortcut comments.
- `/ponytail-gain`: published benchmark scoreboard.
- `/ponytail-help`: this reference.

## Deactivate and configure

Say `stop ponytail` or `normal mode` to deactivate. Resume with `/ponytail`.
The default mode is `full`. Set `PONYTAIL_DEFAULT_MODE` or
`%APPDATA%\ponytail\config.json` with `{ "defaultMode": "lite" }` to change
it. Environment configuration takes priority over the file.

Source: https://github.com/DietrichGebert/ponytail
