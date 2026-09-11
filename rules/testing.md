# Testing Rules

- "Verified" means actually run: state the command and the observed result.
  "Looks fine" is not verification.
- New behavior needs a test; bug fixes need a test that fails before the fix.
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
