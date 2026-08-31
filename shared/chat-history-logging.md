# Chat History Logging

Chat-history logging is opt-in.

Do not create or update `chat_history.log` unless the user explicitly requests local chat logging for the current project or task.

If logging is enabled, maintain an append-only conversation log for that task or working directory.

Recommended filename:

```text
chat_history.log
```

The log should record:

* the user's prompts
* user steering or follow-up instructions
* the AI's user-visible responses, including progress updates and final responses
* the main files created or updated by the AI
* the paths of those files

If logging is not explicitly enabled, do not create a log file, do not append to an existing log file, and do not infer consent from the presence of older logs.

Use the established local time for all timestamps.

For each user-visible AI message, capture the timestamp at the time the message is emitted or as close to emission as practical. If chat-history entries are written in a batch later, preserve the originally captured timestamp for each message; do not assign the same final write-time timestamp to multiple earlier messages. Exact second-level precision is preferred when available, but chronological correctness is more important than repeatedly querying the system clock.

Keep new `chat_history.log` entries in chronological order whenever practical. Do not overwrite, rewrite, reorder, or delete previous log entries unless the user explicitly requests it.

## Privacy And Storage Restrictions

Logs must remain local by default.

Do not commit, upload, sync, or share `chat_history.log` unless the user explicitly requests that action for the current task.

Do not record unpublished results, protected health information, personally identifiable information, controlled-access genomic data, confidential manuscript or peer-review content, credentials, private keys, session cookies, or identifiable sample metadata.

Redact sensitive paths, identifiers, and tokens when necessary, and mark the redaction clearly.

`chat_history.log` should be listed in `.gitignore` unless the user has a specific, reviewed reason to version it.

## User Prompt Entries

Record each user prompt using the following format:

```text
[YYYY-MM-DD HH:MM:SS] Query:
<user prompt>
```

For example:

```text
[2026-07-15 15:08:34] Query:
Please analyze the input files and generate a report.
```

Preserve the substantive content of the user's prompt. Minor normalization of line endings or surrounding whitespace is acceptable, but do not summarize or reinterpret the prompt.

## AI Response Entries

After completing the response, record the AI's user-facing answer using the following format:

```text
[YYYY-MM-DD HH:MM:SS] Answer:
<AI chat response>

Output files:
<main output file paths>
```

For example:

```text
[2026-07-15 15:08:55] Answer:
The analysis has been completed. The main results and interpretation are included in the generated reports.

Output files:
/project/reports/report.en.20260715_150855.html
/project/reports/report.zh.20260715_150855.html
/project/output/summary.20260715_150855.tsv
```

`chat_history.log` is operational metadata and should not be listed under `Output files` when it is the only file changed. List `chat_history.log` only when the user explicitly asks for the log itself as a deliverable.

For pure conversation, rule discussion, status updates, or chat-history corrections, omit the `Output files:` section entirely unless another substantive output file was created or materially updated.

List the main output files using their actual paths only when files were newly created or materially updated.

Include files that were newly created or materially updated as part of the response. Do not list incidental temporary files, caches, lock files, or automatically generated intermediate files unless they are important for reproducibility.

If no output files were created or updated, omit the `Output files:` section entirely.

Do not include the contents of generated files in the log unless the user explicitly requests this. Record their paths instead.

## Final Response Logging

The final user-visible response must be recorded in `chat_history.log` as the actual text sent to the user, not as a planned summary, placeholder, or pre-response paraphrase.

Whenever practical, draft the final response first, append the exact final response text to `chat_history.log`, and then send the same text to the user.

If the exact final response cannot be logged before sending, append it at the next practical checkpoint. In that case, add a short `Timestamp note:` explaining that the entry was backfilled and that the exact emission timestamp was unavailable.

Do not invent precise timestamps. Preserve chronological order and distinguish exact timestamps from backfilled or approximate timestamps.

## Entry Spacing

When a new user prompt is submitted after the preceding AI response has been completed, insert two blank lines before the new `Query:` entry.

Example:

```text
[2026-07-15 15:08:55] Answer:
The analysis has been completed.

Output files:
/project/output/result.20260715_150855.tsv


[2026-07-15 15:18:34] Query:
Please add another comparison group.
```

When the user sends a steering, correction, or additional instruction while the AI is still working on the preceding prompt, insert one blank line before the steering `Query:` entry.

Example:

```text
[2026-07-15 15:08:34] Query:
Please analyze the input files and generate a report.

[2026-07-15 15:09:12] Query:
Also exclude samples marked as failed QC.

[2026-07-15 15:15:55] Answer:
The analysis has been completed after excluding the failed-QC samples.

Output files:
/project/reports/report.en.20260715_151555.html
/project/reports/report.zh.20260715_151555.html
```

Multiple steering messages received before the same AI response should each be recorded as separate `Query:` entries, with one blank line before each entry.

## Response Boundaries and Chronological Ordering

Record all user-visible conversation entries in chronological order.

This includes:

* user prompts
* user steering, corrections, and additional instructions
* AI progress updates
* AI explanations or reasoning explicitly shown in the chat
* AI partial responses
* AI final responses

Use a separate timestamped entry for each user-visible message.

Record user messages using `Query:` and AI messages using `Answer:`.

Do not wait until the end of the task to group all user prompts before the AI response. If the AI posts an update and the user then sends a steering instruction, preserve their actual chronological order.

Insert one blank line between consecutive entries, regardless of whether the entries are `Query:` or `Answer:`.

For example:

```text
[2026-07-15 15:08:34] Query:
Please analyze the input files and generate a report.

[2026-07-15 15:08:55] Answer:
I found that one input file may be incomplete. I am validating the file before continuing.

[2026-07-15 15:09:12] Query:
Also exclude samples marked as failed QC.

[2026-07-15 15:10:03] Answer:
I will exclude the failed-QC samples and continue the analysis using the remaining samples.

[2026-07-15 15:15:55] Answer:
The analysis has been completed after excluding the failed-QC samples.

Output files:
/project/reports/report.en.20260715_151555.html
/project/reports/report.zh.20260715_151555.html
```

An AI response may therefore produce multiple `Answer:` entries when multiple user-visible AI messages are posted during the same task.

Each `Answer:` entry should contain only the content shown to the user in that specific chat message.

The final `Answer:` entry should list all main files created or materially updated by the completed response, when applicable.

If no files were created or materially updated, omit the `Output files:` section.

The timestamp of each `Query:` entry should reflect when the user message was received.

The timestamp of each `Answer:` entry should reflect when that user-visible AI message was posted.

## User-Visible Reasoning and Progress

Record reasoning, explanations, plans, intermediate findings, and progress updates when they were explicitly displayed to the user in the chat.

This includes content such as:

* a visible plan for completing the task
* visible progress or status updates
* intermediate findings shared with the user
* explanations of decisions or assumptions
* visible descriptions of tool results
* partial conclusions
* warnings, limitations, or uncertainty communicated to the user

Do not record private internal reasoning or hidden chain-of-thought that was not displayed in the chat.

The log should reproduce the user-visible content, rather than reconstructing, expanding, or inferring reasoning that was never shown to the user.

## Logging Failures and Partial Results

If a task fails or is only partially completed, record the user-visible AI message describing the outcome as an `Answer:` entry.

List any main files that were successfully created or materially updated.

For example:

```text
[2026-07-15 16:20:41] Answer:
The analysis was only partially completed because one input FASTQ file was truncated. The validation summary was generated, but the final report was not created.

Output files:
/project/output/input_validation.20260715_162041.tsv
```

Do not record authentication credentials, access tokens, passwords, private keys, session cookies, or other secrets.

If user-visible chat content contains sensitive information, redact it from the log when necessary and mark the redaction clearly, for example:

```text
[REDACTED: access token]
```

## Operational priority

Chat-history logging should not materially interrupt the primary analysis. For long-running tasks, record user prompts promptly and record user-visible AI progress updates at the nearest practical checkpoint. If exact emission timestamps are unavailable, preserve chronological order and note the limitation rather than inventing precise timestamps.
