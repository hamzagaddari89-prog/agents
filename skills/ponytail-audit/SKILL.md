---
name: ponytail-audit
description: >
  Audit the whole repository for over-engineering. Return a ranked list of
  code to delete, simplify, or replace with standard-library or native
  features. Use for repo bloat or /ponytail-audit.
license: MIT
metadata:
  source: https://github.com/DietrichGebert/ponytail
---

# Ponytail Audit

Scan the whole repository, not only the current diff, for unnecessary
complexity. Do not apply fixes. Correctness bugs, security holes, and
performance issues are out of scope.

Hunt for dependencies the standard library or platform already provides,
single-implementation interfaces, one-product factories, delegation-only
wrappers, files exporting one thing, dead flags/configuration, and hand-rolled
standard-library behavior.

Return one ranked line per finding, largest cut first:

`<tag> <what to cut>. <replacement>. [path]`

Use `delete`, `stdlib`, `native`, `yagni`, and `shrink` tags. End with
`net: -<N> lines, -<M> deps possible.` If there is nothing to cut, say
`Lean already. Ship.`
