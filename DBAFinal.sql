-- Victoria Kincaid DBA Final

-- The first step for all of this is to set up IPEDS because this whole final is using Ipeds
USE [IPEDS 2019-2020]
GO


/*
2.	Write a view which uses AND/OR logic to find HD2019.UNITID, INSTNM, CITY, STABBR, EFYTOTLT for the states of NC, SC, VA, TN, GA.


Using AND/OR logic, write a query which searches the total student
enrollment (from EFFY2019 use EFFYLEV = 1) for the states of NC, SC,
VA, TN, GA. Please include the following columns: HD2019.UNITID, 
INSTNM,CITY, STABBR, EFYTOTLT. Order the resulting dataset by INSTNM.
Comment each line of your code.
*/


GO
-- 4. Create it as a view
CREATE VIEW TotalEnrollment AS
-- 2. Select statement from those join tables
SELECT HD2019.UNITID, INSTNM, CITY, STABBR, EFYTOTLT
-- 1. Set up our join tables
FROM HD2019 JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
-- 3. Explain exactly what we want
WHERE (EFFYLEV = 1) AND (STABBR = 'NC' OR STABBR = 'SC' OR STABBR = 'VA' OR STABBR = 'TN' OR STABBR = 'GA');



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
3.	Write a store procedure which takes enrollment size as an input variable and finds 4-year colleges/universities with enrollment greater than or equal to the 
input enrollment size. The resulting dataset should display UNITID, INSTNM, CITY, STABBR, EFFYTOTLT, IC2019_AY.chg2ay3, and IC2019_AY.chg3ay3.
*/

GO
CREATE PROC spGreaterEnrollment @EFYTOTLT INT, @Everything INT OUTPUT  
AS
BEGIN
	SELECT  HD2019.UNITID AS 'UNIT ID', HD2019.INSTNM AS 'INSTITUTION NAME', HD2019.CITY, HD2019.STABBR AS 'STATE',
			FORMAT(EFFY2019.EFYTOTLT, 'N0') AS 'TOTAL STUDENTS', FORMAT(IC2019_AY.CHG2AY3, 'c0') AS 'IN STATE TUITION', FORMAT(IC2019_AY.CHG3AY3, 'c0') AS 'OUT OF STATE TUITION'
	FROM HD2019 JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
		 JOIN IC2019_AY ON HD2019.UNITID = IC2019_AY.UNITID
	WHERE ICLEVEL = 1 AND EFFYLEV = 1 AND EFYTOTLT >= @EFYTOTLT;
	SELECT @Everything = @@ROWCOUNT;
END;

DECLARE @Problem3 INT;
EXEC spGreaterEnrollment
	@EFYTOTLT = 100000, -- this is where you change the variable
	@Everything = @Problem3 OUTPUT;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
4.	Write a stored procedure which takes part of INSTNM as an input variable and finds the UNITID, INSTNM, CITY, STABBR, TUITION2 (from IC2019_AY) for the institution(s).
*/

GO
CREATE PROC spGiveAName @INSTNM VARCHAR(50), @Everything INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT HD2019.UNITID, INSTNM, CITY, STABBR, TUITION2 
	FROM HD2019 JOIN IC2019_AY ON HD2019.UNITID = IC2019_AY.UNITID
	WHERE INSTNM LIKE '%'+@INSTNM+'%';
END;

GO
DECLARE @Problem4 INT;
EXEC spGiveAName
	@INSTNM = '%PEM%',-- this is where we change the variable
	@Everything = @Problem4 OUTPUT;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 
5.	Write a stored procedure which take STABBR as an input variable and finds UNITID, INSTNM, CITY, STABBR, HBCU, TRIBAL, MIN(TUITION2) (from IC2019_AY) for the institutions in that state.
*/

GO
CREATE PROC spStateInfo @STABBR VARCHAR(2), @Everything INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT HD2019.UNITID, INSTNM, CITY, STABBR, HBCU, TRIBAL, MIN(TUITION2) AS MinimumTuition
	FROM HD2019 JOIN IC2019_AY ON HD2019.UNITID = IC2019_AY.UNITID
	WHERE STABBR = @STABBR
	GROUP BY HD2019.UNITID, INSTNM, CITY, STABBR, HBCU, TRIBAL;
END;

DECLARE @Problem5 INT;
EXEC spStateInfo
	@STABBR = '%HI%', -- this is where we change the variable
	@Everything = @Problem5 OUTPUT;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* 
8.	Write a stored procedure which takes STABBR as an input variable and finds total enrollment (EFFYTOTLT) in each of the community in the input variable state and 
insert this data into a new table called NCCommunityCollegesEnrollment. The table should include: UNITID, INSTNM, TotalEnrollment. 
*/

GO
CREATE PROC spNewTable @STABBR VARCHAR(2), @Everything INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT DISTINCT HD2019.UNITID, INSTNM, EFYTOTLT AS "TotalEnrollment"
	INTO NCCommunityCollegesEnrollment
	FROM HD2019 JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
	WHERE STABBR = @STABBR AND ICLEVEL = 2
END;

DECLARE @Problem8 INT;
EXEC spNewTable
	@STABBR = 'NY', -- yes, this is where we change the variable
	@Everything = @Problem8 OUTPUT;