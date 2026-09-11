---
name: test
description: Run and add tests for changes, analyze failures, and report evidence. Identifies the affected area, runs relevant tests, analyzes failures, and reports honestly — including important cases that were never tested. Use when the user asks to test, verify tests, before implementation to establish a failing test (test-first/RED), or after implementation. Fixing failures is allowed only when explicitly operating in implementation mode.
---

# Test

Produce honest test evidence for a change or area.

## Workflow

```
Identify affected area
  ↓
Run relevant tests
  ↓
Analyze failures
  ↓
Fix only in implementation mode
  ↓
Run tests again
  ↓
Report evidence
```

1. **Identify.** From the change (git diff/status) or the user request: which
   modules are affected? Which existing tests cover them?
2. **Run.** Execute the relevant tests first (not the whole suite unless
   affected). Use the project's actual runner and flags.
3. **Analyze.** For failures: root cause, is it caused by the change, or
   pre-existing? Report pre-existing failures as findings — do not hide them.
   For non-trivial failures, follow the `systematic-debugging` skill before
   fixing.
4. **Fix** only when explicitly operating in implementation mode (user said
   fix/implement). Otherwise report and stop.
5. **Re-run** after any fix.
6. **Report.**
   - Commands run (exact)
   - Pass/fail counts, failing tests with the assertion message
   - Important cases NOT covered by any test — success of existing tests is
     not sufficient evidence when untested important behavior exists
   - Conclusion: does the evidence support the change?

## Test-first (RED)

When invoked before implementation for a behavior change:

1. **Establish** the failing test: write it, or adopt the existing
   reproduction as the test.
2. **Confirm** it fails for the intended reason — quote the failure message
   as evidence. A compile error, typo, or wrong fixture is not the intended
   failure.
3. **Hand off.** Stop and hand to implementation (e.g. the `implement`
   skill). Do not implement unless explicitly in implementation mode.

The rules below apply unchanged in this mode.

## Rules

- Never claim success from compilation or "looks correct".
- Never skip or ignore a failing test silently.
- Never weaken an assertion to make it pass.
