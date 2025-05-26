
CREATE DATABASE il_levels_demo;
USE il_levels_demo;

-- Drop the table if it already exists to ensure a clean start
DROP TABLE IF EXISTS accounts;

-- Create the accounts table
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_holder VARCHAR(255) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL
);

-- Insert some initial data
INSERT INTO accounts (account_holder, balance) VALUES
('Alice', 1000.00),
('Bob', 500.00);

SELECT * FROM accounts;