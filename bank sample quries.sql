-- Show all customers with their account details
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       a.account_id,
       a.account_type,
       a.balance
FROM CUSTOMER c
JOIN ACCOUNT a ON c.customer_id = a.customer_id;

-- Show all transactions for account 1
SELECT * FROM TRANSACTION
WHERE account_id = 1
ORDER BY transaction_date DESC;

-- Total balance per branch
SELECT b.branch_name,
       SUM(a.balance) AS total_balance
FROM BRANCH b
JOIN ACCOUNT a ON b.branch_id = a.branch_id
GROUP BY b.branch_name;

-- Customers with balance > 15000
SELECT c.customer_id, c.first_name, c.last_name, a.balance
FROM CUSTOMER c
JOIN ACCOUNT a ON c.customer_id = a.customer_id
WHERE a.balance > 15000;

-- Total deposits and withdrawals per account
SELECT a.account_id,
       SUM(CASE WHEN t.transaction_type = 'Deposit' THEN t.amount ELSE 0 END) AS total_deposits,
       SUM(CASE WHEN t.transaction_type = 'Withdrawal' THEN t.amount ELSE 0 END) AS total_withdrawals
FROM ACCOUNT a
LEFT JOIN TRANSACTION t ON a.account_id = t.account_id
GROUP BY a.account_id;
