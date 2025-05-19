# MySQL Window Functions Workshop

This workshop introduces essential **window functions** in MySQL using a sample `sales` table. Window functions allow you to perform calculations across rows related to the current row without collapsing results into groups.

---

## 📦 Table Schema

```sql
CREATE TABLE `sales` (
  `SalesID` int PRIMARY KEY,
  `SalesPersonID` int DEFAULT NULL,
  `CustomerID` int DEFAULT NULL,
  `ProductID` int DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Discount` double DEFAULT NULL,
  `TotalPrice` double DEFAULT NULL,
  `SalesDate` varchar(32) DEFAULT NULL,
  `TransactionNumber` varchar(32) DEFAULT NULL
);
```

---

## Sample Data

```sql
INSERT INTO sales (SalesID, SalesPersonID, CustomerID, ProductID, Quantity, Discount, TotalPrice, SalesDate, TransactionNumber)
VALUES
(1, 101, 1001, 201, 2, 0.1, 180, '2024-01-01', 'TXN001'),
(2, 102, 1002, 202, 1, 0.05, 95, '2024-01-02', 'TXN002'),
(3, 101, 1001, 203, 3, 0.0, 300, '2024-01-03', 'TXN003'),
(4, 103, 1003, 201, 1, 0.1, 90, '2024-01-04', 'TXN004'),
(5, 101, 1001, 202, 4, 0.2, 320, '2024-01-05', 'TXN005'),
(6, 102, 1002, 203, 2, 0.0, 200, '2024-01-06', 'TXN006');
```

---

## 🧫 Window Function Examples

### 1. `ROW_NUMBER()` – First Purchase per Customer

```sql
SELECT
  SalesID,
  CustomerID,
  SalesDate,
  TotalPrice,
  ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SalesDate) AS rn
FROM sales;
```

### 2. `RANK()` – Top Sales per Salesperson

```sql
SELECT
  SalesPersonID,
  SalesID,
  TotalPrice,
  RANK() OVER (PARTITION BY SalesPersonID ORDER BY TotalPrice DESC) AS sales_rank
FROM sales;
```

### 3. `LAG()` – Compare with Previous Sale

```sql
SELECT
  SalesID,
  CustomerID,
  SalesDate,
  TotalPrice,
  LAG(TotalPrice) OVER (PARTITION BY CustomerID ORDER BY SalesDate) AS previous_sale
FROM sales;
```

### 4. `LEAD()` – Look Ahead to Next Sale

```sql
SELECT
  SalesID,
  CustomerID,
  SalesDate,
  TotalPrice,
  LEAD(TotalPrice) OVER (PARTITION BY CustomerID ORDER BY SalesDate) AS next_sale
FROM sales;
```

### 5. `SUM()` – Running Total per Salesperson

```sql
SELECT
  SalesID,
  SalesPersonID,
  SalesDate,
  TotalPrice,
  SUM(TotalPrice) OVER (PARTITION BY SalesPersonID ORDER BY SalesDate) AS running_total
FROM sales;
```

### 6. `AVG()` – Average Discount per Product

```sql
SELECT
  ProductID,
  SalesID,
  Discount,
  AVG(Discount) OVER (PARTITION BY ProductID) AS avg_discount
FROM sales;
```

---

## 📍 Notes

* For better date handling, convert `SalesDate` to `DATE` type using:

  ```sql
  STR_TO_DATE(SalesDate, '%Y-%m-%d')
  ```

* These queries demonstrate key analytical patterns, useful for BI and data reporting:

  * Finding the first or latest events per group
  * Ranking within partitions
  * Calculating trends (previous/next comparisons)
  * Running totals and moving averages

---

Happy querying! ✨
