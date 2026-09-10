# Alt Lab LLM Agent Invocation Guide

Alt Lab LLM Agent supports three operating modes.

## Plugin mode

Use this mode in Claude Cowork or Codex to install the `alt-lab-llm-agent` plugin directly from GitHub — no prompt to paste, no repository access needed at chat time.

- Claude Cowork: Customize → Plugins → **+** → Add marketplace, then paste `https://github.com/BCHTaimor/alt-lab-claude-scientific`. Reads [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json).
- Codex: Settings (or your workspace's Admin panel) → Plugins → Add → Import marketplace, then paste the same URL. Reads [.agents/plugins/marketplace.json](.agents/plugins/marketplace.json). Menu wording may vary slightly by Codex version.

Both point at the same [alt-lab-llm-agent](alt-lab-llm-agent/) plugin directory, so skill content stays identical across platforms.

## Agent mode

Use this mode in Codex, Claude Code, or another runtime that can read the repository.

- Codex: open the repository as the project. Codex discovers `AGENTS.md`.
- Claude Code: open the repository as the project. Claude Code discovers `CLAUDE.md`, which imports the canonical shared instructions.

In agent mode, the manager may delegate bounded work to the Literature Review and Coding specialists when the runtime supports subagents.

## Web injection mode

Use this mode only for ChatGPT, which has no marketplace-style plugin install for this repository. The injected prompt is self-contained, but it attempts to refresh itself from the canonical repository when the platform has browsing, connectors, or local-file access. Claude and Codex users should use Plugin mode instead of pasting a prompt.

- ChatGPT: copy [the ChatGPT injection](adapters/web/chatgpt.md) into a new chat or ChatGPT Project instructions.

Web injection mode applies the same manager and specialist responsibilities inside one conversation. On server `RDT01154`, it tries `/Volumes/taimor/alt-lab-claude-scientific` and then `/storage2/researchers/taimor/alt-lab-claude-scientific`. Otherwise, or when those paths are unavailable, it tries `https://github.com/BCHTaimor/alt-lab-claude-scientific`. If live access fails, it discloses that once and continues from the embedded baseline. It never claims to run independent agents or to have read files it could not access.

The repository is the canonical source. Platform adapters are projections and must not become independent policy copies.
