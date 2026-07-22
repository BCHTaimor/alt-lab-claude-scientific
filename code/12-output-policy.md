# Output Policy

Avoid overwriting previous results.

Prefer creating new files with date-based suffixes.

For outputs generated or updated no more than once per day, use the following format:

```text
result.YYYYMMDD.tsv
```

For example:

```text
result.20260710.tsv
result.20260711.tsv
```

If an output is generated or updated multiple times on the same day, include the time using the `YYYYMMDD_HHMMSS` format:

```text
result.YYYYMMDD_HHMMSS.tsv
```

For example:

```text
result.20260710_093015.tsv
result.20260710_142728.tsv
```

Do not repeatedly overwrite a generic filename such as:

```text
result.tsv
```

Use timestamps based on the working date and local time established for the current task.
