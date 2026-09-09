---
name: ponytail-review
description: >
  Review a diff only for over-engineering: unnecessary dependencies,
  abstractions, dead flexibility, and code that can be deleted or shrunk.
  Use for over-engineering review, simplify review, or /ponytail-review.
license: MIT
metadata:
  source: https://github.com/DietrichGebert/ponytail
---

# Ponytail Review

Review the current diff, or the target supplied by the user, exclusively for
unnecessary complexity. Do not review correctness, security, or performance;
route those to a normal review. Do not apply fixes.

Give one line per finding in this format:

`L<line>: <tag> <what>. <replacement>.`

Use these tags:

- `delete:` dead code, unused flexibility, or speculative features; replacement
  is nothing.
- `stdlib:` hand-rolled functionality provided by the standard library; name
  the function.
- `native:` code or a dependency replaced by a platform feature; name it.
- `yagni:` an abstraction with one implementation, unused configuration, or a
  layer with one caller.
- `shrink:` the same logic can be expressed in fewer lines; show the shorter
  form.

Rank findings by the size of the possible simplification. End with
`net: -<N> lines possible.` If there is nothing to cut, say `Lean already. Ship.`
