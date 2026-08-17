# Exercise 06 — Closures

- **Level:** 2/5
- **Topic:** Closures, private state
- **Estimated time:** 15 min

## Statement

Build two functions that use closures to keep private state.

1. `makeCounter(start)` — returns a function that increments and returns a private counter, starting from `start` (default 0). Create two independent counters `a` and `b` and show they do not share state.
2. `makeBankAccount(initial)` — returns an object with:
   - `deposit(amount)` — adds to a private balance, returns the new balance.
   - `withdraw(amount)` — subtracts if there are enough funds; otherwise prints `"Insufficient funds"` and returns the unchanged balance.
   - `getBalance()` — returns the balance.
3. Print `typeof balance` from outside the account — it must be `undefined` because the balance is private.

Expected output:

```text
a(): 1
a(): 2
b(): 1
after deposit(100): 150
after withdraw(40): 110
after withdraw(999): Insufficient funds
balance stays 110
typeof balance (outside): undefined
```

## Requirements

- [ ] Creates a counter factory with closure state
- [ ] Two counters have independent state
- [ ] Bank account balance is not reachable from outside
- [ ] `withdraw` guards against overdrawing
- [ ] Run it locally with `node` and verify the output

## Hints

<details>
<summary>Show hints</summary>

- The closure variable lives only inside the factory function — that is what makes it private.
- `deposit`/`withdraw` are arrow/function properties returned inside an object, so they still capture `balance`.
- To prove privacy, `account.balance` must be `undefined`.

</details>

## Solution

<details>
<summary>Show solution</summary>

````javascript
function makeCounter(start = 0) {
  let value = start;
  return () => ++value;
}

const a = makeCounter();
const b = makeCounter();
console.log(`a(): ${a()}`);
console.log(`a(): ${a()}`);
console.log(`b(): ${b()}`);

function makeBankAccount(initial = 0) {
  let balance = initial;

  return {
    deposit(amount) {
      balance += amount;
      return balance;
    },
    withdraw(amount) {
      if (amount > balance) {
        console.log("Insufficient funds");
        return balance;
      }
      balance -= amount;
      return balance;
    },
    getBalance() {
      return balance;
    },
  };
}

const account = makeBankAccount(50);
console.log(`after deposit(100): ${account.deposit(100)}`);
console.log(`after withdraw(40): ${account.withdraw(40)}`);
console.log(`after withdraw(999): ${account.withdraw(999)}`);
console.log(`balance stays ${account.getBalance()}`);
console.log(`typeof balance (outside): ${typeof account.balance}`);
````

</details>