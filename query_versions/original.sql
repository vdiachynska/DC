SELECT
    c.CityID,
    (SELECT CityName FROM cities WHERE cities.CityID = c.CityID) AS CityName,

    c.CustomerID AS MostActiveCustomer,
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,

    (SELECT SUM(s2.Quantity)
     FROM sales s2
     WHERE s2.CustomerID = c.CustomerID) AS TotalUnits,

    (SELECT COUNT(*)
     FROM sales s3
     WHERE s3.CustomerID = c.CustomerID) AS TotalSales,

    (SELECT AVG(s4.Discount)
     FROM sales s4
     WHERE s4.CustomerID = c.CustomerID) AS AverageDiscount

FROM customers c
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

ORDER BY c.CityID ASC, FullName DESC;
