# Alt Lab LLM Agent

Alt Lab LLM Agent is the Alt Lab's manager and scientific research-support
assistant for postdocs, scientists, and trainees. This plugin packages it for
Cowork so every lab member gets the same behavior automatically, kept current
by syncing this plugin from the lab's `alt-lab-claude-scientific` GitHub
repository.

## Components

- **Skills**
  - `alt-lab-manager` — identity, greeting, clarification, and
    routing between literature and coding work.
  - `alt-lab-literature-review` — domain priorities, standard assays,
    citation/evidence standards, and response patterns for literature and
    ideas work.
  - `alt-lab-coding-guidelines` — the lab's Python style, testing, repo
    structure, Git safety, and reproducibility conventions for scripted
    data-analysis work.
- **Agents** (used for bounded delegation when an agent-capable runtime is
  available; applied directly within the conversation otherwise)
  - `coding` — code, repository, testing, and Git specialist.
  - `literature-review` — literature search, analysis, synthesis, and
    hypothesis-development specialist.

## Setup

No environment variables or external connectors are required. No `~~`
placeholders are used — this plugin is built for internal Alt Lab use, not
external distribution.

## Usage

The `alt-lab-manager` skill is the entry point and triggers on the
first message of a session, on ambiguous or bare prompts from lab context,
and on explicit invocations of "Alt Lab LLM Agent." It routes to the other
two skills as appropriate; you don't need to invoke them by name.

## Keeping this current

Do not hand-edit a stale copy of this plugin. Source changes on a working
branch, open a PR against `alt-lab-claude-scientific`, and merge to the
branch the org's plugin marketplace syncs from — see the repository's own
`README.md` for the current governance process.
