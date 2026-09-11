# Testing Rules

- "Verified" means actually run: state the command and the observed result.
  "Looks fine" is not verification.
- New behavior needs a test; bug fixes need a test that fails before the fix.
- Test-first (TDD) when a test can reasonably be established first: write or
  establish the failing test before implementing (RED); run it and confirm it
  fails for the intended reason, quoting that failure as evidence (a compile
  error or typo is not the intended failure). Then make the smallest
  implementation change, re-run the focused test until it passes (GREEN), and
  run the broader relevant suite. Cleanup or refactoring after that must not
  change behavior (REFACTOR). For bug fixes the debugging order stands —
  symptom → reproduce → evidence → diagnosis → fix → re-run; the reproduction
  is the failing state, so do not insert a test-first step before it (see the
  `systematic-debugging` skill).
- TDD does not apply to every kind of work: docs-only, config-only,
  exploratory, or read-only work needs no invented tests — say why TDD does
  not apply instead of forcing meaningless tests.
- Tests should verify observable behavior through the appropriate entry
  points rather than merely mirroring implementation internals.
- Debugging is evidence-first: establish the actual symptom and reproduce the
  failure before changing code. If it cannot be reproduced, say so and work
  from collected evidence (logs, stack traces, recent diffs) instead of
  guessing. For non-trivial failures follow the `systematic-debugging` skill.
- Fix with one change at a time and re-run the reproduction after each change;
  do not stack a second fix on an unverified first one. Never mask a symptom
  (deleting or weakening a failing test, swallowing the error) instead of
  fixing the cause.
- Distinguish confirmed root cause from hypothesis and label them as such. If
  the root cause cannot be established, say so explicitly instead of patching
  blindly.
- Run the project's existing test command (or find it) before claiming done.
- Verification before completion: a task may be reported as done only after
  verification ran in this session — state the exact command(s) and their
  observed result together with the claim. If verification is impossible (no
  test runner, no coverage, broken environment), report the work as unverified
  and say why instead of claiming done.
- Test-pass evidence only covers what the tests actually exercise. If part of
  the change is not covered by any executed test or manual run, say so in the
  report instead of implying full verification.
- Do not weaken, skip, or delete existing tests to make a change pass. If a
  test must change, explain why in the change.
- Test in the environment the code actually runs in (Windows paths, PowerShell
  semantics) where relevant.
