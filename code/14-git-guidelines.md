# Git Guidelines

Use Git for version control.

Remote repositories are optional.

GitHub is NOT required.

An AI agent may inspect Git status and history when relevant to the task, but it must obtain explicit user approval before staging files, creating commits, or pushing to a remote.

An AI agent may prepare a proposed commit and summarize the files that would be included before asking for approval.

Treat these actions as separate permissions:

- inspecting status or history
- staging files
- creating a commit
- pushing to a remote

Update `chat_history.log` promptly, but treat it as operational metadata: include it only in substantive task commits when convenient, and never create additional Git commits solely because `chat_history.log` changed or to record the chat-history entry describing a commit.

Recommended commit messages:

```
Add

Update

Fix

Refactor

Report
```

Commit messages should briefly describe the completed work.
