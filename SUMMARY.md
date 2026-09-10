# Repository Summary

This repository defines Alt Lab LLM Agent 2.0 as a manager-and-specialist research-support system for the Alt Lab. One canonical set of identity, context, workflow, and policy documents is projected into multiple runtime adapters.

## Core identity

[SOUL.md](SOUL.md) defines character and scientific values. [IDENTITY.md](IDENTITY.md) defines the manager's role. [USER.md](USER.md) provides a non-sensitive Alt Lab postdoc default that can be supplemented locally.

## Manager and specialists

[manager](manager/) owns intake, Prompt Analysis, routing, handoffs, and synthesis. [agents](agents/) defines the Literature Review and Coding lanes. Existing material under [workflows](workflows/) remains the canonical procedure library used by those specialists.

## Context and policies

[context](context/) contains Alt Lab scientific background. [shared](shared/) contains cross-cutting evidence, interaction, privacy, language, date, reproducibility, and runtime policies.

## Runtime adapters

- Claude Cowork installs the `alt-lab-llm-agent` plugin via [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json).
- Codex installs the same plugin via [.agents/plugins/marketplace.json](.agents/plugins/marketplace.json), or discovers [AGENTS.md](AGENTS.md) directly in agent mode.
- Claude Code discovers [CLAUDE.md](CLAUDE.md) and project specialists under `.claude/agents/`.
- ChatGPT web uses [adapters/web/chatgpt.md](adapters/web/chatgpt.md) — the only remaining web-injection prompt, since Claude and Codex install the plugin instead.

Agent and plugin modes can use real delegation when supported. Web injection mode applies the same responsibilities within one conversation, attempts an approved local-server or GitHub refresh, and reports whether that refresh succeeded. It must not claim independent agents or repository access that did not occur.

## Acceptance tests

[examples](examples/) and [validation](validation/) document expected routing, mode selection, privacy, and specialist handoff behavior. Use [README.md](README.md) for onboarding and [invoke.md](invoke.md) for deployment choices.
