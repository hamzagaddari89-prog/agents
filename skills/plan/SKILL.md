---
name: plan
description: Analyze a request and produce a clear implementation plan before touching code. Inspects existing code, identifies constraints and risks, and designs a solution. Use when the user asks for a plan, says plan, or before non-trivial implementation. Write no implementation code unless it is part of the analysis.
---

# Plan

Produce an implementation plan proportionate to the task.

## Workflow

```
Understand request
  ↓
Inspect existing code
  ↓
Identify constraints
  ↓
Identify risks
  ↓
Design solution
  ↓
Write plan
```

1. **Understand.** Restate the intended outcome in one line. Separate explicit
   requirements from assumptions. Classify the task as **trivial**, **bounded**,
   **exploratory**, or **architectural**, and scale planning depth accordingly:
   trivial needs only a brief check; the others need the inspection and evidence
   appropriate to their risk. Ask the user only if a real blocker is ambiguous;
   otherwise decide and state the assumption.
2. **Inspect.** Read the code the change will touch: entry points, callers,
   conventions, existing tests. Look for existing mechanisms to reuse.
3. **Constraints.** Stack, framework versions, project rules, things that must
   not change (check `.agent/DECISIONS.md` and native memory if available).
4. **Risks.** What could break? What is untested? What has hidden coupling?
5. **Design.** The smallest change that fully solves the request. State what
   you deliberately do NOT do and when the full version becomes necessary.
6. **Plan.** Output:
   - Goal (1 line)
   - Files to change and why
   - Steps, in order, each independently verifiable
   - Test strategy (what evidence proves it works)
   - Risks and rollbacks
   - Explicitly out of scope

## Pre-execution self-review

Before implementation, check briefly:

- Every explicit requirement maps to an implementation step.
- No unresolved placeholders remain.
- Relevant files and responsibilities are identified.
- Each non-trivial step has an independent verification path.
- Known gaps and uncertainties are explicit; identify review focus when risk warrants it.

## Rules

- No implementation code during planning (small snippets to clarify analysis
  are fine).
- Scale the plan to the task: a one-line fix needs a few lines, not a document.
- Write the plan to the chat; optionally save to `.agent/PLAN.md` for the
  implement phase to consume.
