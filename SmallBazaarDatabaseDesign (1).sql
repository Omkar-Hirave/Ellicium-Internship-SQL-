-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.
CREATE DATABASE SmallBazar;
USE SmallBazar;
CREATE TABLE `Customer` (
    `CustomerID` INT  NOT NULL AUTO_INCREMENT,
    `C_FirstName` VARCHAR(20)  NOT NULL ,
    `C_LastName` VARCHAR(20)  NOT NULL ,
    `C_Phone` BIGINT  NOT NULL ,
    `Address1` VARCHAR(20)  NOT NULL ,
    `Address2` VARCHAR(20)  NOT NULL ,
    `Customer_email` VARCHAR(50)  NOT NULL ,
    `Customer_SSN` VARCHAR(20)  NOT NULL ,
    PRIMARY KEY (
        `CustomerID`
    )
);
INSERT INTO Customer VALUES(null,'Omkar','Hirave',9529433723,'Vadgaon','Pune','omkarhirve05@gmail.com','45684535968');
INSERT INTO Customer VALUES(null,'Vikas','Mulik',95458644266,'Bhigwan','Pune','Vikasmulik@gmail.com','456978634564');
INSERT INTO Customer VALUES(null,'Gaurav','Patil',95445678132,'Nashik','Pune','gauravpatil@gmail.com','45789934564');
INSERT INTO Customer VALUES(null,'Sagar','Rote',95784561312,'Jejuri','Pune','Sagarrote@gmail.com','45879465421');
INSERT INTO Customer VALUES(null,'Ravikiran','Batale',9578651232,'Nagpur','Pune','Ravibatale@gmail.com','45784313321');
SELECT * FROM Customer;

CREATE TABLE `Products` (
    `ProductID` INT  NOT NULL AUTO_INCREMENT,
    `ProductName` VARCHAR(20)  NOT NULL ,
    `ProductType` VARCHAR(20)  NOT NULL ,
    PRIMARY KEY (
        `ProductID`
    )
);
INSERT INTO Products VALUES(null,'Amul','Gloceries');
-- INSERT INTO Products VALUES(null,'Parle','Gloceries');
INSERT INTO Products VALUES(null,'Kissan','Gloceries');
INSERT INTO Products VALUES(null,'Emami','Gloceries');
INSERT INTO Products VALUES(null,'Mother Dairy.','Gloceries');
SELECT * FROM Products;


CREATE TABLE `Orders` (
    `OrderID` INT  NOT NULL AUTO_INCREMENT,
    `OrderDate` DATE  NOT NULL ,
    `Delivery_type` VARCHAR(20)  NOT NULL ,
    `CustomerID` INT  NOT NULL ,
    `ProductID` INT  NOT NULL ,
    PRIMARY KEY (
        `OrderID`
    )
);
INSERT INTO Orders VALUES(null,'2023/01/16','self pickup',1,1);
INSERT INTO Orders VALUES(null,'2023/03/18','self pickup',3,2);
INSERT INTO Orders VALUES(null,'2023/04/08','Home Delivery',2,1);
INSERT INTO Orders VALUES(null,'2023/01/16','self pickup',4,1);
INSERT INTO Orders VALUES(null,'2023/01/16','self pickup',2,1);
SELECT * FROM Orders;


CREATE TABLE `StoreBranch` (
    `BranchID` INT  NOT NULL AUTO_INCREMENT,
    `BranchName` VARCHAR(30)  NOT NULL ,
    `BranchCity` VARCHAR(20)  NOT NULL ,
    `Branch_Manager` VARCHAR(20)  NOT NULL ,
    `Is_Branch_Active` VARCHAR(20)  NOT NULL ,
    PRIMARY KEY (
        `BranchID`
    )
);
INSERT INTO StoreBranch VALUES(null,'re:INVENT','Sedona','Tushar','Active');
INSERT INTO StoreBranch VALUES(null,'Arizona','Sedona','Jeevan','Active');
INSERT INTO StoreBranch VALUES(null,'Seattle','Washington','Ankur','Inactive');
INSERT INTO StoreBranch VALUES(null,'re:INVENT','Brazil','Tushar','Active');
INSERT INTO StoreBranch VALUES(null,'Dawson','Hyderabad','Ankur','Inactive');
SELECT * FROM StoreBranch;


CREATE TABLE `BranchProduct` (
    `BranchID` INT  NOT NULL ,
    `ProductID` INT  NOT NULL ,
    `SellingPrice` INT  NOT NULL ,
    `CostPrice` INT  NOT NULL ,
    `Quantity` INT  NOT NULL 
);
INSERT INTO BranchProduct VALUES();
DESC BranchProduct ;
INSERT INTO BranchProduct VALUES(1,1,100,200,5);
INSERT INTO BranchProduct VALUES(1,2,200,100,4);
INSERT INTO BranchProduct VALUES(1,3,400,300,2);
INSERT INTO BranchProduct VALUES(1,1,100,200,3);
INSERT INTO BranchProduct VALUES(1,1,600,200,5);
INSERT INTO BranchProduct VALUES(1,4,300,100,4);
INSERT INTO BranchProduct VALUES(2,1,470,300,4);
INSERT INTO BranchProduct VALUES(2,3,450,300,2);
INSERT INTO BranchProduct VALUES(2,1,200,100,9);
INSERT INTO BranchProduct VALUES(3,1,150,50,7);
INSERT INTO BranchProduct VALUES(3,2,200,100,6);
INSERT INTO BranchProduct VALUES(3,1,500,320,2);
INSERT INTO BranchProduct VALUES(4,3,700,450,7);
INSERT INTO BranchProduct VALUES(4,2,800,500,6);
INSERT INTO BranchProduct VALUES(5,3,700,300,11);
INSERT INTO BranchProduct VALUES(5,4,600,200,6);
INSERT INTO BranchProduct VALUES(6,4,600,200,8);
INSERT INTO BranchProduct VALUES(6,3,700,150,11);
INSERT INTO BranchProduct VALUES(6,4,600,250,69);
SELECT * FROM BranchProduct;
DESC BranchProduct;
USE SmallBazar;
CREATE TABLE `OrderProduct` (
    `OrderID` INT  NOT NULL ,
    `ProductID` INT  NOT NULL ,
    `No_of_Bags` INT  NOT NULL 
);
DESC OrderProduct;
INSERT INTO OrderProduct VALUES(2,1,0,100);
INSERT INTO OrderProduct VALUES(2,2,4,200);
INSERT INTO OrderProduct VALUES(5,2,5,400);
INSERT INTO OrderProduct VALUES(4,3,4,100);
INSERT INTO OrderProduct VALUES(3,1,5,100);
SELECT * FROM OrderProduct;
ALTER TABLE OrderProduct ADD COLUMN Order_Quantity INT ;

ALTER TABLE `Orders` ADD CONSTRAINT `fk_Orders_CustomerID` FOREIGN KEY(`CustomerID`)
REFERENCES `Customer` (`CustomerID`);

ALTER TABLE `Orders` ADD CONSTRAINT `fk_Orders_ProductID` FOREIGN KEY(`ProductID`)
REFERENCES `Products` (`ProductID`);

ALTER TABLE `BranchProduct` ADD CONSTRAINT `fk_BranchProduct_BranchID` FOREIGN KEY(`BranchID`)
REFERENCES `StoreBranch` (`BranchID`);

ALTER TABLE `BranchProduct` ADD CONSTRAINT `fk_BranchProduct_ProductID` FOREIGN KEY(`ProductID`)
REFERENCES `Products` (`ProductID`);

ALTER TABLE `OrderProduct` ADD CONSTRAINT `fk_OrderProduct_OrderID` FOREIGN KEY(`OrderID`)
REFERENCES `Orders` (`OrderID`);

ALTER TABLE `OrderProduct` ADD CONSTRAINT `fk_OrderProduct_ProductID` FOREIGN KEY(`ProductID`)
REFERENCES `Products` (`ProductID`);

ALTER TABLE StoreBranch ADD COLUMN BranchCountry VARCHAR(20);
SELECT * FROM StoreBranch;
INSERT INTO StoreBranch VALUES(null,'Eldos','Tushar','Active','America','Los Angeles');
UPDATE StoreBranch SET BranchCity = 'Washington' WHERE BranchID = 1;
UPDATE StoreBranch SET BranchCity = 'London' WHERE BranchID = 2;
UPDATE StoreBranch SET BranchCity = 'Toronto' WHERE BranchID = 3;
UPDATE StoreBranch SET BranchCity = 'Salvador' WHERE BranchID = 4;
UPDATE StoreBranch SET BranchCity = 'Delhi' WHERE BranchID = 5;


