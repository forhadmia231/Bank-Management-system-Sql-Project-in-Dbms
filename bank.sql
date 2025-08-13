CREATE TABLE BANK (
    bank_id NUMBER PRIMARY KEY,
    bank_name VARCHAR2(100) NOT NULL,
    head_office VARCHAR2(200)
);

-- 2) BRANCH
CREATE TABLE BRANCH (
    branch_id NUMBER PRIMARY KEY,
    branch_name VARCHAR2(100) NOT NULL,
    bank_id NUMBER NOT NULL,
    address VARCHAR2(200),
    CONSTRAINT fk_branch_bank FOREIGN KEY (bank_id) REFERENCES BANK(bank_id)
);

-- 3) CUSTOMER
CREATE TABLE CUSTOMER (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    address VARCHAR2(200)
);

-- 4) ACCOUNT
CREATE TABLE ACCOUNT (
    account_id NUMBER PRIMARY KEY,
    account_type VARCHAR2(30),
    balance NUMBER(15,2) DEFAULT 0 CHECK (balance >= 0),
    customer_id NUMBER NOT NULL,
    branch_id NUMBER NOT NULL,
    CONSTRAINT fk_account_customer FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    CONSTRAINT fk_account_branch FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);

-- 5) EMPLOYEE
CREATE TABLE EMPLOYEE (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50),
    position VARCHAR2(50),
    salary NUMBER(12,2) CHECK (salary >= 0),
    branch_id NUMBER NOT NULL,
    CONSTRAINT fk_employee_branch FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);

-- 6) TRANSACTION (replaces LOAN)
CREATE TABLE TRANSACTION (
    transaction_id NUMBER PRIMARY KEY,
    account_id NUMBER NOT NULL,
    transaction_type VARCHAR2(20) CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer')),
    amount NUMBER(15,2) CHECK (amount > 0),
    transaction_date DATE DEFAULT SYSDATE,
    performed_by VARCHAR2(50),
    CONSTRAINT fk_transaction_account FOREIGN KEY (account_id) REFERENCES ACCOUNT(account_id)
);
