-- 1. View all customer accounts
SELECT c.first_name, c.last_name, a.account_type, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;

-- 2. Total balance in the bank
SELECT SUM(balance) AS total_bank_balance FROM Accounts;

-- 3. Transaction history for a specific account
SELECT * FROM Transactions WHERE account_id = 101;

-- 4. Customers who have taken loans
SELECT c.first_name, c.last_name, l.loan_type, l.loan_amount
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id;

-- 5. Employees earning more than 50,000
SELECT first_name, last_name, position FROM Employees WHERE salary > 50000;
