---
name: research
description: Technical research before making a decision — repository evidence, documentation, external sources, inference. Clearly distinguishes known-from-repo, known-from-docs, external research, inference, and unverified assumptions. Use when the user asks to research, compare options, or verify a technical claim. Never present a guess as fact.
---

# Research

Answer technical questions with clearly labeled evidence.

## Source ladder

Can the question be answered by (stop at first that truly answers it):

1. **Repository** — code, configs, tests, history.
2. **Local tools/docs** — installed package docs, `--help` output, changelogs.
3. **Documentation** — official docs of the framework/library in use.
4. **External research** — web sources (only if 1-3 are insufficient).
5. **Inference** — reasoned from the above; label it.
6. **Unverified assumption** — say so explicitly, never disguise it.

## Workflow

1. **State the question** in one line.
2. **Work the ladder.** Fetch web content only when the repository and local
   docs cannot answer. For external claims, verify against a second source
   when the decision is significant.
3. **Report.** Label every fact with its source class:

```text
[repo]        Found in code/tests (cite path:line)
[docs]        Official documentation (cite URL)
[external]    Other web source (cite URL)
[inference]   My reasoning from the above
[assumption]  Not verified — what would confirm/refute it
```

4. **Conclusion.** One short paragraph: what the evidence supports, the
   confidence level, and what remains open.

## Rules

- Prefer repository evidence over documentation, documentation over web.
- Cite specific URLs and paths; no uncited claims.
- Distinguish "the docs say X for version Y" from "X is probably true".
- Research is read-only: no changes to the project.
