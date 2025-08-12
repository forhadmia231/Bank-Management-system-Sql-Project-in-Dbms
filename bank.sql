-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    address VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(50)
);

-- Accounts Table
CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(20), -- e.g., Savings, Current
    balance DECIMAL(12,2),
    open_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(20), -- Deposit, Withdrawal, Transfer
    amount DECIMAL(12,2),
    transaction_date DATE,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

-- Loans Table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_type VARCHAR(20), -- Personal, Home, Car
    loan_amount DECIMAL(12,2),
    interest_rate DECIMAL(5,2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Employees Table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(12,2),
    hire_date DATE
);
