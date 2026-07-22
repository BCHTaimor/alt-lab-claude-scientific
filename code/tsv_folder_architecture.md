# Folder Summary Report Structure

This document explains the report file structure that another AI should use when reading the verification output in this repository.

Important:

- The main machine-readable report is `folder_summary.tsv`, not a biological sample CSV.
- It is a tab-separated table with one row per local folder.
- Each row answers: was this folder found on each remote, did size match, did `rclone check` pass, and is it safe to delete?

## Primary Files

For a run under `runs/<run_name>/`, the key files are:

- `run_metadata.txt`
- `folder_summary.tsv`
- `remote_summary.tsv`
- `verified_on_any_remote.txt`
- `missing_from_all_remotes.txt`
- `unreachable_remotes.txt`
- `<remote>_folders.txt`
- `<remote>_name_overlap.txt`
- `<remote>_size_match.txt`
- `<remote>_size_mismatch.txt`
- `<remote>_verified_safe_to_delete.txt`
- `<remote>_verification_failed.txt`

## Main Table: `folder_summary.tsv`

Location pattern:

```text
runs/<run_name>/folder_summary.tsv
```

This is the main file another AI should parse first.

### Row model

- One row = one local sequencing folder.
- The first column is always the local folder name.
- Then the file repeats a 4-column block for each remote.
- The row ends with final aggregate decision columns.

### Column pattern

The header follows this structure:

```text
folder
<remote>_present
<remote>_size
<remote>_check
<remote>_result
...
verified_remotes
overall_result
```

Example real header shape:

```text
folder
remoteNextseq2_present
remoteNextseq2_size
remoteNextseq2_check
remoteNextseq2_result
remoteNextseq3_present
remoteNextseq3_size
remoteNextseq3_check
remoteNextseq3_result
...
verified_remotes
overall_result
```

## Meaning Of Each Column Type

### `folder`

The local folder being evaluated.

Examples:

- `221025_NB551505_0255_AH22WCAFX5`
- `230706_VH01467_11_AACTHLVM5`

### `<remote>_present`

Did a folder with the same name exist on that remote?

Common values:

- `yes`
- `no`
- `unreachable`

Interpretation:

- `yes`: the remote has a folder with the same name
- `no`: no name match on that remote
- `unreachable`: the remote could not be checked

### `<remote>_size`

What happened at the size/object-count comparison step?

Common values:

- `match`
- `mismatch`
- `not_run`
- `unreachable`

Interpretation:

- `match`: local and remote totals matched well enough to continue to exact verification
- `mismatch`: totals differed, so deletion is blocked on that remote
- `not_run`: size comparison did not happen, usually because the folder was not present there
- `unreachable`: the remote was not reachable

### `<remote>_check`

What happened at the exact verification step (`rclone check`)?

Common values:

- `pass`
- `fail`
- `not_run`
- `unreachable`

Interpretation:

- `pass`: exact verification succeeded
- `fail`: exact verification ran and failed
- `not_run`: verification never ran, usually because size did not match or the folder was absent
- `unreachable`: remote was unreachable

### `<remote>_result`

The summarized outcome for that folder on that remote.

Common values:

- `verified`
- `not_verified`
- `present_by_name`
- `not_present`
- `unreachable`

Interpretation:

- `verified`: safe on this remote specifically
- `not_verified`: remote had the folder or was compared, but verification did not succeed
- `present_by_name`: name overlap existed but stronger checks did not complete successfully
- `not_present`: no matching folder name on that remote
- `unreachable`: remote status unknown because it could not be reached

### `verified_remotes`

Comma-separated list of remotes where the folder fully verified.

Common values:

- `remoteNextseq2`
- `remoteNextseqCleanup20222023`
- `remoteNextseq2,remoteNextseq5`
- `none`

Interpretation:

- if this is not `none`, the folder verified on at least one remote
- this is the main evidence for deletion eligibility

### `overall_result`

Final decision for the folder across all remotes.

Common values:

- `safe_to_delete`
- `not_verified_on_any_remote`
- `missing_from_all_remotes`

Interpretation:

- `safe_to_delete`: at least one remote fully verified the folder
- `not_verified_on_any_remote`: the folder was checked but no remote fully verified it
- `missing_from_all_remotes`: no remote had it by name

## How To Parse A Row

Use this logic:

1. Read `folder`.
2. For each remote, inspect the 4-column block:
   - `present`
   - `size`
   - `check`
   - `result`
3. Read `verified_remotes`.
4. Read `overall_result`.
5. Treat `overall_result` as the final workflow decision.

## Example Interpretation

Example row pattern:

```text
230706_VH01467_11_AACTHLVM5
remoteNextseq2_present=yes
remoteNextseq2_size=mismatch
remoteNextseq2_check=not_run
remoteNextseq2_result=not_verified
remoteNextseqCleanup20222023_present=yes
remoteNextseqCleanup20222023_size=match
remoteNextseqCleanup20222023_check=pass
remoteNextseqCleanup20222023_result=verified
verified_remotes=remoteNextseqCleanup20222023
overall_result=safe_to_delete
```

Meaning:

- the folder exists on `remoteNextseq2`, but size mismatch blocked verification there
- the same folder exists on `remoteNextseqCleanup20222023`
- size matched there
- exact verification passed there
- because at least one remote verified it, the folder is marked `safe_to_delete`

## Secondary Table: `remote_summary.tsv`

Location pattern:

```text
runs/<run_name>/remote_summary.tsv
```

This is the per-remote aggregate summary.

Columns:

- `remote`
- `status`
- `overlap`
- `size_match`
- `size_mismatch`
- `verified`
- `verification_failed`

Meaning:

- `remote`: remote name
- `status`: usually `ok` or `unreachable`
- `overlap`: how many local folders had name overlap on that remote
- `size_match`: how many overlap folders passed size comparison
- `size_mismatch`: how many overlap folders failed size comparison
- `verified`: how many folders passed exact verification on that remote
- `verification_failed`: how many folders reached verification but failed

Use `remote_summary.tsv` when an AI needs remote-level counts rather than folder-level decisions.

## Supporting Files

### `run_metadata.txt`

This explains the run context.

Important fields:

- `run_date`
- `run_name`
- `remote_list`
- `folder_list_file`
- `remove_mode`
- `mode_label`
- `local_dir`
- `remote_subpath`
- `tmp_dir`
- `command`

Another AI should read this if it needs to know:

- which remotes were included
- whether this was dry-run or remove mode
- whether a custom folder manifest was used

### `verified_on_any_remote.txt`

- one folder name per line
- final union of folders that fully verified on at least one remote

### `missing_from_all_remotes.txt`

- one folder name per line
- folders absent across all checked remotes

### `unreachable_remotes.txt`

- one remote per line
- remotes that could not be checked

### Per-remote detail files

For any remote named `<remote>`, these files provide drill-down:

- `<remote>_folders.txt`: remote folder inventory
- `<remote>_name_overlap.txt`: folders present both locally and remotely by name
- `<remote>_size_match.txt`: overlap folders whose total size and file counts matched
- `<remote>_size_mismatch.txt`: overlap folders whose totals differed
- `<remote>_verified_safe_to_delete.txt`: folders that passed exact verification on that remote
- `<remote>_verification_failed.txt`: folders that reached exact verification but failed

## Canonical Mental Model

Think of the workflow as:

```text
local folder
  -> present on remote?
  -> size match on remote?
  -> exact check pass on remote?
  -> remote result
repeat for all remotes
  -> verified_remotes
  -> overall_result
```

## Rules Another AI Should Follow

- Parse `folder_summary.tsv` as tab-separated, not comma-separated.
- Do not assume a fixed remote list; derive remotes from the header or `run_metadata.txt`.
- Treat each remote as a repeating 4-column block.
- Use `overall_result` as the final folder-level decision.
- Use `verified_remotes` to explain why a folder is safe to delete.
- Use `remote_summary.tsv` only for aggregate reporting, not for folder-level decisions.
- If a remote is `unreachable`, do not infer success or absence from that remote.

## Fastest Lookup Strategy

If another AI needs to answer questions independently:

1. Read `run_metadata.txt`.
2. Read the header and rows of `folder_summary.tsv`.
3. If needed, read `remote_summary.tsv`.
4. If a row needs explanation, inspect the matching per-remote files for the remote named in `verified_remotes` or the remote that failed.

## Example Run Paths

Real examples in this repo:

- `runs/20260712_all_nextseq_remotes_remove/folder_summary.tsv`
- `runs/20260712_all_nextseq_remotes_remove/remote_summary.tsv`
- `runs/20260712_all_nextseq_remotes_remove/run_metadata.txt`

These are the best reference files for understanding the intended structure.
