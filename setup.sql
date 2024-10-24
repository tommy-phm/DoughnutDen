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

CREATE TABLE Tractions (
    TractionID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATETIME NOT NULL,
    Status BOOLEAN NOT NULL
);

CREATE TABLE TractionDetails (
    TractionID INT NOT NULL,
    DoughnutID INT NOT NULL,
    DoughnutQty INT NOT NULL,
    PRIMARY KEY (TractionID, DoughnutID),
    FOREIGN KEY (TractionID) REFERENCES Tractions(TractionID),
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
('Custard', 'A creamy filled doughnut with rich vanilla custard for a classic treat.', 75.45, TRUE, 3); 
