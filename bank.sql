-------------------------------------------------
-- CLEAN UP OLD OBJECTS
-------------------------------------------------
BEGIN
    FOR rec IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE object_type IN ('TABLE','SEQUENCE','TRIGGER')
    ) LOOP
        BEGIN
            IF rec.object_type = 'TABLE' THEN
                EXECUTE IMMEDIATE 'DROP TABLE "' || rec.object_name || '" CASCADE CONSTRAINTS';
            ELSE
                EXECUTE IMMEDIATE 'DROP ' || rec.object_type || ' "' || rec.object_name || '"';
            END IF;
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
    END LOOP;
END;
/
-- commit not needed here

-------------------------------------------------
-- TABLE CREATION
-------------------------------------------------
-- 1) BANK
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

-- 6) LOAN
CREATE TABLE LOAN (
    loan_id NUMBER PRIMARY KEY,
    amount NUMBER(15,2) CHECK (amount > 0),
    loan_type VARCHAR2(50),
    customer_id NUMBER NOT NULL,
    branch_id NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'Pending',
    CONSTRAINT fk_loan_customer FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    CONSTRAINT fk_loan_branch FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);

-- 7) LOAN_LOG (approval history)
CREATE TABLE LOAN_LOG (
    log_id NUMBER PRIMARY KEY,
    loan_id NUMBER,
    approved_on DATE,
    approved_by VARCHAR2(50)
);

-------------------------------------------------
-- CREATE SEQUENCES
-------------------------------------------------
CREATE SEQUENCE seq_bank START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_branch START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE seq_customer START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE seq_account START WITH 5000 INCREMENT BY 1;
CREATE SEQUENCE seq_employee START WITH 2000 INCREMENT BY 1;
CREATE SEQUENCE seq_loan START WITH 9000 INCREMENT BY 1;
CREATE SEQUENCE seq_loan_log START WITH 1 INCREMENT BY 1;

-------------------------------------------------
-- TRIGGERS TO AUTO-POPULATE PRIMARY KEYS
-------------------------------------------------
CREATE OR REPLACE TRIGGER trg_bank_pk
BEFORE INSERT ON BANK
FOR EACH ROW
BEGIN
    IF :NEW.bank_id IS NULL THEN
        :NEW.bank_id := seq_bank.NEXTVAL;
    END IF;
END;
/ 

CREATE OR REPLACE TRIGGER trg_branch_pk
BEFORE INSERT ON BRANCH
FOR EACH ROW
BEGIN
    IF :NEW.branch_id IS NULL THEN
        :NEW.branch_id := seq_branch.NEXTVAL;
    END IF;
END;
/ 

CREATE OR REPLACE TRIGGER trg_customer_pk
BEFORE INSERT ON CUSTOMER
FOR EACH ROW
BEGIN
    IF :NEW.customer_id IS NULL THEN
        :NEW.customer_id := seq_customer.NEXTVAL;
    END IF;
END;
/ 

CREATE OR REPLACE TRIGGER trg_account_pk
BEFORE INSERT ON ACCOUNT
FOR EACH ROW
BEGIN
    IF :NEW.account_id IS NULL THEN
        :NEW.account_id := seq_account.NEXTVAL;
    END IF;
END;
/ 

CREATE OR REPLACE TRIGGER trg_employee_pk
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF :NEW.employee_id IS NULL THEN
        :NEW.employee_id := seq_employee.NEXTVAL;
    END IF;
END;
/ 

CREATE OR REPLACE TRIGGER trg_loan_pk
BEFORE INSERT ON LOAN
FOR EACH ROW
BEGIN
    IF :NEW.loan_id IS NULL THEN
        :NEW.loan_id := seq_loan.NEXTVAL;
    END IF;
END;
/ 

CREATE OR REPLACE TRIGGER trg_loanglog_pk
BEFORE INSERT ON LOAN_LOG
FOR EACH ROW
BEGIN
    IF :NEW.log_id IS NULL THEN
        :NEW.log_id := seq_loan_log.NEXTVAL;
    END IF;
END;
/ 

-------------------------------------------------
-- BUSINESS TRIGGERS (validation / auto actions)
-------------------------------------------------
-- Prevent negative balance on INSERT or UPDATE
CREATE OR REPLACE TRIGGER trg_no_negative_balance
BEFORE INSERT OR UPDATE ON ACCOUNT
FOR EACH ROW
BEGIN
    IF :NEW.balance < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Balance cannot be negative.');
    END IF;
END;
/ 

-- Ensure default loan status = 'Pending' if not provided
CREATE OR REPLACE TRIGGER trg_default_loan_status
BEFORE INSERT ON LOAN
FOR EACH ROW
BEGIN
    IF :NEW.status IS NULL THEN
        :NEW.status := 'Pending';
    END IF;
END;
/ 

-- Log loan approval: when LOAN.status changes to 'Approved'
CREATE OR REPLACE TRIGGER trg_log_loan_approval
AFTER UPDATE OF status ON LOAN
FOR EACH ROW
WHEN (NEW.status = 'Approved')
BEGIN
    INSERT INTO LOAN_LOG (loan_id, approved_on, approved_by)
    VALUES (:NEW.loan_id, SYSDATE, USER);
END;
/ 

-------------------------------------------------
-- INSERT SAMPLE DATA (in correct dependency order)
-------------------------------------------------
-- Banks (explicit IDs okay; triggers won't override because value is provided)
INSERT INTO BANK (bank_id, bank_name, head_office) VALUES (1, 'National Bank', 'Dhaka Head Office');
INSERT INTO BANK (bank_id, bank_name, head_office) VALUES (2, 'City Bank', 'Chittagong Head Office');

-- Branches (reference existing bank_id)
INSERT INTO BRANCH (branch_id, branch_name, bank_id, address) VALUES (101, 'Dhaka Main', 1, 'Motijheel, Dhaka');
INSERT INTO BRANCH (branch_id, branch_name, bank_id, address) VALUES (102, 'Gulshan Branch', 1, 'Gulshan, Dhaka');
INSERT INTO BRANCH (branch_id, branch_name, bank_id, address) VALUES (201, 'Chittagong Main', 2, 'Agrabad, Chittagong');

-- Customers
INSERT INTO CUSTOMER (customer_id, first_name, last_name, phone, email, address)
VALUES (1001, 'Forhad', 'Hossain', '01711111111', 'forhad@example.com', 'Dhaka');

INSERT INTO CUSTOMER (customer_id, first_name, last_name, phone, email, address)
VALUES (1002, 'Samiul', 'Islam', '01722222222', 'samiul@example.com', 'Chittagong');

INSERT INTO CUSTOMER (customer_id, first_name, last_name, phone, email, address)
VALUES (1003, 'Rafiq', 'Ahmed', '01733333333', 'rafiq@example.com', 'Sylhet');

-- Accounts (customer_id & branch_id must exist)
INSERT INTO ACCOUNT (account_id, account_type, balance, customer_id, branch_id)
VALUES (5001, 'Sav
