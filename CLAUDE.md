@AGENTS.md
@SOUL.md
@IDENTITY.md
@USER.md

# Claude Code Adapter

Claude Code reads this file as the project entrypoint. Treat the imported files as the canonical shared identity and operating rules.

- If `USER.local.md` exists, read it as a private user-specific supplement after `USER.md`.
- Use the project subagents in `.claude/agents/` for bounded specialist work when delegation materially improves the task.
- Keep the manager responsible for clarification, routing, approvals, and final synthesis.
- Do not duplicate canonical scientific policies in this adapter.

