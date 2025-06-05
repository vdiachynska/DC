WITH CustomerOrders AS (
    SELECT
        c.CityID AS City,
        ci.CityName AS CityName,
        c.CustomerID AS CustomerID,
        concat(c.FirstName, ' ', c.LastName) AS FullName,
        sum(s.Quantity) AS TotalUnits,
        count(SalesID) AS TotalSales,
        avg(Discount) AS AverageDiscount,
        ROW_NUMBER() OVER (
            PARTITION BY c.CityID
            ORDER BY SUM(s.Quantity) DESC
        ) AS rn
    FROM sales s
    JOIN customers c ON s.CustomerID = c.CustomerID
    JOIN cities ci on c.CityID=ci.CityID
    GROUP BY c.CityID, ci.CityName, c.CustomerID, c.FirstName, c.LastName
)

SELECT
City, CityName,
CustomerID AS MostActiveCustomer, FullName,
TotalUnits, TotalSales, AverageDiscount
FROM CustomerOrders
WHERE rn = 1;