---
name: review
description: Review an existing implementation against its requirements — diff, tests, regressions, unnecessary complexity. Read-only, findings with evidence. Use when the user says review, راجع, or after an implementation completes. Distinct from audit (whole-project) — review targets a specific change.
---

# Review

Independent review of a specific implementation/change.

## Inputs

- Requirements (from the request, plan, or `.agent/PLAN.md`)
- The diff (`git diff` for uncommitted, or commit range)
- Tests touching the changed area

## Checklist

1. **Requirements.** Does the change do what was asked — all of it, and only
   it? List gaps and unrequested additions.
2. **Implementation.** Correct logic? Follows existing conventions?
   Edge cases handled? Minimal necessary change?
3. **Tests.** Do tests cover the new behavior? What important case is
   untested? Were tests weakened to pass?
4. **Regressions.** Callers/consumers of changed code — anything broken?
5. **Complexity.** Over-engineering: unnecessary abstraction, speculative
   config, duplicate mechanisms. Flag with a shrink/simplify direction.

## Report

Findings ranked by severity, each with:

```text
[severity] Title
Evidence: path:line or output
Impact: ...
Direction: (what to do, not a patch)
```

End with a verdict: `merge as-is | merge with fixes | needs work`, and a
"what was done well" line.

## Rules

- Read-only: no modifications.
- Evidence required for every finding.
- Review the change, not the author: precise, not personal.
