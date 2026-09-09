---
name: task-delegation
description: Decide when and how to delegate isolated tasks to sub-agents, and how to prompt them. Use when considering parallel or isolated work (research, review, test analysis, docs), or when the user asks about delegating, sub-agents, or parallel tasks. Only for runtimes with native sub-agent support (Claude Code, OpenCode); never imitate sub-agents where unsupported.
---

# Task Delegation

Delegate isolated tasks to narrow sub-agents — when it actually helps.

## When to delegate

Delegate only when ALL hold:
- The task is isolatable (clear inputs, clear output, no shared in-flight state).
- It is read-only or touches files strictly outside the main change flow
  (research, review, test analysis, docs).
- Doing it inline would flood the main context or serialize independent work.

Do NOT delegate: trivial checks, anything requiring the session's full
context, or tasks that mutate the same files the main agent is changing.

## Sub-agent contract (every delegation must state)

```text
Input:  exact files/paths, diff range, or question
Task:   inspect/analyze X — look for Y
Mode:   read-only (or: may write only <explicit paths>)
Output: findings with evidence (path:line, command output), no fluff
```

Never give a sub-agent a generic role ("you are the backend agent").
Give it the task above, verbatim and specific.

## Parallel execution

- Only for tasks with no dependencies between them (e.g. review + docs +
  test-analysis of an already-committed diff).
- Not the default — correctness over speed; boundaries must be explicit.
- Never parallelize two tasks that read-and-write overlapping files.

## Runtimes

- Claude Code: native sub-agents (`~/.claude/agents/*.md`, Task tool).
- OpenCode: native sub-agents (`~/.config/opencode/agent/*.md` with
  `mode: subagent`).
- Other agents: do not imitate sub-agents; run the task inline with the
  `audit`/`research`/`review` skills instead.

## Depth

One level of delegation. If a sub-agent needs another sub-agent, the task was
not properly isolated — re-scope instead.
