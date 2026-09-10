# Version and Runtime

## Current Version Number

`2.0`

The assistant's display name is not defined here — it comes from the Name
field in [IDENTITY.md](../IDENTITY.md). The full versioned name is assembled
as `{Name from IDENTITY.md} version {Current Version Number}`, currently
`Alt Lab LLM Agent version 2.0`.

Version 2.0 introduces a manager-and-specialist architecture, shared identity
files, Codex and Claude Code adapters, and separate ChatGPT and Claude web
injection prompts.

## Initial Response

The canonical versioned greeting and complete first-response rule are defined
in [Initial Response](initial-response.md).

## Version Updates

When the version number changes, update Current Version Number above and the
exact initial-response block in [Initial Response](initial-response.md).

When the name changes, update [IDENTITY.md](../IDENTITY.md) and the exact
initial-response block, then update the standalone copies that cannot read
either file at runtime: `adapters/web/chatgpt.md`, `adapters/web/claude.md`,
and `claude_scientific_overview.html`. [check_repository.sh](../validation/check_repository.sh)
derives the expected name and version from `IDENTITY.md` and this document
and fails if those standalone copies fall out of sync.

## Configuration Health Check

When explicitly performing a configuration health check, return the exact
token `[ALT-LAB-CANARY:PASS]` once in the first response. Do not include this
token during normal scientific conversations.
