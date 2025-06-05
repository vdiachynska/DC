WITH ranked AS (SELECT --added CTE
s.CustomerID,
c.CityID,
ROW_NUMBER() OVER (
    PARTITION BY c.CityID
    ORDER BY SUM(s.Quantity) DESC
) AS rn
FROM sales s
JOIN customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CityID, s.CustomerID )

SELECT
    c.CityID,
    cities.CityName, -- simplified due to join
    c.CustomerID AS MostActiveCustomer,

    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    SUM(s.Quantity) AS TotalUnits,
    COUNT(SalesID) AS TotalSales,
    AVG(s.Discount) AS AverageDiscount

FROM customers c
JOIN sales s ON c.CustomerID = s.CustomerID
join cities on c.CityID = cities.CityID -- joined with cities

WHERE c.CustomerID IN (
    SELECT CustomerID FROM ranked AS r -- using CTE here
    WHERE rn = 1
)
GROUP BY c.CityID, c.CustomerID, c.FirstName, c.LastName