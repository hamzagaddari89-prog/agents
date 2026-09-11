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
  not apply instead of forcing meaningless tests. No invented tests does NOT
  mean no verification: validate or parse/build/load the configuration,
  execute the relevant command, inspect the resulting behavior — or
  explicitly report UNVERIFIED when meaningful execution is impossible.
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
  and say why instead of claiming done: state what runner/tool or mechanism
  was searched for, what was attempted, and why meaningful verification could
  not be performed — enough to make the impossibility claim credible, without
  requiring an exhaustive search.
- Test-pass evidence only covers what the tests actually exercise. If part of
  the change is not covered by any executed test or manual run, say so in the
  report instead of implying full verification. Unrelated green tests are not
  proof of an uncovered criterion.
- Post-hoc test linkage: a test added only after the implementation/fix (not
  established first) must demonstrably exercise the changed behavior — when
  practical, show the pre-change implementation fails it; otherwise give
  another concrete linkage/evidence argument. A test that passes after the
  change but would also have passed before it must not be treated as proof
  of the fix. No artificial RED/GREEN demonstration when genuinely
  impractical — honest evidence instead.
- Do not weaken, skip, or delete existing tests to make a change pass. This
  includes verification configuration — coverage thresholds, test collection
  filters, skip markers, exclusion rules, timeout/tolerance changes, or
  fixture behavior that reduces verification strength. Legitimate
  configuration changes are allowed, but each must be justified and must not
  weaken the evidence for the current task. If a test must change, explain
  why in the change.
- Test in the environment the code actually runs in (Windows paths, PowerShell
  semantics) where relevant.

## Requirement-Coverage Gate

DONE = every requested requirement/acceptance criterion has relevant,
executed, passing evidence. Tests passing by themselves are NOT sufficient.
The gate applies to every DONE claim, in this session, with no triviality
exemption: small, obvious, low-risk, documentation, and configuration
changes all go through the same gate — "trivial" never means "verification
optional".

- Map: restate the requested behavior/acceptance criteria as a short list
  and map every criterion to executed evidence — the exact command/action
  and the observed result. A criterion with no executed evidence is
  UNVERIFIED.
- Outcome control: a full DONE claim is allowed only when every required
  criterion has passing evidence. If any criterion fails, remains
  unverified, is only partially verified, or lacks relevant evidence, do
  not claim full completion — report PARTIALLY DONE, NOT DONE, or
  UNVERIFIED. Disclosure alone does not satisfy the gate.
- Bug fixes: when the original symptom is reproducible, reproduce it, make
  the fix, rerun the original reproduction, and require it to pass as part
  of the completion evidence. If the original issue cannot be reproduced,
  say so explicitly, identify the evidence actually used, and do not
  present the fix as directly reproduced/verified.
