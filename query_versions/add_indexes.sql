CREATE INDEX customers_city_idx ON customers(CityID, CustomerID);
CREATE INDEX sales_idx ON sales(CustomerID, Quantity);