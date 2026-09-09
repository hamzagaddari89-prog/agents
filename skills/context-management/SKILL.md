---
name: context-management
description: Manage conversation context across long sessions — retain high-value state (requirements, decisions, architecture, findings, changed files, test results, next step) and drop noise (old logs, repeated explanations, redundant tool output). Use when a session is getting long, context is being compacted, or the user says summarize state, ضغط السياق.
---

# Context Management

Keep high-value context, shed noise — before the runtime force-drops it.

## Keep (high value)

- Requirements and the current goal
- Decisions made and why (incl. rejected alternatives)
- Architecture facts and important conventions
- Important findings (paths, line refs, root causes)
- Changed files (what + why, not full contents)
- Test results (commands + outcomes)
- Next step

## Drop (noise)

- Repeated explanations of the same thing
- Old command logs and long tool output (keep the one-line result)
- Obsolete reasoning superseded by a later decision
- Duplicate information already in project memory (`.agent/`) or the plan

## Workflow

1. **Native first.** If the runtime provides compaction/summarization
   (OpenCode session summarize/compact, Claude Code auto-compact), use it
   instead of inventing a parallel system. This skill adds the *policy*, the
   runtime provides the *mechanism*.
2. **Persist before dropping.** Anything valuable that is not yet persisted
   goes to `.agent/CHECKPOINT.md` / `.agent/DECISIONS.md` (see `checkpoint`
   skill) or the current plan — then it is safe to let it leave the context.
3. **On compaction/summarize**, produce a short state summary in this shape:
   Requirement → Decisions → Current state → Changed files → Test results →
   Next step.
4. **Prefer pointers.** Reference files by path instead of re-reading or
   re-pasting their contents.

## Rules

- Never persist secrets.
- Never let a requirement or an active decision leave context unpersisted.
