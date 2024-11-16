CREATE TABLE Category (
    CategoryID TINYINT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(32) NOT NULL
);

CREATE TABLE Doughnuts (
    DoughnutID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(32) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Price DECIMAL(4, 2) NOT NULL,
    Status BOOLEAN NOT NULL,
    CategoryID TINYINT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE Trays (
    TrayID INT AUTO_INCREMENT PRIMARY KEY,
    DoughnutID INT NOT NULL,
    DateTime DATETIME NOT NULL,
    TotalQty TINYINT NOT NULL,
    FreshQty TINYINT NOT NULL,
    FOREIGN KEY (DoughnutID) REFERENCES Doughnuts(DoughnutID)
);

CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATETIME NOT NULL,
    Status BOOLEAN NOT NULL
);

CREATE TABLE TransactionDetails (
    TransactionID INT NOT NULL,
    DoughnutID INT NOT NULL,
    DoughnutQty INT NOT NULL,
    PRIMARY KEY (TransactionID, DoughnutID),
    FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID),
    FOREIGN KEY (DoughnutID) REFERENCES Doughnuts(DoughnutID)
);

INSERT INTO Category (Name)
VALUES 
('Raised'),
('Cake'),
('Filled');

INSERT INTO Doughnuts (Name, Description, Price, Status, CategoryID)
VALUES 
('Glazed', 'A fluffy raised doughnut covered in a sweet, shiny glaze.', 93.68, TRUE, 1),
('Sugar', 'A light and airy raised doughnut rolled in sugar for a sweet crunch.', 82.58, TRUE, 1),
('Chocolate', 'A decadent raised doughnut topped with rich chocolate icing.', 71.34, TRUE, 1),
('Plain', 'A classic cake doughnut, soft and lightly sweetened for a comforting taste.', 69.90, TRUE, 2),
('Chocolate', 'A moist and chocolatey cake doughnut, perfect for chocolate lovers.', 94.32, TRUE, 2),
('Sugar', 'A sweet cake doughnut dusted with granulated sugar for extra sweetness.', 86.75, TRUE, 2),
('Lemon', 'A zesty filled doughnut bursting with fresh lemon curd.', 74.43, TRUE, 3),
('Grape', 'A delightful filled doughnut with a sweet grape jam center.', 61.14, TRUE, 3),
('Custard', 'A creamy filled doughnut with rich vanilla custard for a classic treat.', 71.45, TRUE, 3),
('Mint Toothpaste', 'A mint toothpaste stuffed doughnut with a refeshing and playful twist.', 85.94, TRUE, 3); 

INSERT INTO Trays (DoughnutID, DateTime, TotalQty, FreshQty)
VALUES
(1, '1201-1-15 01:48:51', 50, 34),
(2, '1853-7-15 22:35:16', 34, 21),
(3, '1969-12-15 05:11:23', 8, 4),
(4, '2002-6-15 03:21:38', 121, 2),
(5, '2010-11-15 19:46:43', 84, 53),
(6, '2016-4-15 08:25:26', 2, 1),
(7, '2024-9-14 02:13:48', 23, 19),
(8, '2024-11-15 17:54:13', 43, 1),
(9, '2024-11-15 12:34:25', 6, 6);

INSERT INTO Transactions (Date, Status)
VALUES
('1947-08-15 11:23:49', TRUE),
('2024-03-29 9:43:51', TRUE),
('2024-11-15 13:01:02', FALSE);

INSERT INTO TransactionDetails (TransactionID, DoughnutID, DoughnutQty)
VALUES
(1, 1, 2),
(1, 2, 9),
(1, 3, 7),
(2, 4, 12),
(2, 5, 8),
(2, 6, 6),
(3, 7, 4),
(3, 8, 38562),
(3, 9, 1);
