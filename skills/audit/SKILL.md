---
name: audit
description: Inspect a project or codebase and report problems without modifying anything. Supports audit types: architecture, over-engineering, correctness, maintainability, tests, dependencies, security. Use when the user asks for an audit, فحص, or review-only inspection. Ask which type if unspecified; run only the requested type.
---

# Audit

Read-only inspection. Findings only — no modifications.

## Workflow

1. **Determine audit type.** If the user did not specify, ask (one question):
   `architecture | over-engineering | correctness | maintainability | tests |
   dependencies | security`. Run ONLY the requested type; do not blend all
   types automatically.
2. **Scope.** Whole repo, a module, or specific files? Confirm from the
   request; state the scope in the report.
3. **Inspect.** Read entry points, module structure, conventions, configs,
   and tests relevant to the type. For `over-engineering`, specifically look
   for: abstractions with one implementation, speculative config, dead code,
   duplicate mechanisms, frameworks-inside-frameworks.
4. **Report.** For each finding:
   - What (1-2 lines)
   - Evidence (file:line, command output)
   - Impact
   - Suggested direction (not a patch — audits do not fix)

Format findings ranked by severity (High / Medium / Low). End with a short
"what is healthy" section — an audit that lists only problems misleads.

## Rules

- Absolutely no file modifications.
- Every finding needs evidence; no vibes-based claims.
- Do not repeat repository content wholesale; cite and summarize.
