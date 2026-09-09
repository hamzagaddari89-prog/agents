# Testing Rules

- "Verified" means actually run: state the command and the observed result.
  "Looks fine" is not verification.
- New behavior needs a test; bug fixes need a test that fails before the fix.
- Run the project's existing test command (or find it) before claiming done.
- Do not weaken, skip, or delete existing tests to make a change pass. If a
  test must change, explain why in the change.
- Test in the environment the code actually runs in (Windows paths, PowerShell
  semantics) where relevant.
