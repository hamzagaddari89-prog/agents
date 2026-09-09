---
name: continue
description: Resume an existing project safely. Reads project memory (.agent/), inspects git status and recent changes, locates the last checkpoint, and proposes a resume point. Use when starting a session on a project you (or another agent) worked on before, or when the user says continue, resume, or استئناف. Read-only until the resume point is agreed.
---

# Continue

Resume an existing project from persisted state, not from guesswork.

## Workflow

1. **Load project memory.** Read `.agent/CHECKPOINT.md` and `.agent/DECISIONS.md`
   in the project root if they exist. If the agent has native memory tools
   (e.g. OpenCode `memory_search`/`memory_list`), check those too.
2. **Inspect git state.** Run `git status`, `git log --oneline -15`,
   and `git diff --stat` (if there are uncommitted changes, `git diff` on the
   changed files). Note uncommitted work explicitly.
3. **Locate the last checkpoint.** From CHECKPOINT.md and/or the most recent
   commits: what was completed, what was verified, what was left open?
4. **Determine current task.** Cross-check the "Next Step" from the checkpoint
   against the actual repo state. If they disagree, trust the repo.
5. **Propose a resume point.** Present:
   - Where the project stands (2-4 lines)
   - The last checkpoint reference
   - Proposed first action for this session
6. **Wait for confirmation** before starting significant changes. Do not
   begin large modifications before the state is understood and the user
   (or the plan) confirms.

## Rules

- Read-only during steps 1-5.
- Never assume the checkpoint is up to date — verify against the repo.
- If `.agent/` does not exist and there is no memory, say so plainly and do a
  short fresh discovery instead of inventing history.
- Do not repeat large file dumps; summarize and cite paths.
