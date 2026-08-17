# Exercise 03 — Transactions

- **Level:** 4/5
- **Topic:** BEGIN, COMMIT, ROLLBACK
- **Estimated time:** 20 min

## Statement

Simulate a money transfer between two accounts. Starting with the `accounts`
table:

1. Begin a transaction.
2. Subtract 100 from Ana's balance and add 100 to Bruno's.
3. Commit the transaction.
4. Begin another transaction, set **all** balances to 0, and roll back.
5. Verify that the rollback restored the original balances.

Expected result after step 5: Ana has 400, Bruno has 500 (from the sample data
minus the committed transfer).

## Initial schema

```sql
CREATE TABLE accounts (
  id INTEGER PRIMARY KEY,
  owner TEXT NOT NULL,
  balance REAL NOT NULL
);

INSERT INTO accounts (owner, balance) VALUES
  ('Ana', 500.0),
  ('Bruno', 400.0);
```

## Requirements

- [ ] The query returns the expected result
- [ ] Run it locally (SQLite or PostgreSQL) and verify

## Hints

<details>
<summary>Show hints</summary>

- Hint 1: `BEGIN;` ... `COMMIT;` for the transfer.
- Hint 2: `BEGIN; UPDATE accounts SET balance = 0; ROLLBACK;`
- Hint 3: `SELECT * FROM accounts;` after each block to check.

</details>

## Solution

<details>
<summary>Show solution</summary>

````sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE owner = 'Ana';
UPDATE accounts SET balance = balance + 100 WHERE owner = 'Bruno';
COMMIT;

BEGIN;
UPDATE accounts SET balance = 0;
ROLLBACK;

SELECT * FROM accounts;
````

Ana shows 400, Bruno shows 500 — the failed "zero everything" transaction was
undone.

</details>