# Agents

Rules for AI coding agents working in this repo.

## Git history

- **Never amend, squash, or rewrite commits that have been pushed to `dev`.**
  Every push to `dev` runs tests (`.github/workflows/test.yaml`), and on
  success `.github/workflows/release.yaml` automatically merges `dev` into
  `master` via the `devmasx/merge-branch` action. Rewriting a commit that is
  already on `master` makes the branches diverge, so the next automated
  merge either conflicts (and the CI merge cannot be resolved interactively)
  or duplicates the change on `master`. Fix mistakes with a new commit.
- **Recovery exception:** if `dev` has diverged from `master` (e.g. a commit
  was rewritten before this rule was added), rebase `dev` onto `master` and
  force-push `dev`. This rewrites only `dev` — never `master` — and restores
  a clean automated merge.
- Never push directly to `master` — the release CI job owns it.
