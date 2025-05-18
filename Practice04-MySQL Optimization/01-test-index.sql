
-- 1
-- drop table if exists sales;

-- 2
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- 3
-- Import data from sales.scv. It takes some time (30 - 60 minutes).


-- 3
select count(*) from sales; -- 4636318

select * from sales limit 10000;

-- 4
-- 4.1
explain analyze
select * from sales where salesID = 898777;

-- 4.2
explain analyze
select * from sales where TransactionNumber = 'RPCTLOEB2ELU1DIREQR5';

-- Output 4.2:
-> Filter: (sales.TransactionNumber = 'RPCTLOEB2ELU1DIREQR5')  (cost=472077 rows=449787) (actual time=2.27..2402 rows=1 loops=1)
    -> Table scan on sales  (cost=472077 rows=4.5e+6) (actual time=0.273..1998 rows=4.64e+6 loops=1)

-- 5 Adding index
create index TransactionNumberIDX
ON sales (TransactionNumber);

-- 6
explain analyze
select * from sales where TransactionNumber = 'RPCTLOEB2ELU1DIREQR5';

-- Output 6:
-> Index lookup on sales using TransactionNumberIDX (TransactionNumber='RPCTLOEB2ELU1DIREQR5')  (cost=1.1 rows=1) (actual time=1.18..1.19 rows=1 loops=1)
