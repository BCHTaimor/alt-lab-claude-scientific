# AGENTS.md

# AI Project Working Guidelines

This document defines the standard operating procedures for all AI coding agents working on this project, including (but not limited to) ChatGPT Codex, Claude Code, Gemini CLI, Cursor, and future AI assistants.

These guidelines should be followed unless explicitly overridden by the user.

The full policy is split into the numbered topics below. Coding/repo-specific topics live alongside this file; a few general AI-conduct topics (language, date/time, logging, philosophy) apply beyond coding and live at the root of the folder instead. Read them all before starting work; each is short and covers one topic.

1. [Fundamental Principles](01-fundamental-principles.md) — the non-negotiable rules: never touch `original/`, preserve reproducibility and traceability.
2. [Language Policy](../language-policy.md) — primary user language, English-only source code, and bilingual reports.
3. [Date and Time Policy](../date-and-time-policy.md) — how to establish and confirm the working date, including the pre-5 AM rule.
4. [Standard Project Structure](04-standard-project-structure.md) — the `original/ input/ scripts/ output/ work_flows/ reports/` layout and what belongs in each.
5. [File Naming Convention](05-file-naming-convention.md) — `name.YYYYMMDD.ext` naming and versioning.
6. [Workflow Files](06-workflow-files.md) — recording reproducible Bash workflows, command documentation, and timing.
7. [Analysis Reports](07-analysis-reports.md) — required HTML report sections (Background, Objectives, Input Data, Methods, Results, Interpretation, References).
8. [Report Preservation](08-report-preservation.md) — never overwrite timestamped reports; when edits to old reports are allowed.
9. [Programming Guidelines](09-programming-guidelines.md) — preferred languages and tools (R/ggplot2, Perl/Python, Bash).
10. [Reproducibility](10-reproducibility.md) — analyses must regenerate from `original/ input/ scripts/ work_flows/` alone.
11. [Data Integrity](11-data-integrity.md) — never modify `original/` or `AGENTS.md`.
12. [Output Policy](12-output-policy.md) — date/time-stamped output filenames, no generic overwritten files.
13. [Chat History Logging](../chat-history-logging.md) — the append-only `chat_history.log` format, entry types, spacing, and ordering rules.
14. [Git Guidelines](14-git-guidelines.md) — commit cadence and message style.
15. [AI Collaboration](15-ai-collaboration.md) — checklist before starting and before finishing work.
16. [General Philosophy](../general-philosophy.md) — the project must be understandable and reproducible without the original author.
17. [Output Organization Policy](17-output-organization-policy.md) — how to organize `output/` as it grows.
