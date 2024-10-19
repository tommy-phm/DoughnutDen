CREATE TABLE Doughnuts (
    DoughnutID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(32) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Price DECIMAL(4, 2) NOT NULL,
    Status BOOLEAN NOT NULL,
    ImageName VARCHAR(32) NOT NULL
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

INSERT INTO Doughnuts (Name, Description, Price, Status)
VALUES 
('Glazed Raised', 'A fluffy raised doughnut covered in a sweet, shiny glaze.', 93.68, True, 'Glazed.png'),
('Sugar Raised', 'A light and airy raised doughnut rolled in sugar for a sweet crunch.', 82.58, True, 'Sugar.png'),
('Chocolate Raised', 'A decadent raised doughnut topped with rich chocolate icing.', 71.34, True, 'Chocolate.png'),
('Plain Cake', 'A classic cake doughnut, soft and lightly sweetened for a comforting taste.', 69.90, True, 'PlainCake.png'),
('Chocolate Cake', 'A moist and chocolatey cake doughnut, perfect for chocolate lovers.', 93.32, True, 'ChocolateCake.png'),
('Sugar Cake', 'A sweet cake doughnut dusted with granulated sugar for extra sweetness.', 86.75, True, 'SugarCake.png'),
('Lemon Filled', 'A zesty filled doughnut bursting with fresh lemon curd.', 74.43, True, 'LemonFilled.png'),
('Grape Filled', 'A delightful filled doughnut with a sweet grape jam center.', 61.14, True, 'GrapeFilled.png'),
('Custard Filled', 'A creamy filled doughnut with rich vanilla custard for a classic treat.', 89.93, True 'CustardFilled.png');
