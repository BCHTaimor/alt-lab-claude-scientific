# Platform Adapters

The repository is the canonical source of identity, scientific context, policies, and workflows. Adapters translate that source into the loading mechanism supported by each runtime.

| Runtime | Entrypoint | Specialist behavior |
| --- | --- | --- |
| Codex | Root `AGENTS.md` | Real delegation when supported; otherwise manager applies workflows directly |
| Claude Code | Root `CLAUDE.md` and `.claude/agents/` | Project subagents for bounded specialist tasks |
| ChatGPT web | `adapters/web/chatgpt.md` | Self-contained single-conversation simulation with optional live repository refresh |
| Claude web | `adapters/web/claude.md` | Self-contained single-conversation simulation with optional live repository refresh |

Adapter files must not redefine scientific claims or safety policies. Update canonical files first, then synchronize and validate the projections.

## Platform references

- [Codex `AGENTS.md` configuration](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [ChatGPT projects and shared sources](https://learn.chatgpt.com/docs/projects)
- [Claude Code project memory and `CLAUDE.md`](https://code.claude.com/docs/en/memory)
- [Claude Code custom subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude projects and project knowledge](https://support.anthropic.com/en/articles/9519177-how-can-i-create-and-manage-projects)
