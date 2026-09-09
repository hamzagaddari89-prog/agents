---
name: cold-review
description: Review recent changes from a fresh perspective that did not see the implementation process. Inspects requirements + diff + tests without relying on the implementer's reasoning, finds what it actually breaks or misses. Use when the user says cold review, مراجعة مستقلة, or before accepting a significant change. If sub-agents are supported (Claude Code, OpenCode), delegate to a cold-reviewer sub-agent; otherwise review with deliberately fresh eyes.
---

# Cold Review

Fresh-eyes review: judge the change, not the implementation story.

## Workflow

1. **Reset context.** Consider ONLY: the requirement (original request/plan),
   the diff, and tests. Do not rely on the implementer's reasoning about why
   the code is correct — re-derive correctness from the code itself.
2. **Prefer a sub-agent** when the runtime supports them (native `Task`-style
   agents in Claude Code, `mode: subagent` agents in OpenCode — a
   `cold-reviewer` agent is provided). Prompt it with the narrow task:
   inspect these files/diff, look for X, do not modify anything, return
   findings with evidence.
3. **Review** using the `review` checklist (requirements, implementation,
   tests, regressions, complexity) with emphasis on:
   - Does the diff actually satisfy the stated requirement?
   - Hidden regressions in code that merely references the changed code?
   - Anything explained by "because I implemented it that way" rather than
     by the code.
4. **Report** findings with evidence and a verdict
   (`merge as-is | merge with fixes | needs work`).

## Rules

- Read-only.
- The reviewer must not inherit the implementer's conclusions.
- Narrow scope: the review targets the change, not the whole project.
