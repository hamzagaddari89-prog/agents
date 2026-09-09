# Shared Agent Skills Layer

Single source of truth for coding-agent skills, shared by every agent on this
machine. **The skills are the foundation; the agents are just consumers.**

```
~\.agents\skills\              <- SOURCE OF TRUTH (Agent Skills standard: <name>\SKILL.md)
      |
      +-- Cline        reads ~\.agents\skills natively
      +-- OpenCode     ~\.config\opencode\skills   = junction -> ~\.agents\skills
      +-- Claude Code  ~\.claude\skills            = junction -> ~\.agents\skills
      +-- Codex        ~\.codex\skills\<name>      = per-skill junctions (leaves .system intact)
      +-- Qwen Code    ~\.qwen\QWEN.md             = pointer artifact (generated)
```

## Skills

Workflow skills: `continue`, `plan`, `implement`, `test`, `verify`,
`checkpoint`, `review`, `cold-review`, `audit`, `research`,
`context-management`, `task-delegation`.
Pre-existing (kept as-is): `se-workflow`, `project-status`, `self-repair`,
`research-methodology`, `ponytail*`, `ai-priming`, `developing-with-streamlit`.

## How to add a skill

1. `mkdir ~\.agents\skills\<skill-name>` and create `SKILL.md` inside.
2. Frontmatter must have `name:` and `description:` (the description is what
   makes agents discover and trigger the skill — write it carefully, include
   trigger words). Body: the instructions, model-agnostic, no tool-only syntax.
3. If the skill is Codex-relevant too: re-run the sync script (below).
   Cline/OpenCode/Claude pick it up automatically through the junctions.
4. Keep one skill per directory; name it `kebab-case`; avoid duplicating an
   existing skill's purpose (check before adding).

## How to add a new agent (adapter)

Check what the agent natively supports, in this order:

1. **Reads `~\.agents\skills` directly** (like Cline) -> nothing to do.
2. **Has a user skills dir** (OpenCode `~\.config\opencode\skills`, Claude
   `~\.claude\skills`, Codex `~\.codex\skills`) -> create a junction to the
   shared dir (or per-skill junctions if the dir also holds its own skills,
   as Codex does with `.system`). Example:
   `New-Item -ItemType Junction -Path <agent-skills-dir> -Target ~\.agents\skills`
3. **Only has a global instructions/context file** (Qwen `~\.qwen\QWEN.md`) ->
   add a short pointer listing the skills and the project-memory convention.
   Mark it as a generated artifact.
4. **No customization mechanism** (Copilot CLI, cagent) -> no adapter; skip.

Never copy skill files into an agent's dir as the source of truth — copies
are generated/synced artifacts only.

## Project memory convention (used by the skills)

Per project, the skills maintain:

- `.agent\CHECKPOINT.md` — current resume state (overwritten each checkpoint):
  Completed / Changed / Verified / Decisions / Known Issues / Next Step.
- `.agent\DECISIONS.md` — append-only decision log (decision, rationale,
  rejected alternatives).

Agents with native memory tools (OpenCode `memory_*`, `create_checkpoint`)
may use them in addition; the `.agent/` convention is the portable baseline.

## Sub-agents (only where natively supported)

- Claude Code: `~\.claude\agents\cold-reviewer.md`
- OpenCode: `~\.config\opencode\agent\cold-reviewer.md` (mode: subagent)

Purpose: independent "cold review" of a change without inheriting the
implementer's reasoning. Other agents: run the `review`/`cold-review` skills
inline instead of imitating sub-agents.

## Sync / regenerate artifacts

Codex per-skill junctions and the Qwen pointer are generated. Regenerate them
after adding/removing skills with:

```powershell
powershell -File ~\.agents\sync-adapters.ps1
```

Idempotent: safe to run any time; it only creates missing junctions/pointers,
removes stale ones, and never touches agent-owned content (e.g. Codex `.system`).

## Verify the layer

```powershell
powershell -File ~\.agents\verify.ps1
```

Checks: frontmatter validity, no duplicate skill names, junction targets
resolve, adapters intact, no secrets committed in skills.

## Standard workflow (proportional — not every task needs every phase)

```
continue (resume) -> plan -> implement -> test -> verify -> review/cold-review -> checkpoint
```

Small tasks: `implement` + `test` is enough. Big tasks: the full loop.
Read-only needs: `audit` / `research` / `review`.

## Maintenance rules

- Backups live in `~\.agents\.backup-*` and are not part of the skills dir.
- Historical note: `~\.agents\skills\skills` was a nested exact duplicate
  (hash-identical) found in Phase 0; it was moved to
  `.backup-nested-skills-duplicate\skills` — do not recreate it.
