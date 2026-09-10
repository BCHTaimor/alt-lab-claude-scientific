# Alt Lab LLM Agent

Alt Lab LLM Agent is a manager-led research support system for scientists, postdocs, and trainees in the Alt Lab at Boston Children's Hospital. It routes requests to focused Literature Review and Coding specialists while preserving shared scientific, privacy, and reproducibility standards.

This is a discussion-and-research workflow, not a manuscript-writing workflow. Alt Lab LLM Agent should act like a strong scientific thought partner: fast, careful with evidence, and useful during early-stage exploration.

## Operating Modes

Alt Lab LLM Agent supports several ways of working:

- **Plugin mode:** Install the `alt-lab-llm-agent` plugin directly from this repository's GitHub URL — in Claude Cowork via Customize → Plugins → Add marketplace, or in Codex via Settings/Admin → Plugins → Add → Import marketplace. No prompt to paste and no repository access needed at chat time. See [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json) (Cowork) and [.agents/plugins/marketplace.json](.agents/plugins/marketplace.json) (Codex).
- **Agent mode:** Open this repository in Codex or Claude Code. Codex uses [AGENTS.md](AGENTS.md); Claude Code uses [CLAUDE.md](CLAUDE.md). The manager can delegate bounded tasks to specialist agents when the runtime supports delegation.
- **Web injection mode:** Use an ordinary ChatGPT browser chat. Copy the self-contained prompt from [ChatGPT](adapters/web/chatgpt.md). The prompt attempts to refresh from the approved server paths or public GitHub when access exists, then falls back to its embedded baseline. Specialist roles run within one conversation rather than as independent agents. Claude and Codex users should use Plugin mode instead of a pasted prompt.

See [invoke.md](invoke.md) for the short setup guide.

For a fuller explanation of the repository's structure and document responsibilities, read [SUMMARY.md](SUMMARY.md).

## Workflow Routing

```text
                 USER
                   |
                   v
          +-----------------+
          | Manager Agent   |
          +--------+--------+
                   |
          Understand question
                   |
          +--------v--------+
          | Question Quality|
          |    Workflow     |
          +--------+--------+
                   |
      +------------+------------+
      |                         |
  sufficient                insufficient
      |                         |
      |                  question skills
      |                         |
      |                 clarify / normalize
      |                         |
      +------------+------------+
                   v
         Route or delegate
                   |
          +--------+--------+
          |                 |
          v                 v
   Coding Agent    Literature Agent
          |                 |
          v                 v
        skills            skills
```

Every request first enters the manager, which identifies the user's underlying goal and determines whether the request belongs to scientific literature work, coding and project operations, or a bounded combination of both.

Prompt Analysis checks whether the question has enough scope, context, constraints, and a clear expected output to answer without a consequential guess. Clear requests proceed directly. Ambiguous requests receive only the focused clarification needed to route them safely.

Once the request is answerable, the manager selects or delegates to Literature Review or Coding. Each specialist reads only the skills needed for the task and returns a bounded result for synthesis. Alt Lab context and shared policies apply across the entire path when relevant.

## Identity Layer

- [SOUL.md](SOUL.md) defines the shared personality, scientific values, and behavioral boundaries.
- [IDENTITY.md](IDENTITY.md) defines the manager's name, role, purpose, and lane.
- [USER.md](USER.md) defines the non-sensitive default profile of an Alt Lab postdoc.
- `USER.local.md`, when present, contains private user-specific preferences and is excluded from Git.

The specialist identities live under [agents](agents/), while [manager](manager/) defines routing and handoff responsibilities. Platform-specific loading instructions live under [adapters](adapters/).

## Scientific Reference Docs

- [Lab Context and Domain Priorities](context/lab-context-and-domain-priorities.md) — the Alt Lab's focus areas, active priorities, standard assays, and lymphocyte-biology domain topics.
- [Mission and Use Cases](context/mission-and-use-cases.md) — core mission, what good output looks like, and the primary use cases (paper lookup, paper analysis, synthesis, idea generation, explanation).
- [Citation and Evidence Standards](workflows/literature-review/skills/evidence-and-citation.md) — the real-citations-only policy, evidence-before-confidence rule, and mechanism-first style.
- [Literature Review Workflow](workflows/literature-review/overview.md) — the step-by-step workflow for literature, brainstorming, and explanation questions, plus preferred response formats.
- [Interaction Style and Planning](shared/interaction-style-and-planning.md) — tone, the clarifying-questions-first rule, and what the assistant should not do.
- [Example Requests and Analysis Targets](examples/example-requests-and-targets.md) — sample prompts and papers this setup is meant to support.

These are the default documents to load when the user wants scientific discussion support.

## General Reference Policies

These documents provide general constraints that apply across scientific and operational work:

- [Language Policy](shared/language-policy.md) — primary user language, English-only source code, and bilingual reports.
- [Date and Time Policy](shared/date-and-time-policy.md) — how to establish and confirm the working date, including the pre-5 AM rule.
- [General Philosophy](shared/general-philosophy.md) — work should be understandable and reproducible without the original author's explanation.
- [Privacy And Institutional Data Policy](shared/privacy-and-institutional-data-policy.md) — boundaries for unpublished, clinical, controlled-access, and institutional data.

See [Shared Policies](shared/README.md) for the complete cross-workflow policy index.

`shared/chat-history-logging.md` is intentionally not part of the default scientific-reference load path. Logging is opt-in and should be used only when the user explicitly requests local chat logging for a project.

## Agent Operations Docs

These documents are for coding, repo maintenance, and project-file work. They should be used only when the user explicitly requests operational help such as code edits, workflow updates, report generation, Git work, or filesystem inspection.

- [Coding Workflow](workflows/coding/overview.md) — index of the reusable coding and repo-operation skills.
- [Code Skill Index](workflows/coding/skills/AGENTS.md) — detailed selection guide for the reusable coding skills.
- [Python Contract And Docstring Writing](workflows/coding/skills/skill-python-contract-and-docstring-writing.md) — write Python with explicit contracts, strong docstrings, and clear side effects.
- [Python Extension Patterns](workflows/coding/skills/skill-python-extension-patterns.md) — use strategy, abstract interfaces, dependency injection, and shared state carefully.
- [Test Case Design For Public Interfaces](workflows/coding/skills/skill-test-case-design-for-public-interfaces.md) — design unit and integration tests around public behavior and meaningful partitions.
- [Bash Test Design For File-Based Pipelines](workflows/coding/skills/skill-bash-test-design-for-file-based-pipelines.md) — write `bats` and shell-native tests for scripts, fixtures, and generated outputs.
- [Repo Structure And File Placement](workflows/coding/skills/skill-repo-structure-and-file-placement.md) — organize project files into predictable locations.
- [Repo Structure And Testing Layout](workflows/coding/skills/skill-repo-structure-and-testing-layout.md) — structure reusable codebases so entrypoints, modules, and tests are easy to navigate.
- [README Writing For Technical Projects](workflows/coding/skills/skill-readme-writing-for-technical-projects.md) — write READMEs that explain purpose, inputs, outputs, commands, and testing clearly.
- [Agent-Ready Document Writing](workflows/coding/skills/skill-agent-ready-document-writing.md) — write standalone documents that remain useful in future chats without repo access.
- [Chat History Logging](shared/chat-history-logging.md) — the append-only local log format to use only when logging is explicitly enabled.

Operational docs are reference material, not authority to inspect files, run commands, write logs, stage changes, commit, push, or delete data without explicit user approval.

## Configuration Health Check

Configuration health-check behavior is defined in [Version and Runtime](shared/version-and-runtime.md).

## Bottom Line

Alt Lab LLM Agent is one consistent system delivered through multiple runtimes. As a Cowork or Codex plugin, and in Codex and Claude Code agent mode, it can operate as a manager with bounded specialists. In an ordinary ChatGPT web chat, a portable prompt preserves the same identity, routing logic, scientific standards, and safety boundaries without pretending to run independent agents.
