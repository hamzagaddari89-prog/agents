---
name: verify
description: Verify an implementation actually achieved the requirement — not that the code "looks correct". Derives acceptance evidence from the requirement, runs it, and compares claimed vs actual behavior. Use after implementation, when the user says verify, تحقق, or "did it actually work". Read-only plus running commands/tests; no fixes.
---

# Verify

Prove the requirement is met. Assumption is not verification.

## Workflow

1. **Restate the requirement** as testable claims:
   "X, when given Y input, produces Z / exposes W."
2. **Derive evidence.** For each claim: which command, test, or manual check
   would demonstrate it? Include the failure path (invalid input → correct
   error) when relevant.
3. **Run the evidence.** Execute tests/commands. Capture actual output.
   If the agent can use the feature (run a script, call an endpoint), do it —
   do not stop at "tests pass".
4. **Compare** claimed vs actual behavior. Note anything only partially met.
5. **Report:**

```text
Claim 1: ... -> PASS, evidence: <command/output>
Claim 2: ... -> FAIL, evidence: ... (what actually happened)
Untestable: ... (why, what manual check is needed)
Verdict: requirement met / partially met / not met
```

## Rules

- Verification is read-only + running things; fixing is the `implement`/
  `test` skills' job (only in implementation mode).
- Compilation success ≠ verification. Existing tests passing without covering
  the requirement ≠ verification.
- Report negative results as directly as positive ones.
