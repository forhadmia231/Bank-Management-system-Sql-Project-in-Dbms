# Bank-Management-system-Sql-Project-in-Dbms
📌 Project Overview
This project is a simple **Bank Management System** built using SQL.  
It stores and manages customer information,Bank information, accounts, transactions, and employee details.

 🗂 Database Schema
The database contains the following tables:
- Bank : Store Bank and Branch Information 
- Customers: Stores customer personal information
- Accounts: Stores account details for each customer
- Transactions: Tracks all deposits, withdrawals, and transfers
- Employees: Stores bank staff details

📊 ER Diagram
![ER Diagram](ERD.pdf)

## ⚙️ How to Run
1. Open any SQL database software (MySQL, Oracle, PostgreSQL, etc.).
2. Create a new database.
3. Run `bank.sql` to create tables and insert sample data.
4. Run queries from `bank_sample_queries.sql` to test the system.

📂 Files Included
- `bank.sql` → Contains table creation (DDL) + data insertion (DML)
- `bank_sample_queries.sql` → Example queries for testing
- `ERD.pdf` → Entity Relationship diagram of the project

📝 Example Queries
```sql
-- View all customers and their accounts
SELECT c.first_name, c.last_name, a.account_type, a.balance
FROM Customers c
JOIN Accounts a ON c.customer_id = a.customer_id;
