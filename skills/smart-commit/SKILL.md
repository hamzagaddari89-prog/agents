---
name: smart-commit
description: Safely organize and create local Git commits for completed agent work. Classifies working-tree changes by task ownership, plans minimal logical commits, reuses existing verification, stages only reviewed files or hunks, protects against HEAD/index races, follows repository commit style, and never pushes. Use after implementation and appropriate test/verify/review evidence when the user asks to commit, save completed work in Git, or run smart-commit.
---

# Smart Commit

Create safe **local** commits after Ponytail-guided work. Reuse the existing
`test`, `verify`, and `review` capabilities; this skill owns only commit
classification, batching, staging, race checks, message choice, and reporting.

## Workflow

`DISCOVER -> UNDERSTAND -> CLASSIFY -> PLAN -> SAFETY -> VERIFY -> STAGE -> RECHECK -> MESSAGE -> COMMIT -> REPORT`

### 1. Discover without mutation

Record `git status --short --branch`, `git diff`, `git diff --staged`, the
current branch, `git rev-parse HEAD`, and recent commit messages. Do not stage,
restore, stash, or otherwise mutate Git state during discovery. Treat anything
already staged as unowned until its origin is established.

### 2. Understand and classify

Relate each file and, when needed, each hunk to the current task and its known
baseline:

- **TASK** - confidently attributable to the current task.
- **PRE-EXISTING** - known to predate the task or known to be unrelated.
- **AMBIGUOUS** - ownership cannot be established confidently.

Only TASK changes are eligible for automatic commit. PRE-EXISTING changes must remain untouched.
AMBIGUOUS changes must remain untouched and be reported.
Existing staged content is not permission to commit it. A mixed-ownership file
is TASK only at the proven hunk level; if safe selection is not possible,
classify the file as AMBIGUOUS.

### 3. Plan logical commits

Group TASK changes into the smallest sensible commits. Prefer one commit for
one coherent change. Split only independently meaningful work, such as an
unrelated infrastructure repair, independent bug fixes, or genuinely separate
generated/documentation output. Do not manufacture micro-commits. Reject empty
groups.

### 4. Safety gate

Inspect each proposed staged diff for secrets or credentials, conflict markers,
unexpected sensitive files or binaries, unusually large files, unexplained
generated artifacts, accidental environment/config files, and unrelated
changes. Use existing scanners without globally disabling them; test
placeholders are not real secrets without evidence. A credible secret or any
unresolved ownership/safety risk stops the affected commit and is reported.

### 5. Verify proportionately

Require evidence appropriate to the change before committing. Reuse the
existing test, verify, and review workflows rather than reimplementing them.
Documentation-only changes need focused checks, not an unrelated expensive
suite; code or infrastructure changes need relevant runnable evidence. Never
claim a check that was not run. If required verification fails, do not commit
the affected group.

### 6. Stage exactly

Stage only reviewed TASK paths or hunks. Never use `git add .` or `git add -A`
when unrelated or ambiguous changes may exist. Use explicit pathspecs for
whole-file TASK changes and safe selective staging for mixed files. Do not use
an interactive command unless the environment supports it safely; otherwise
leave the mixed file AMBIGUOUS. After staging, inspect `git diff --staged` and
confirm every staged byte belongs to exactly one planned group.

### 7. Recheck races immediately before commit

Capture the reviewed HEAD (`git rev-parse HEAD`) and reviewed staged-tree ID
(`git write-tree`). Immediately before each commit, read both again. If HEAD or
the staged-tree ID differs unexpectedly, **STOP**, do not commit, and report
the race/change. Also stop if the staged diff is empty or includes content
outside the reviewed group. After an intentional earlier commit in the same
plan, adopt its resulting HEAD only after confirming its hash and the remaining
index match the plan.

### 8. Choose the message from evidence

Inspect recent commit subjects for sufficient consistent evidence of the
repository convention: Conventional Commits, plain imperative messages, or a
project-specific style. Follow that style; when history is mixed or sparse,
use a concise plain imperative subject rather than forcing Conventional
Commits. Derive the message from the task intent **and actual staged diff**, not
from intended work that is absent from the index.

### 9. Commit locally and report

Create only the planned local commit, then report concisely:

- commit hash and message;
- committed files;
- verification commands/evidence;
- remaining PRE-EXISTING changes;
- remaining AMBIGUOUS changes.

An intentionally dirty working tree is not a failure.

## Prohibited operations

**NO automatic push.** Never perform `git push`, force push, remote mutation,
`git reset --hard`, `git clean`, `git checkout -- .`, restoration or stashing
of unrelated work, history rewriting, interactive rebase, automatic squash,
automatic amend, or branch deletion. V1 ends after the local commit/report.
