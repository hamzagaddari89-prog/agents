---
name: checkpoint
description: Save the current project state as a small structured summary a future session can resume from. Writes .agent/CHECKPOINT.md (Completed, Changed, Verified, Decisions, Known Issues, Next Step) and appends decisions to .agent/DECISIONS.md. Use when finishing a phase, before ending a session, or when the user says checkpoint, احفظ الحالة. Keeps the summary small — no bulk repo dumps.
---

# Checkpoint

Persist a small, structured resume point.

## Workflow

1. **Gather state.** `git status --short`, `git log --oneline -10`,
   recent decisions (from the session, `.agent/DECISIONS.md`, or native
   memory tools like OpenCode `memory_checkpoint`).
2. **Write `.agent/CHECKPOINT.md`** (overwrite — it is the *current* state,
   append-only logs live in DECISIONS.md):

```markdown
# Checkpoint <date> <time>

## Completed
- (what is done and works)

## Changed (uncommitted)
- (files/dirs + one line why each)

## Verified
- (tests/commands actually run + result — not "looks fine")

## Decisions
- (decisions made this session; also append to DECISIONS.md)

## Known Issues
- (open problems, limitations, deferred work)

## Next Step
- (single concrete first action for the next session)
```

3. **Append decisions** to `.agent/DECISIONS.md` (one block each: decision,
   rationale, alternatives rejected). Rejected alternatives matter — they
   prevent re-litigating the same idea.
4. **Confirm** to the user in 2-3 lines with the checkpoint file path.

## Rules

- Keep it small: a future session reads this to resume fast. No bulk dumps,
  no file contents, no logs.
- Verified means actually run — commands and results only.
- Do not store secrets in checkpoints (api keys, tokens, credentials — ever).
