# Claude Code Adapter

Claude Code reads the root `CLAUDE.md`. It imports the canonical `AGENTS.md`, `SOUL.md`, `IDENTITY.md`, and `USER.md`, then adds only Claude-specific loading and delegation guidance.

Project specialist definitions live in `.claude/agents/`. They point back to the canonical specialist identities and workflows so the Claude adapter does not become a competing source of truth.

