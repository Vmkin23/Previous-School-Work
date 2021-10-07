/* Victoria Kincaid */

/*Provide definition and examples of the following terms.
Chapter 3:
			Column Alias:				Definition - A new column name from a column that contains a calculated value
										Example - SELECT InvoiceTotal - CreditTotal AS RealInvoiceTotal FROM Invoices;
			
			Concatenate:				Definition - to combine
										Example - SELECT VendorCity + ' ' + VendorState FROM VENDORS;
			
			Order of Precedence:		Definition - The order in which the SQL server will solve arithmetic expressions, left to right and multiplication, division and modulo operations
													first followed by addition and subtraction. You can utilize parantheses, it will read the most inner parantheses problem first
										Example - SELECT InvoiceID, InvoiceID + 7 * 3 as OrderofPrecedence, FROM Invoices;
			
			Argument:					Definition - A part of a function, a function consists of parameters and an argument to be set up. A function performs an operation and returns a value, and
													an argument is setting up in the function the operation
										Example - SELECT InvoiceDate GETDATE() AS 'Today''s Date' FROM Invoices;
			
			Subquery:					Definition - A SELECT statement within another statement
										Example - WHERE VendorID IN (SELECT VendorID FROM Invoices WHERE InvoiceDate = '2021-09-27')

Chapter 4: 
			Table Alias:				Definition - Temporary names assigned to a table that has been JOINed in the FROM clause, a correlation name for a table 
										Example -	SELECT InvoiceNumber FROM Invoices JOIN InvoiceLineItems AS LineItems ON Invoices.InvoiceID = LineItems.InvoiceID 
			
			Fully-Qualified Object Name:Definition - Made up of four parts: the server name, the database name, the schema name (typically dbo), and the name of the object (typically a table)
										Example - linked_server.database.schema.object, DBServer.AP.dbo.Vendors
			
			Left Outer Join:			Definition - An outer join that retrieves all rows that are from the first (left) table
										Example - SELECT DeptName FROM Departments LEFT JOIN Employees ON Departmenets.DeptNo = Employees.DeptNo;
			
			Right Outer Join:			Definition - An outer join that retrieves all rows from the second (right) table
										Example - SELECT DeptName FROM Departments RIGHT JOIN Employees ON Departmenets.DeptNo = Employees.DeptNo;
			
			Full Outer Join:			Definition - An outer join that retrieves all rows from both tables
										Example - SELECT DeptName FROM Departments FULL JOIN Employees ON Departmenets.DeptNo = Employees.DeptNo;
*/

/* Please make sure that your are commenting each line of code to explain what your code is accomplishing!!! */
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* CH3.5. "Modify the solution to exercise 2 to filter for invoices with an InvoiceTotal that's greater than or equal to $500 but less than or equal to $10,000" */

/* First, we have to do exercise 2 so we are going to set our database, for these problems it will always be AP so we will only need to set this once */
USE AP
GO
/*After we have set our Database, AP, we will need to do our FROM and SELECT Statements, first FROM Invoices, then SELECT the parameters listed in problem #2 */
SELECT InvoiceNumber AS Number, InvoiceTotal AS Total, PaymentTotal+CreditTotal AS Credits,InvoiceTotal - (PaymentTotal + CreditTotal) AS Balance
FROM Invoices
/*Once we have met our two requirements for problem #2 we can work on problem #5 where we need to introduce our WHERE clause*/
WHERE InvoiceTotal>= 500 AND InvoiceTotal <= 10000

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH3.6. "Modify the solution to exercise 3 to filter for contacts whose last name begins with the letter A, B, C, or E" */

/*First things first we need to do exercise 3, for that we will need to first create our FROM and SELECT statements*/
SELECT VendorContactLName+','+VendorContactFName AS 'Full Name' 
FROM Vendors
/*Syntax wise, this is where we will solve Problem #6, We need to filter it so that we get last names starting with A,B,C, or E
  It took some trial and error to figure this out, at first I was trying to do <'F' and <> 'D', but that didn't work and doing 
  = 'E' didn't pull it up either because it was looking for exactly E, here I was able to use 'E%' to get any last name starting with E. */
WHERE VendorContactLName < 'D' OR VendorContactLName LIKE 'E%'
/* After this, we will do the last sentence of problem 3 which requires us to sort the result */
ORDER BY VendorContactLName, VendorContactFName
/* You can tell this was done correctly by looking at results 110 & 111, here Kylie Smith was before Sam Smith (if you remove the problem #6 clause) */

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH3.7. "Write a SELECT statement that determines whether the PaymentDate column of the Invoices table has any invalid values. To be valid, PaymnetDate 
must be a null value if there's a balance due and a non-null value if there's no balance due. Code a compound condition in the WHERE clause that tests for these conditions."*/

/*Alright, just like before we need to start off with our FROM and SELECT statements, here * means ALL and we are selecting FROM the Invoices table */
SELECT *
FROM Invoices
/* Next we are going to do our compound condition listed with the WHERE function we are looking to use two different conditions. It tries throwing us off with balance
due, but there is no column named balance due, we can look and see that the Invoice Total column would be the one that makes sense for this condition.*/
WHERE (PaymentDate IS NULL and InvoiceTotal IS NOT NULL) OR (PaymentDate IS NOT NULL and InvoiceTotal IS NULL);

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* CH4.5. "Write a SELECT statement that returns five columns from three tables, all using column aliases (listed in textbook p. 157) AND assign the following
correlation names to the tables AND Sort via listed text" */

/*This is going to be more complicated than it seems. The absolute first thing we are doing is looking at our three tables we will need to JOIN to see what the 
key value that they share. The answer is in Invoices table. It has an InvoiceID key AND a VendorID key which will work with the other two listed tables. */

/*2. Now we are going back to SELECT TO return our column aliases*/
SELECT VendorName AS Vendor, InvoiceDate AS Date, InvoiceNumber AS Number, InvoiceSequence AS #, InvoiceLineItemAmount AS LineItem
/* 1. Our FROM statement, we will assign correlation names using AS and remembering how to use JOIN and ON for combining our tables. We will need to combine 2 tables */
FROM Invoices AS i
/*1a. So, we are using our JOIN & ON for Vendors table using the Vendor ID */	
	JOIN Vendors AS v
	ON i.VendorID = v.VendorID
/*1b. And, we are using our JOIN & ON for InvoiceLineItems table using the Invoice ID */
	JOIN InvoiceLineItems AS li
	ON i.InvoiceID = li.InvoiceID
/*Finally, we are sorting the final results as requested */
ORDER BY Vendor, Date, Number, #;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* CH4.6. "Write a SELECT statement that returns the listed three columns. The result set should have one row for each vendor whose contact has the same first name as 
another vendor's contact. Sort the final result set by Name. (hint use self-join)" Gonna use this to reference p.135*/

/*2. We are doing the SELECT statement as the second half, since we did a self join in the FROM we have to make sure we don't say just VendorID, we have to say what
part of the self join we are pulling from */
SELECT Vendors1.VendorID, Vendors1.VendorName, (Vendors1.VendorContactFName + ' ' + Vendors1.VendorContactLName) AS Name
/*1. We are going to self JOIN the Vendors table, this is to answer the second sentence, gotta work the problem backwards.  */
FROM Vendors AS Vendors1 
		/*1a. So, like in the last problem, we are doing JOIN and ON, only instead of different tables it's the same one*/
		JOIN Vendors AS Vendors2
		/*1b. Then we have to say that the VendorID is not the same, we don't want to repeat the same person */
		ON Vendors1.VendorID <> Vendors2.VendorID AND
		/*1c. And here we want the first name to be the same (like Charlie or Robert)*/
		Vendors1.VendorContactFName = Vendors2.VendorContactFName
/*3. Alright and finally we are sorting the final result set by Name */
ORDER BY Name;

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* CH4.7. "Write a SELECT statement that returns two columns from the GLAccounts table: AccountNo and AccountDescription. The result set should have one row for each account number
that has never been used. Sort the final result set by AccountNo. (hint use outer join to the InvoiceLineItems table)" */

/*2. With our JOIN in FROM we need to specify our AccountNo, we don't need to do that for AccountDescription since it isn't on both tables */
SELECT GLAccounts.AccountNo, AccountDescription
/*1. Not going to ignore the hint to use the outerjoin for InvoiceLineItems table so let's do that first, looking at that table we see that AccountNo is on both of them*/
FROM GLAccounts
	/*1a. Our hint was two fold because it states OUTER join, looking at our options (left, right, full) we want a LEFT for our AccountNo */
	LEFT JOIN InvoiceLineItems
	ON GLAccounts.AccountNo = InvoiceLineItems.AccountNo
/*3. If we ran it right now (without anything below it) We get half way through our problem, we still haven't satisfied the second sentence. We need to use NULL to make sure we are 
	finding all the account numbers that have never been used.*/
WHERE InvoiceLineItems.AccountNo IS NULL 
/* 4. We are finally ordering this and making sure we state which table we are ordering it by, I played with both it doesn't matter which one we do, just need to specify */
ORDER BY InvoiceLineItems.AccountNo;

/* 5. I am using this to verify that the AccountNo's in the former statement are not on this */
SELECT *
FROM InvoiceLineItems
ORDER BY AccountNo

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Please make sure that your are commenting each line of code to explain what your code is accomplishing!!! */
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*
Search for 4 year colleges/universities (ICLEVEL differentiates
four year colleges) in NC with total enrollment of greater 
than 15000.
The query should include the following columns/fields.
1. UNITID (From HD2019) 2. INSTNM (From HD2019)
3. CITY (From HD2019) 4. STABBR (From HD2019)
5. EFYTOTLT (From EFFY2019)
6. Published in state tuition and fees for 2019-20 (IC2019_AY.chg2ay3)
7. Published out of state tuition and fees for 2019-20 (IC2019_AY.chg3ay3)
*/

/*1. We are going to Choose what Database we want to use, in this one we are choosing IPEDS  */
USE [IPEDS 2019-2020]
GO
/*3. It might seem confusing but SELECT is the third part of this, you need to write FROM before you are SELECTing, in this case, we are 
    SELECTing 1-7 and making sure to rename them by the AS function so it is easier to read (as well as the 'c0' for number formatting). */
SELECT HD2019.UNITID AS 'UNIT ID', HD2019.INSTNM AS 'INSTITUTION NAME', HD2019.CITY, HD2019.STABBR AS 'STATE',
FORMAT(EFFY2019.EFYTOTLT, 'N0') AS 'TOTAL STUDENTS', FORMAT(IC2019_AY.CHG2AY3, 'c0') AS 'IN STATE TUITION', FORMAT(IC2019_AY.CHG3AY3, 'c0') AS 'OUT OF STATE TUITION'
/* 2. Second thing we are doing is selecting FROM, then the third part is SELECT */
FROM HD2019
/*4. In order to get #5,6,7 we had to JOIN different tables from the database using a key value, here it is UNITID */
JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
JOIN IC2019_AY ON HD2019.UNITID = IC2019_AY.UNITID
/*5. Finally, we are stipulating the first demand in our problem, a 4 year college in NC with a total enrollment > 15000 */
WHERE EFYTOTLT > 15000 AND STABBR = 'NC' AND ICLEVEL = 1 AND EFFYLEV = 1;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*
Using UNION clause, write a query which searches the total student enrollment (from EFFY2019 use EFFYLEV = 1) for the states of NC, SC,
VA, TN, GA. Please include the following columns: HD2019.UNITID, INSTNM,CITY, STABBR, EFYTOTLT. Order the resulting dataset by INSTNM.
Comment each line of your code.
*/

/* Okay, so we are combining two different statements with a UNION clause (kinda get to that later), so we will need to create the first statement, luckily we did it
already in the last problem so we can copy/paste the information we need */ 
	SELECT HD2019.UNITID AS 'UNIT ID', FORMAT(EFFY2019.EFYTOTLT, 'N0') AS 'TOTAL STUDENTS', INSTNM AS 'INSTITUTION NAME', CITY, STABBR AS 'STATE'
	FROM HD2019
	JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
	/*So here is where we will put our first of two requirements, we want effylev = 1 */
	WHERE EFFYLEV = 1
/*I am a little confused here, the prompt says using the UNION clause, but that will return all results and not allow us to search certain states, we need to
use INTERSECT if we want to arrive at this conclusion, please let me know if I misunderstood the prompt*/
INTERSECT
/* The next statement we want to combine is the several states we want to search for (we only want a few of them) */	
	SELECT HD2019.UNITID AS 'UNIT ID', FORMAT(EFFY2019.EFYTOTLT, 'N0') AS 'TOTAL STUDENTS', INSTNM AS 'INSTITUTION NAME', CITY, STABBR AS 'STATE'
	FROM HD2019
	JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
	/*And this is where we put our second requirements of what state's we want.*/
	WHERE STABBR = 'NC' OR STABBR = 'SC' OR STABBR = 'VA' OR STABBR = 'TN' OR STABBR = 'GA'
/* Finally, Ordering it by Institution Name */
ORDER BY INSTNM;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*
Using AND/OR logic, write a query which searches the total student
enrollment (from EFFY2019 use EFFYLEV = 1) for the states of NC, SC,
VA, TN, GA. Please include the following columns: HD2019.UNITID, 
INSTNM,CITY, STABBR, EFYTOTLT. Order the resulting dataset by INSTNM.
Comment each line of your code.
*/

/* Luckily for us this is the exact same problem only instead of INTERSECT we will be using AND/OR so I'm just gonna copy the previous problem */
SELECT HD2019.UNITID AS 'UNIT ID', FORMAT(EFFY2019.EFYTOTLT, 'N0') AS 'TOTAL STUDENTS', INSTNM AS 'INSTITUTION NAME', CITY, STABBR AS 'STATE'
FROM HD2019
	JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
/*So this is the main change, instead of INTERSECT we but AND for the two seperate WHERE clauses and make SURE THERE are parantheses. IF we don't then
it will pull up results from both tables and options will repeat. */
WHERE (EFFYLEV = 1) AND (STABBR = 'NC' OR STABBR = 'SC' OR STABBR = 'VA' OR STABBR = 'TN' OR STABBR = 'GA')
/* Finally, Ordering it by Institution Name */
ORDER BY INSTNM;