-- Create logins for Admin, Staff, and Members
CREATE LOGIN Admin WITH PASSWORD = 'admin_password';
CREATE LOGIN Staff WITH PASSWORD = 'staff_password';
CREATE LOGIN Members WITH PASSWORD = 'members_password';

-- Create database
CREATE DATABASE LibraryManagement_1;
GO

USE LibraryManagement_1;
GO

-- Create users for Admin, Staff, and Members
CREATE USER Admin FOR LOGIN Admin;
CREATE USER Staff FOR LOGIN Staff;
CREATE USER Members FOR LOGIN Members;

-- Create tables
CREATE TABLE Publishers (
    publisher_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    address NVARCHAR(255),
    contact NVARCHAR(50)
);

CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX)
);

CREATE TABLE Books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    isbn NVARCHAR(13) NOT NULL UNIQUE,
    publisher_id INT,
    publication_year INT,
    category_id INT,
    total_copies INT NOT NULL,
    available_copies INT NOT NULL,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    birthdate DATE,
    nationality NVARCHAR(50)
);

CREATE TABLE Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE Members (
    member_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    address NVARCHAR(255),
    membership_date DATE NOT NULL
);

CREATE TABLE Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(100) NOT NULL,
    last_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    position NVARCHAR(100),
    hire_date DATE NOT NULL
);

CREATE TABLE Loans (
    loan_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    staff_id INT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

CREATE TABLE Reservations (
    reservation_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT,
    member_id INT,
    reservation_date DATE NOT NULL,
    status NVARCHAR(20) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

CREATE TABLE EmailNotifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    member_id INT,
    email NVARCHAR(100) NOT NULL,
    subject NVARCHAR(255) NOT NULL,
    body NVARCHAR(MAX) NOT NULL,
    sent_date DATETIME,
    status NVARCHAR(20) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
);

CREATE TABLE Admin (
    admin_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL
);

CREATE TABLE Account (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    role NVARCHAR(50) NOT NULL
);

ALTER TABLE Staff
ADD role NVARCHAR(50) NOT NULL DEFAULT 'Staff';

ALTER TABLE Members
ADD role NVARCHAR(50) NOT NULL DEFAULT 'Member';

-- Grant permissions to Admin
GRANT SELECT, INSERT, UPDATE, DELETE ON Publishers TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Categories TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Books TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Authors TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Book_Authors TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Members TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Staff TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Loans TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Reservations TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON EmailNotifications TO Admin;

-- Grant permissions to Staff
GRANT SELECT, INSERT, UPDATE, DELETE ON Books TO Staff;
GRANT SELECT, INSERT, UPDATE, DELETE ON Loans TO Staff;
GRANT SELECT, INSERT, UPDATE, DELETE ON Reservations TO Staff;
GRANT SELECT, INSERT, UPDATE, DELETE ON EmailNotifications TO Staff;

-- Grant permissions to Members
GRANT SELECT ON Books TO Members;
GRANT SELECT ON Loans TO Members;
GRANT SELECT ON Reservations TO Members;
GRANT SELECT ON EmailNotifications TO Members;
