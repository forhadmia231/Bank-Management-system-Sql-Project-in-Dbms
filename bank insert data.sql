-- BANK
INSERT INTO BANK (bank_name, head_office) VALUES ('National Bank', 'Dhaka Head Office');
INSERT INTO BANK (bank_name, head_office) VALUES ('City Bank', 'Chittagong Head Office');

-- BRANCH
INSERT INTO BRANCH (branch_name, bank_id, address) VALUES ('Dhaka Main', 1, 'Motijheel, Dhaka');
INSERT INTO BRANCH (branch_name, bank_id, address) VALUES ('Gulshan Branch', 1, 'Gulshan, Dhaka');
INSERT INTO BRANCH (branch_name, bank_id, address) VALUES ('Chittagong Main', 2, 'Agrabad, Chittagong');

-- CUSTOMER
INSERT INTO CUSTOMER (first_name, last_name, phone, email, address)
VALUES ('Forhad', 'Hossain', '01711111111', 'forhad@example.com', 'Dhaka');

INSERT INTO CUSTOMER (first_name, last_name, phone, email, address)
VALUES ('Samiul', 'Islam', '01722222222', 'samiul@example.com', 'Chittagong');

INSERT INTO CUSTOMER (first_name, last_name, phone, email, address)
VALUES ('Rafiq', 'Ahmed', '01733333333', 'rafiq@example.com', 'Sylhet');

-- ACCOUNT
INSERT INTO ACCOUNT (account_type, balance, customer_id, branch_id)
VALUES ('Savings', 10000, 1, 1);

INSERT INTO ACCOUNT (account_type, balance, customer_id, branch_id)
VALUES ('Current', 20000, 2, 2);

INSERT INTO ACCOUNT (account_type, balance, customer_id, branch_id)
VALUES ('Savings', 15000, 3, 3);

-- EMPLOYEE
INSERT INTO EMPLOYEE (first_name, last_name, position, salary, branch_id)
VALUES ('Mahmud', 'Rahman', 'Manager', 50000, 1);

INSERT INTO EMPLOYEE (first_name, last_name, position, salary, branch_id)
VALUES ('Aminul', 'Karim', 'Cashier', 30000, 2);

-- TRANSACTION
INSERT INTO TRANSACTION (account_id, transaction_type, amount, performed_by)
VALUES (1, 'Deposit', 5000, 'Mahmud');

INSERT INTO TRANSACTION (account_id, transaction_type, amount, performed_by)
VALUES (2, 'Withdrawal', 2000, 'Aminul');
