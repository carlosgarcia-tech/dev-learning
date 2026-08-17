# SQL Transactions

## Goals

- [ ] Understand why transactions exist
- [ ] Start a transaction with `BEGIN`
- [ ] Commit changes with `COMMIT`
- [ ] Undo changes with `ROLLBACK`
- [ ] Know the ACID properties
- [ ] Understand isolation levels and the anomalies they prevent

## Notes

### What is a transaction?

A transaction is a **unit of work** executed as one atomic block: either every
statement inside it succeeds, or none of them do. Classic example: transfer
money from account A to account B — you must not subtract from A without
adding to B.

### The three commands

- `BEGIN` (or `BEGIN TRANSACTION`) — starts a transaction.
- `COMMIT` — makes all pending changes permanent.
- `ROLLBACK` — discards all pending changes since the last `BEGIN`.

```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

If the second statement fails, run `ROLLBACK` and both updates are undone.

### ACID

| Property | Meaning |
|---|---|
| **Atomicity** | All or nothing — the transaction is a single indivisible unit |
| **Consistency** | The database goes from one valid state to another (constraints hold) |
| **Isolation** | Concurrent transactions do not interfere with each other |
| **Durability** | Once committed, changes survive crashes and restarts |

### Isolation levels

Isolation is a trade-off between correctness and concurrency. The standard
levels, from weakest to strongest:

| Level | Possible anomalies |
|---|---|
| `READ UNCOMMITTED` | dirty reads, non-repeatable reads, phantom reads |
| `READ COMMITTED` | non-repeatable reads, phantom reads |
| `REPEATABLE READ` | phantom reads (in PostgreSQL: also some serialization anomalies) |
| `SERIALIZABLE` | none (in theory) |

Common anomalies:

- **Dirty read:** reading uncommitted changes from another transaction.
- **Non-repeatable read:** the same query returns different rows within the
  same transaction because another transaction committed in between.
- **Phantom read:** a query that previously returned N rows now returns N+1
  because another transaction inserted rows.

PostgreSQL's default is `READ COMMITTED`. You can set it per transaction:

```sql
BEGIN ISOLATION LEVEL SERIALIZABLE;
```

SQLite historically serialized all writes (a single write lock), so many
anomalies are not observed in practice, but it still supports
`BEGIN IMMEDIATE` / `BEGIN EXCLUSIVE` to control locking behavior.

### Beware of autocommit

Most drivers run each statement in its own implicit transaction
(autocommit). Long multi-step operations that must stay consistent need an
explicit `BEGIN` / `COMMIT` block.

## Code examples

```sql
CREATE TABLE accounts (
  id INTEGER PRIMARY KEY,
  owner TEXT NOT NULL,
  balance REAL NOT NULL
);

INSERT INTO accounts (owner, balance) VALUES ('Ana', 500.0), ('Bruno', 300.0);

BEGIN;
UPDATE accounts SET balance = balance - 50 WHERE owner = 'Ana';
UPDATE accounts SET balance = balance + 50 WHERE owner = 'Bruno';
COMMIT;

-- Undoing work
BEGIN;
UPDATE accounts SET balance = 0;
ROLLBACK; -- the whole table is restored
```

## Related exercises

- [exercise-03-transactions](ejercicios/nivel-04-avanzado/exercise-03-transactions.md)
- [exercise-05-transactions-and-concurrency](ejercicios/nivel-05-experto/exercise-05-transactions-and-concurrency.md)

## Common mistakes

- Forgetting `COMMIT` and keeping locks open (blocks other writers, or changes
  lost when the session closes).
- Forgetting `ROLLBACK` on error and committing a half-done operation.
- Assuming `BEGIN` is enough in autocommit drivers — check the driver's default
  behavior.
- Mixing statements that PostgreSQL cannot run inside a transaction
  (e.g. most `CREATE INDEX CONCURRENTLY` calls, some `VACUUM`).
- Ignoring isolation level and then being surprised by non-repeatable reads.
- Holding transactions open while doing slow application logic (HTTP calls,
  file I/O), which keeps locks for too long.

## Resources

- [SQLite transactions](https://www.sqlite.org/lang_transaction.html)
- [PostgreSQL transactions and concurrency control](https://www.postgresql.org/docs/current/mvcc.html)
- [PostgreSQL isolation levels](https://www.postgresql.org/docs/current/transaction-iso.html)