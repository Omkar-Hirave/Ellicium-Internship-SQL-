-- Write a user defined function that takes a value as a parameter and and outputs the date or error when the date is not valid
DELIMITER //
CREATE FUNCTION getValidDate(user_date VARCHAR(20))
RETURNS VARCHAR(40) 	
DETERMINISTIC
BEGIN 
	DECLARE my_Date VARCHAR(20) ;
    DECLARE month1 VARCHAR(40) DEFAULT 0;
    SELECT user_date INTO my_Date;
     IF LENGTH(my_Date) <> 8 THEN 
		RETURN null ;
	 ELSEIF SUBSTRING(my_date,7,2) > 31 THEN 
		RETURN null;
     ELSEIF SUBSTRING(my_Date,5,2) = 01  THEN
		SET Month1 = 'Jan';
	ELSEIF (((SUBSTRING(my_Date,5,2) = 02)  AND (SUBSTRING(my_Date,7,2) <= 29))
    AND  ((SUBSTRING(my_Date,1,4) % 4 = 0) AND (SUBSTRING(my_Date,1,4) % 100 <> 0))  OR SUBSTRING(my_Date,1,4) % 400 = 0) THEN
		SET Month1 = 'Feb';
	ELSEIF (SUBSTRING(my_Date,5,2) = 03 AND SUBSTRING(my_date,7,2) <= 31 )  THEN
		SET Month1 = 'March';
	ELSEIF (SUBSTRING(my_Date,5,2) = 04 AND SUBSTRING(my_date,7,2) <= 30 )  THEN
		SET Month1 = 'Apr';
	ELSEIF (SUBSTRING(my_Date,5,2) = 05 AND SUBSTRING(my_date,7,2) <= 31 )  THEN
		SET Month1 = 'May';
	ELSEIF (SUBSTRING(my_Date,5,2) = 06 AND SUBSTRING(my_date,7,2) <= 30 )  THEN
		SET Month1 = 'June';
	ELSEIF (SUBSTRING(my_Date,5,2) = 07 AND SUBSTRING(my_date,7,2) <= 31 )  THEN
		SET Month1 = 'July';
	ELSEIF (SUBSTRING(my_Date,5,2) = 08 AND SUBSTRING(my_date,7,2) <= 31 )  THEN
		SET Month1 = 'Aug';
	ELSEIF (SUBSTRING(my_Date,5,2) = 09 AND SUBSTRING(my_date,7,2) <= 30 )  THEN
		SET Month1 = 'Sep';
	ELSEIF (SUBSTRING(my_Date,5,2) = 10 AND SUBSTRING(my_date,7,2) <= 31 )  THEN
		SET Month1 = 'Oct';
	ELSEIF (SUBSTRING(my_Date,5,2) = 11 AND SUBSTRING(my_date,7,2) <= 30 )  THEN
		SET Month1 = 'Nov';
	ELSEIF (SUBSTRING(my_Date,5,2) = 12 AND SUBSTRING(my_date,7,2) <= 31 )  THEN
		SET Month1 = 'Dec';
	ELSE 
		RETURN  null;
    END IF;
	RETURN CONCAT(SUBSTRING(my_Date,1,4),'-',month1,'-',SUBSTRING(my_Date,7,2));
END //
DELIMITER ;

SELECT getValidDate(16000229) as 'Actual_Date';
DROP FUNCTION getValidDate;
SELECT LENGTH(20230229) 
USE UserDefinedFunctions