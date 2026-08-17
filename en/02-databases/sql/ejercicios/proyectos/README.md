# Capstone Projects

Three complete projects that put everything together. Each one is divided
into **phases**; finish each phase and verify its queries before moving on.
Use SQLite (`sqlite3`) or PostgreSQL. All exercises include creating your own
schema from scratch.

| Project | Difficulty | Core skills |
|---|---|---|
| [Blog system](#1-blog-system) | ⭐⭐⭐ | Schema design, joins, views |
| [Minimal e-commerce](#2-minimal-e-commerce) | ⭐⭐⭐⭐ | Transactions, indexes, reports |
| [Sales dashboard](#3-sales-dashboard) | ⭐⭐⭐⭐⭐ | Window functions, optimization, reports |

---

## 1. Blog system

**Goal:** a blogging platform with authors, posts, and comments.

### Phase 1 — Schema
- [ ] Tables: `authors`, `posts`, `comments`.
- [ ] `posts.author_id` references `authors.id`; `comments.post_id` references `posts.id`.
- [ ] Add `created_at` columns (TEXT, ISO format) everywhere.

### Phase 2 — Data
- [ ] Insert 3 authors, 5 posts, and 8 comments spread across the posts.

### Phase 3 — Queries
- [ ] All posts with the author's name (INNER JOIN).
- [ ] Posts with zero comments (LEFT JOIN + `IS NULL`).
- [ ] Number of comments per post (GROUP BY).
- [ ] A `CREATE VIEW post_summary` with title, author, comment count.

### Phase 4 — Polish
- [ ] Index `posts.created_at` for date sorting.
- [ ] Query the 3 most recent posts with at least one comment.

---

## 2. Minimal e-commerce

**Goal:** a store with customers, products, carts, and orders.

### Phase 1 — Schema
- [ ] Tables: `customers`, `products`, `cart_items`, `orders`, `order_items`.
- [ ] `products.stock` must be non-negative (`CHECK`).
- [ ] `orders.status` restricted with a `CHECK` or an enum-like set of strings.

### Phase 2 — Purchasing flow
- [ ] Put items in a cart (`cart_items` with `product_id`, `quantity`).
- [ ] Write the "checkout" as a transaction: create the order, copy cart items
      into `order_items`, decrement stock, clear the cart, `COMMIT`.
- [ ] Verify a `ROLLBACK` leaves stock unchanged if the transaction fails.

### Phase 3 — Reports
- [ ] Revenue per customer.
- [ ] Top 5 selling products.
- [ ] Products with stock lower than 5 (restock alert).

### Phase 4 — Optimization
- [ ] Index `order_items.product_id` and `orders.customer_id`.
- [ ] Run `EXPLAIN QUERY PLAN` on the top-products query and confirm it uses
      the indexes.

---

## 3. Sales dashboard

**Goal:** a reporting database for a sales team, with historical data.

### Phase 1 — Schema
- [ ] Tables: `regions`, `salespeople`, `sales` (one row per sale with
      `region_id`, `salesperson_id`, `sale_date`, `amount`).
- [ ] Generate at least 30 rows of sample data across 3 regions and 5
      salespeople.

### Phase 2 — Daily/monthly reports
- [ ] Daily revenue using `GROUP BY`.
- [ ] Monthly revenue using a date function (`strftime('%Y-%m', ...)` in
      SQLite, `to_char(...)` in PostgreSQL).

### Phase 3 — Advanced analytics
- [ ] Running/cumulative revenue with `SUM(...) OVER (ORDER BY sale_date)`.
- [ ] Rank salespeople within each region with `RANK() OVER (PARTITION BY region_id ...)`.
- [ ] Month-over-month growth using `LAG` to compare with the previous month.

### Phase 4 — Dashboard queries
- [ ] A single query per chart: revenue by region, top salesperson overall,
      best month, average sale per region.
- [ ] Index `sales.sale_date` and `sales.region_id`; re-check `EXPLAIN`.

---

## Evaluation checklist (all projects)

- [ ] Schema is in 3NF (no repeated groups, no partial/transitive dependencies).
- [ ] Every relationship has a foreign key.
- [ ] Queries run without errors in SQLite or PostgreSQL.
- [ ] Results match what you manually computed from the sample data.
- [ ] You can explain each query (joins, grouping, window functions).