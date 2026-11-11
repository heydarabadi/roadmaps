# Project 1 — Task Tracker CLI

<div dir="ltr">

## Problem and contract

Build a command-line program that stores tasks in a local JSON file. Support add, list, done, remove, and search. Data must survive process restart. The first version assumes one writer process at a time; document that limit instead of pretending a JSON file is a multi-user database.

~~~text
tasks add --title "Read a book"
tasks list [--all]
tasks done --id 12
tasks remove --id 12
tasks search --query "book"
~~~

Successful output should be readable. Errors go to stderr and return a non-zero exit status. Reject a blank title. Report missing IDs, malformed input, corrupt files, and permission failures with useful context.

## Data model and invariants

~~~go
type Task struct {
    ID        int64      `json:"id"`
    Title     string     `json:"title"`
    CreatedAt time.Time  `json:"created_at"`
    DoneAt    *time.Time `json:"done_at,omitempty"`
}
~~~

Define invariants before coding:

- ID is positive and unique in a file.
- Title is not blank after trimming.
- CreatedAt does not change after creation.
- DoneAt nil means the task is incomplete.
- List order is stable, such as by ID; map iteration order is unspecified.

Struct tags are metadata interpreted by encoding/json; they do not validate data.

## Suggested project layout

~~~text
task-tracker/
  go.mod
  cmd/tasks/main.go
  internal/task/task.go
  internal/store/jsonfile.go
  internal/cli/cli.go
~~~

For a tiny version, begin in one package and split only when responsibilities become clear. Keep main responsible for wiring and exit status; do not place all domain logic there.

## Milestone 1: model and rules

Create task validation and constructors without file or console I/O. Make ID and time generation testable. Add a clock abstraction only if tests genuinely need a fixed clock.

**Acceptance:** blank-after-trim titles are rejected; valid titles are preserved; model invariants have tests.

## Milestone 2: in-memory repository

Implement Create, List, Complete, and Delete. A map is suitable for ID lookup, but List must sort to produce deterministic output. Return a copy of the task slice if callers should not mutate storage state.

Add a repository interface only when there is a real second implementation or a useful test seam. A concrete type is simpler when no substitution is needed.

**Acceptance:** operations preserve invariants; missing IDs produce a classified error; List is stable.

## Milestone 3: JSON file storage

Treat a missing file as an empty store on first run. Do not silently convert corrupt JSON into an empty store because it can hide data loss. Get the path from a flag, environment, or user data directory rather than hard-coding the repository path.

For safer writes:

1. Create the directory with appropriate permissions.
2. Write encoded data to a temporary file in the same directory.
3. Check write errors and sync if durability requirements need it.
4. Close the temporary file.
5. Rename it into place.
6. Remove the temporary file on failure.

Rename is usually safer than overwriting a destination directly, but filesystem semantics, power-loss durability, and Windows replacement behavior need separate consideration. It does not solve concurrent lost updates.

## Milestone 4: application and CLI

Separate argument parsing from use-case logic. Parse arguments, invoke a function with explicit inputs/outputs, then map errors to user-facing messages at the CLI boundary. Do not put presentation strings in the storage layer.

**Acceptance:** add/list/done/remove/search work; missing IDs are clear; search case behavior is documented.

## Milestone 5: tests

- Table-driven tests for blank title, create, complete, delete, and missing ID.
- A small in-memory fake for command logic without filesystem access.
- File tests in t.TempDir.
- Corrupt, missing, and write-failure cases.
- Decode JSON and assert contract fields rather than formatting whitespace.
- Compare exact error text only when it is a deliberate product contract.

## Milestone 6: hardening

Document help and exit codes, limit input size, use appropriate file permissions, and state concurrency limitations. Confirm a failed write preserves the previous file. Multiple writers need a lock or transactional store; atomic rename alone can still lose updates.

## Real-world engineering lesson

CLI tools often run in scripts and automation. Stable output, exit status, configuration paths, cleanup, and failure behavior matter. A small JSON file is useful for learning but not a database with migrations, queries, backups, multi-writer transactions, and recovery.

## Design exercises with answers

**Why not treat corrupt JSON as an empty store?**  
It hides corruption and risks overwriting existing data.

**Why not print a map directly?**  
Map order is unspecified; sort keys for stable output.

**Does atomic rename solve concurrent writers?**  
No. The last writer can overwrite another update.

**Why does main own the exit status?**  
Exit status is a process/automation contract; domain code should not terminate the process.

## Quiz

### Questions

1. Why state the single-writer assumption?
2. What is the title invariant?
3. Why should corrupt JSON not be treated as empty?
4. Where should CLI errors be written?
5. Why not rely on map order for IDs and display?
6. Where should the temporary file be created?
7. What can rename reduce, and what does it not guarantee?
8. When is a repository interface valuable?
9. Which test helper provides temporary filesystem isolation?
10. Who consumes the exit code?
11. What can happen with simultaneous writers?
12. Is a JSON file appropriate for concurrent multi-user writes?

### Answer key

1. To make the synchronization limit explicit.
2. It is non-empty after trimming.
3. It can hide data corruption and cause data loss.
4. stderr.
5. Map iteration order is not stable.
6. In the destination directory or same filesystem.
7. It reduces partial-file exposure; it does not guarantee durability or transactions.
8. When another real implementation or a test seam is useful.
9. t.TempDir.
10. Shell scripts and automation.
11. A lost update can occur.
12. Not without locking or transactional storage and recovery design.

## References and further reading

- [os package](https://pkg.go.dev/os)
- [encoding/json package](https://pkg.go.dev/encoding/json)
- [flag package](https://pkg.go.dev/flag)
- [Go modules reference](https://go.dev/ref/mod)
- [Go testing package](https://pkg.go.dev/testing)
- [Go blog: JSON and Go](https://go.dev/blog/json)

[Persian project guide](README.md) · [Next project: HTTP API](../02-catalog-http-api/README.en.md)

</div>
