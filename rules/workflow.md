# Workflow Rules

- Use the shared skills in `~\.agents\skills` when they apply. Standard loop:
  `continue -> plan -> implement -> test -> verify -> review -> checkpoint`.
  Small tasks: `implement` + `test` is enough — but the completion gate in the
  testing rules (evidence before claiming done) always applies.
- Project memory convention: maintain `.agent/CHECKPOINT.md` (current state)
  and `.agent/DECISIONS.md` (append-only, includes rejected alternatives).
- Record decisions in DECISIONS.md with rationale and rejected alternatives —
  this prevents re-litigating settled questions.
- Sub-agents: native support only (Claude Code, OpenCode). Never emulate
  sub-agents on runtimes that lack them. One delegation level maximum.
- Do not imitate or install frameworks for what a few markdown files already
  do. This layer is deliberately local, simple, portable, auditable.
