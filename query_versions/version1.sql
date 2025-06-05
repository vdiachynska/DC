SELECT
    c.CityID,
    (SELECT CityName FROM cities WHERE cities.CityID = c.CityID) AS CityName,

    c.CustomerID AS MostActiveCustomer,
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    SUM(s.Quantity) AS TotalUnits, -- removed unnecessary subqueries here
    COUNT(SalesID) AS TotalSales, -- here
    AVG(s.Discount) AS AverageDiscount -- and here

FROM customers c
JOIN sales s ON c.CustomerID = s.CustomerID -- added this join

WHERE c.CustomerID IN (
    SELECT CustomerID FROM (
        SELECT
            s.CustomerID,
            SUM(s.Quantity) AS TotalQ,
            c2.CityID,
            ROW_NUMBER() OVER (
                PARTITION BY c2.CityID
                ORDER BY SUM(s.Quantity) DESC
            ) AS rn
        FROM sales s
        JOIN customers c2 ON s.CustomerID = c2.CustomerID
        GROUP BY s.CustomerID, c2.CityID
    ) AS ranked
    WHERE rn = 1
)
GROUP BY c.CityID, c.CustomerID, c.FirstName, c.LastName -- added required group by
-- removed unneeded order by
