---
description: create a focused git commit
model: opencode/glm-4.6
subtask: true
---

Create a git commit for the current changes.

Do not push unless I explicitly ask for it.

make sure it includes a prefix like
docs:
tui:
core:
ci:
ignore:
wip:

<!-- For anything in the packages/web use the docs: prefix. -->
<!---->
<!-- For anything in the packages/app use the ignore: prefix. -->

prefer to explain WHY something was done from an end user perspective instead of
WHAT was done.

do not do generic messages like "improved agent experience" be very specific
about what user facing changes were made

Before committing:
- inspect staged and unstaged changes
- follow the repo's existing commit style when possible
- do not include unrelated files

If there are no relevant changes, do not create an empty commit.

If a push is explicitly requested and a pull/rebase is needed, do not resolve conflicts yourself. Notify me instead.
