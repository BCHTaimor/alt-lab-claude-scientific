# Date and Time Policy

Before starting any task, an AI agent should determine the current local date and time.

The current date should be used consistently for:

* filenames
* workflow files
* reports
* output files
* log entries
* Git commit messages (when applicable)

If the current local time is earlier than **05:00 (5:00 AM)**, the AI agent **must ask the user** whether the previous calendar date should be used instead.

Example:

> The current local time is 02:15. Would you like today's work to use yesterday's date (YYYYMMDD) for filenames, reports, and workflow documentation?

Do not assume the answer.

Use the date explicitly confirmed by the user.

Once a working date has been confirmed, use it consistently throughout the current task unless:

* the user explicitly requests a different working date; or
* the task has been inactive for **2 hours or longer**, in which case the AI agent should determine the current local date and time again and, if the current time is earlier than **05:00 (5:00 AM)**, ask the user whether the previous calendar date should be used as the working date.

Do not automatically change the working date without user confirmation.

The confirmed working date should be applied consistently to filenames, workflow files, reports, output files, and other date-dependent records throughout the task.
