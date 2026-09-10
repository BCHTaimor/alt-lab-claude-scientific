# Codex Adapter

Codex discovers the root `AGENTS.md`, which acts as the manager entrypoint. That file directs Codex to the shared identity, Prompt Analysis manager, and specialist definitions.

Optional custom Codex-agent configuration can be generated under `.codex/agents/` on hosts that permit project-level Codex configuration. The canonical specialist prompts remain in `agents/`; no scientific policy should live only in a `.codex` file.

This directory includes `literature-review.toml.example` and `coding.toml.example` as portable examples. Copy them into `.codex/agents/` only when the host permits project-level Codex configuration. The root manager can still delegate with runtime-created subagents when these optional profiles are not installed.

