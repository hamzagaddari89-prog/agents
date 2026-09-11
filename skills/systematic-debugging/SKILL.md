---
name: systematic-debugging
description: Find and fix the actual cause of a failure instead of patching symptoms. Use when debugging a bug, error, failing test, flaky behavior, regression, or "it stopped working" - establish the symptom, reproduce it, gather evidence before changing code, test ranked hypotheses one change at a time, and label confirmed root causes versus guesses.
---

# Systematic Debugging

Fix causes, not symptoms. Evidence before changes.

## Workflow

1. **Symptom.** State exactly what fails, where, when - quote the error
   verbatim. Note what still works.
2. **Reproduce.** Find the smallest reliable command that triggers it. If it
   cannot be reproduced, say so and continue from evidence only.
3. **Evidence.** Before changing anything: read logs, stack traces, recent
   diffs, and the involved code paths. Changes follow evidence.
4. **Hypotheses.** List plausible root causes, ranked. For each, run the
   cheapest check that would confirm or refute it.
5. **One change at a time.** Make the smallest change addressing the
   best-supported hypothesis. If the result does not support it, revert.
6. **Re-run.** After every change, re-run the same reproduction. Never stack
   a second fix on an unverified first one.
7. **Confirm.** The original failing command passes (re-run flaky passes
   before trusting them) and the relevant suite is green. Label the cause
   CONFIRMED (backed by evidence) or HYPOTHESIS (not yet).
8. **Report the trail.** Symptom, reproduction command, cause with evidence,
   fix, verification commands and results. If the root cause cannot be
   established, say so explicitly and record it (checkpoint Known Issues or
   DECISIONS.md) instead of claiming it fixed.

## Rules

- No code changes before the symptom is established and evidence gathered
  (trivially obvious causes exempt - say why).
- Never mask a symptom: no deleting or weakening a failing test, no swallowing
  the error, no guard at one caller when the shared path is broken.
- A passing run without an established cause is a hypothesis, not a fix.
