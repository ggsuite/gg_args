<!--
@license
Copyright (c) ggsuite

Use of this source code is governed by terms that can be
found in the LICENSE file in the root of this package.
-->

# Update the DNA from dna_ggsuite 0.2 to 1.0

## Motivation

- gg_args adds commands, runners and helpers to the `args` package
- Its guides, skills, Claude hooks and editor settings are not written by
  hand: the DNA generates them from `dna_ggsuite`
- The repo was still on `dna_ggsuite` 0.2: no `CLAUDE.md`, skills without
  the `gg-` prefix, and an AI dev guide without project management repo,
  plan or publish config
- The change is about docs and tooling: no code, test or API changes

## Strategy

- Raise `dna_ggsuite` to ^1.0.0 and `helix` to ^1.13.0
- Rebuild the DNA and commit the generated files as they come
- Raise the other constraints to their current releases
- Leave `lib/` and `test/` untouched

## Implementation 1: The ticket workflow for AIs

- `CLAUDE.md` is new: its managed block loads the AI dev guide and names
  the workflow skills
- `/ticket`, `/commit`, `/push`, `/publish` and `/cleanup` become
  `/gg-ticket`, `/gg-commit`, `/gg-push`, `/gg-publish` and `/gg-cleanup`;
  `/gg` names the next step
- The new `/gg-review` writes the blog posts and README.md before it opens
  the pull requests, so they are reviewed with the code
- The AI dev guide adds an optional project management repo, a manual or
  automatic choice of repos, optional plan and implementation, and
  `.gg/publish_config.json` with commit message, merge message and version
  increment
- Rules for tickets with several repos: describe every repo in its own
  terms, keep every repo in its scope, keep `index.jsonc` current
- `/gg-cleanup` no longer calls `scripts/delete-feature-branch.js`; a trial
  merge tells whether a squash-merged branch is in `main`

## Implementation 2: Writing rules

- Every class offers an `example` constructor, and tests build their
  objects through it; `/code` reports classes without one, `/test` objects
  built by hand
- Type names no longer need the package prefix
- Blog posts go to `doc/blog/<yyyy>`, describe this repo only and have a
  "Dependency updates" section
- README guide and template are rewritten: motivation, usage, limitations,
  license, English and German; `scripts/check-readme.js` checks the result

## Implementation 3: Tooling

- `.prettierrc` and `.prettierignore` are new; prettier skips the generated
  files, which must stay equal to their DNA originals byte for byte
- VS Code gets the license header template for Markdown files
- `doc/guides/setup-github-guide.md` explains `setup-github-repo.js`; the
  script now brings its own colors and command runner, and
  `get-repo-urls.js` takes the organization as an argument
- Hooks in `.claude/settings.json` keep the prompts in the project
  management repo; `pm-prompts.json` names none, so they stay idle here

## Dependency updates

- `dna_ggsuite` 1.0.0 pulls in `dna_gg` 1.0.0, `dna_clean_code` 0.2.2,
  `dna_readme` 0.3.1, `dna_vscode` 0.4.0 and `dna_github` 0.1.1, the
  sources of the files above
- `helix` 1.13.0 joins the `CLAUDE.md` parts of all DNA layers instead of
  letting the last layer win
- `gg_capture_print` ^1.2.0, `gg_console_colors` ^2.5.0 and `gg_process`
  ^1.3.0: releases that changed their pipelines and DNA, not their API
- `test` ^1.33.0

## Result

- The checks for commit and push pass on Windows; `.gg/gg.json` records
  them

## Open Points

- The repo has no `index.jsonc` yet, which the new guide asks of every
  repo of a ticket
- README.md holds the title and one sentence; `check-readme.js` misses
  Motivation, Installation, Usage, License and `README.de.md`
- `GgCommandRunner` and `UnknownSubCommandRunner` have no `example`
  constructor yet
