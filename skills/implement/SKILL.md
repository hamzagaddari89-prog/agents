---
name: implement
description: Execute an existing plan with the fewest necessary changes. Reads the plan, re-validates it against current code, implements in small verifiable steps, preserves existing architecture, and runs the relevant tests. Use when a plan exists (chat or .agent/PLAN.md) and the user says implement, execute, or نفّذ. Do not expand scope.
---

# Implement

Execute a plan with minimal, verifiable changes.

## Workflow

1. **Read the plan.** From the conversation or `.agent/PLAN.md`. If no plan
   exists, do a short inline plan first or invoke the `plan` skill — do not
   improvise a large change.
2. **Re-validate.** Check the plan is still correct against current code
   (the repo may have moved since planning). Flag any drift before executing.
3. **Checkpoint.** For non-trivial changes: ensure state is recoverable
   (git commit/branch, or native checkpoint tools when available).
4. **Implement.**
   - Make the fewest changes necessary; follow existing conventions.
   - One step at a time; each step leaves the codebase working. When
     test-first applies, establish the failing test before the implementation
     change; an expected RED state (the intentionally failing test) is valid.
   - No drive-by refactors, no unrelated edits, no scope expansion.
5. **Test.** Run the relevant tests for the affected area (see `test` skill).
   Fix only what the plan covers; report anything uncovered as a finding.
6. **Report.** Files changed, why, verification evidence, and anything
   deliberately skipped.

## Rules

- Preserve the existing architecture; do not rewrite it.
- Never leave partial, non-working changes without saying so explicitly.
- Current verified state overrides stale memory.
