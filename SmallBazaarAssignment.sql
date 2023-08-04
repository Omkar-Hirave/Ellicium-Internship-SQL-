-- 1. The CEO of 'Small Bazar' wants to check the profitability of the Branches. Create a View  for his use, which will show monthly Profit of all Branches for the current year.
CREATE VIEW proitability AS
SELECT sb.BranchID, 
    SUM((bp.Sellingprice - bp.CostPrice) * op.Order_quantity) AS Net_profit,
    MONTH(o.orderDate) AS Month
FROM BranchProduct bp
INNER JOIN Branch_of_store sb ON bp.BranchID = sb.BranchID
INNER JOIN Products p ON bp.ProductID = p.ProductID
INNER JOIN Orders o ON p.ProductID = o.ProductID
INNER JOIN OrderProduct op ON o.OrderID = op.OrderID
GROUP BY sb.BranchID, MONTH(o.orderDate);

SELECT * FROM profitability;

-- 2. Create a stored procedure having countryName, FromDate, and ToDate as parameters,
-- which will return Sitewise, Item Wise, and Date Wise the number of items sold in the
-- given Date range as separate result sets. Create appropriate Indexes on the tables.
DROP PROCEDURE ItemsSoldOnGivenDate
CREATE  PROCEDURE ItemsSoldOnGivenDate (@CountryOfBranch VARCHAR(20), @FromDate DATE, @ToDate DATE)
AS
BEGIN
    -- Stored procedure to get Itemwise/productwise count group the items by productID
    SELECT p.ProductID, SUM(op.Order_Quantity) AS ItemWiseCount 
    FROM OrderProduct op
    INNER JOIN Products p ON op.ProductID = p.ProductID
    INNER JOIN BranchProduct bp ON p.ProductID = bp.ProductID
    INNER JOIN Orders o ON op.OrderID = o.OrderID
    INNER JOIN branch_of_store sb ON bp.BranchID = sb.BranchID
    WHERE sb.BranchCountry = @CountryOfBranch 
        AND o.OrderDate BETWEEN @FromDate AND @ToDate
    GROUP BY p.ProductID 
	END;
	EXEC 
    -- to get Datewise count group the items by orderDate
    SELECT o.OrderDate, SUM(op.Order_Quantity) AS DateWiseCount 
    FROM Products p
    INNER JOIN OrderProduct op ON p.ProductID = op.ProductID
    INNER JOIN Orders o ON op.OrderID = o.OrderID
    INNER JOIN BranchProduct bp ON p.ProductID = bp.ProductID
    INNER JOIN StoreBranch sb ON bp.BranchID = sb.BranchID
    WHERE sb.BranchCountry = @CountryOfBranch 
        AND o.OrderDate BETWEEN @FromDate AND @ToDate
    GROUP BY o.OrderDate;

    -- to get Datewise count group the items by BranchCity	
    SELECT sb.BranchCity, SUM(op.Order_Quantity) AS SiteWiseCount 
    FROM OrderProduct op
    INNER JOIN Products p ON op.ProductID = p.ProductID
    INNER JOIN BranchProduct bp ON p.ProductID = bp.ProductID
    INNER JOIN branch_of_store sb ON bp.BranchID = sb.BranchID
    INNER JOIN Orders o ON op.OrderID = o.OrderID
    WHERE sb.BranchCountry = @CountryOfBranch 
        AND o.OrderDate BETWEEN @FromDate AND @ToDate
    GROUP BY sb.BranchCity;
END;
GO

EXEC ItemsSoldOnGivenDate 'America', '2023-01-16', '2023-04-08'

 --3. Create a stored procedure which will calculate the total bill for any order. Bill should
 --have details like:
 --CustomerName,
 --orderId,
 --OrderDate,
 --Branch,
 --ProductName,
 --Price per Unit,
 --No. Of Units,
 --Total Cost of that product,
 --Total Bill Amount,
 --Additional Charges (0 if none),
 --Delivery Option ('Home Delivery' or 'self-Pickup').
 
CREATE PROCEDURE GetMeBillPlease
    @EnteredOrderID INT
AS
BEGIN
    IF @EnteredOrderID IS NULL
    BEGIN
        SELECT 'Please enter something' AS Message;
    END
    ELSE IF NOT EXISTS (SELECT OrderID FROM Orders WHERE OrderID = @EnteredOrderID)
    BEGIN
        SELECT 'Please enter valid order id' AS Message;
    END
    ELSE
    BEGIN
        WITH cte1 AS (
            SELECT
                CONCAT(c.C_FirstName, ' ', c.C_LastName) AS CustomerName,
                o.OrderID,
                o.OrderDate,
                sb.BranchName,
                p.ProductName,
                op.Order_Quantity AS No_Of_Units,
                bp.SellingPrice AS Total_Cost_of_that_product,
                (op.Order_Quantity * bp.SellingPrice) AS TotalAmount,
                o.Delivery_Type AS DeliveryType
            FROM
                Customer c
                INNER JOIN Orders o ON c.CustomerID = o.CustomerID
                INNER JOIN OrderProduct op ON o.OrderID = op.OrderID
                INNER JOIN Products p ON op.ProductID = p.ProductID
                INNER JOIN BranchProduct bp ON p.ProductID = bp.ProductID
                INNER JOIN StoreBranch sb ON bp.BranchID = sb.BranchID
            WHERE
                o.OrderID = @EnteredOrderID
        ),
        cte2 AS (
            SELECT
                CONCAT(c.C_FirstName, ' ', c.C_LastName) AS CustomerName,
                SUM(op.Order_Quantity * bp.SellingPrice) AS TotalBill,
                CASE
                    WHEN o.Delivery_Type = 'Home Delivery' OR op.No_of_bags <> 0 THEN (20 * COUNT(o.OrderID) + 10 * op.No_of_bags)
                    ELSE 0
                END AS AdditionalCharges
            FROM
                Customer c
                INNER JOIN Orders o ON c.CustomerID = o.CustomerID
                INNER JOIN OrderProduct op ON o.OrderID = op.OrderID
                INNER JOIN Products p ON op.ProductID = p.ProductID
                INNER JOIN BranchProduct bp ON p.ProductID = bp.ProductID
                INNER JOIN StoreBranch sb ON bp.BranchID = sb.BranchID
            WHERE
                o.OrderID = @EnteredOrderID
            GROUP BY
                o.OrderID,
                c.C_FirstName,
                c.C_LastName
        )
        SELECT
            cte1.CustomerName,
            cte1.OrderID,
            cte1.OrderDate,
            cte1.BranchName,
            cte1.ProductName,
            cte1.Total_Cost_of_that_product,
            cte1.TotalAmount,
            cte1.DeliveryType,
            cte2.TotalBill,
            cte2.AdditionalCharges
        FROM
            cte1
            INNER JOIN cte2 ON cte1.CustomerName = cte2.CustomerName;
    END
END
GO

EXEC GetMeBillPlease @EnteredOrderID = 2;

-- 4. Create a stored procedure having a parameter as country name, which displays all
-- the branches available in the country that are active.
CREATE PROCEDURE BranchesInCountries
    @NameOfCountry VARCHAR(30)
AS
BEGIN
    -- to get branchname under a country having a status as active
    SELECT BranchCountry, BranchName
    FROM storebranch
    WHERE BranchCountry = @NameOfCountry AND is_Branch_active = 'active';
END
GO

USE SmallBazar;
EXEC BranchesInCountries @NameOfCountry = 'Canada';

-- 5. The CEO of 'Small Bazar' wants to check the profitability of the Branches. Create a
-- stored procedure that shows the branch profit if profit is below a certain threshold flag
-- that branch as below par performance.
CREATE PROCEDURE profitabilityBelowThreshold
    @ThresholdAmount INT
AS
BEGIN
    WITH cte AS (
        SELECT sb.BranchID, sb.BranchName,
        CASE
            WHEN SUM((bp.SellingPrice - bp.CostPrice) * op.Order_Quantity) < @ThresholdAmount
            THEN SUM((bp.SellingPrice - bp.CostPrice) * op.Order_Quantity)
            ELSE NULL
        END AS below_par_performance
        FROM BranchProduct bp
        INNER JOIN storebranch sb ON bp.BranchID = sb.BranchID
        INNER JOIN products p ON bp.productID = p.productID
        INNER JOIN OrderProduct op ON op.productID = bp.productID
        INNER JOIN Orders o ON o.OrderID = op.OrderID
        GROUP BY sb.BranchID, sb.BranchName
    )
    SELECT *
    FROM cte
    WHERE below_par_performance IS NOT NULL;
END
GO

EXEC profitabilityBelowThreshold @ThresholdAmount = 5000000;
