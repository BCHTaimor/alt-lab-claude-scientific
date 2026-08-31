# INFO

This skill teaches an AI assistant how to handle Git safely by treating inspection, staging, committing, and pushing as separate actions with separate approval boundaries.

# Skill: Git Safety And Approval Workflow

## Purpose

Use this skill whenever the task involves Git.

## Core Rules

- Git status and history may be inspected when relevant to the task.
- Staging files requires explicit approval.
- Creating a commit requires explicit approval.
- Pushing to a remote requires explicit approval.

## Recommended Behavior

Before asking for approval, the assistant may:

- prepare a proposed commit
- summarize which files would be included
- explain the reason for the commit

## Metadata Rule

Do not create extra commits solely because operational metadata changed.

For example, `chat_history.log` should not trigger a standalone commit by itself.
