/* Victoria Kincaid */


/*Provide definition and examples of the following terms.
Chapter 5:
	Aggregate function:				Definition - Also known as *column functions* perform a calculation on the values in a set of selected rows, the user must specify the values to be 
									used in the caluclation by coding an expression for the function's argument. In many cases, the espression is just the name of the column.
									Example -	SELECT MAX(StudentName) AS LastStudent 
												FROM Students;

	Summary Query:					Definition - A query that contains one or more aggregate functions is stypically reffered to as a summary query
									Example -	SELECT	MIN(StudentName) AS FirstStudent, 
														MAX(StudentName) AS LastStudent,
														COUNT(StudentName) AS NumberOfStudents
												FROM Students;

Chapter 6:
	Subquery:						Definition - A SELECT statement that's coded within another SQL statement
									Example -	SELECT StudentID, StudentName 
												FROM Students 
												WHERE StudentID > 
												(SELECT AVG(StudentID) FROM Students)
												ORDER BY  StudentName;
	
	Derived Table:					Definition - A subquery that's coded in the FROM clause returns a result set called a derived table. One must assign an alias and from there the 
												derived table can be used within the outer query like any other table.	
									Example -	SELECT DISTINCT VendorName, (SELECT MAX(InvoiceDate) FROM Invoices WHERE Invoices.VendorID = Vendors.VendorID) AS LatestInv
												FROM Vendors
												ORDER BY LatestInv DESC;
												
	Common Table Expression (CTE):	Definition - an expression (typically a SELECT statement) that creates one or more temporary tables that can be used by the following query.
									Example -	WITH StudentsCTE AS
												(
													SELECT StudentID, StudentName, 1 As Rank
													FROM Students
													WHERE TeacherID IS NULL
												UNION ALL
													SELECT Students.StudentID, StudentName, Rank + 1
													FROM Students
														JOIN StudentsCTE ON Students.TeacherID = StudentsCTE.StudentID
												)
												SELECT *
												FROM StudentsCTE
												ORDER BY Rank, StudentID;

*/

-- EXAMPLES USING EXAMPLE DATABASE:
USE Examples
GO
--		Aggregate Function:
SELECT MAX(EmployeeID) AS LastEmployee 
FROM Employees;
--		Summary Query:
SELECT	MIN(CustomerLast) AS FirstCustomer, 
		MAX(CustomerLast) AS LastCustomer,
		COUNT(CustomerLast) AS NumberOfCustomers
FROM Customers;
--		Subquery:
SELECT CustID, CustomerLast, CustomerFirst 
FROM Customers 
WHERE CustID > 
	(SELECT AVG(CustID) FROM Customers)
ORDER BY  CustomerLast;
--		Derived Table:
SELECT DISTINCT VendorName, (SELECT MAX(InvoiceDate) FROM ActiveInvoices WHERE ActiveInvoices.VendorID = Vendors.VendorID) AS LatestInv
FROM Vendors
ORDER BY LatestInv DESC;
--		Common Table Expression (CTE):

WITH EmployeesCTE AS
	(
		SELECT EmployeeID, LastName, FirstName, 1 As Rank
		FROM Employees
		WHERE ManagerID IS NULL
	UNION ALL
		SELECT Employees.EmployeeID, Employees.LastName, Employees.FirstName, Rank + 1
		FROM Employees
		JOIN EmployeesCTE ON Employees.ManagerID = EmployeesCTE.EmployeeID
	)
SELECT *
FROM EmployeesCTE
ORDER BY Rank, EmployeeID;

/* Please make sure that your are commenting each line of code to explain what your code is accomplishing!!! */


-- Setting the database for the questions, previously I was using the Examples database, and later I will be using the Ipeds Database
USE AP
GO

-- FROM HERE ON OUT PLEASE GO IN NUMERICAL ORDER FOR STEP INSTRUCTIONS (1.,2.,3. etc)
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* CH5.2.	"Write a SELECT statement that returns two columns: VendorName and PaymentSum, where PaymentSum is the sum of the PaymentTotal column. Group the result set by VendorName. Return only 10
			rows, corresponding to the 10 vendors who've been paid the most. Hint: Use the TOP clause and join Vendors to Invoices." */

--2. After setting up where we will be selecting from, our SELECT statement wants the TOP 10 rows, our VendorName and a Sum of the Payment Total Column
SELECT TOP 10 VendorName, SUM(Invoices.PaymentTotal) AS PaymentSum
--1. Starting from our FROM clause, we are working with the Vendors and Invoices table, so we are joining the two on the shared VendorID
FROM Vendors JOIN Invoices ON Vendors.VendorID = Invoices.VendorID
--3. Finally, we are grouping the result by VendorName.
GROUP BY VendorName;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/*CH5.3.	"Write a SELECT statement that returns three columns: VendorName, InvoiceCount, and InvoiceSum. InvoiceCount is the count of the number of invoices, and InvoiceSum is the sum of the
			InvoiceTotal column. Group the result set by vendor. Sort the result set so the vendor with the highest number of invoices appears first."*/

--2. Next, we are SELECTing our 3 columns, two of which we have to use aggregate functions
SELECT Vendors.VendorName, COUNT(*) AS InvoiceCount, SUM(InvoiceTotal) AS InvoiceSum
--1. So, we start with FROM, it's the same as the last problem 
FROM Vendors JOIN Invoices ON Vendors.VendorID = Invoices.VendorID
--3. Then, we are grouping and ordering by as requested in the last two statements.
GROUP BY VendorName
ORDER BY InvoiceCount DESC;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH5.4.	"Write a SELECT statement that returns three columns: AccountDescription, LineItemCount, and LineItemSum. LineItemCount is the number of entries in the InvoiceLineItems table that have 
			that AccountNo.  LineItemSum is the sum of the InvoiceLineItemAmount column for that AccountNo. Filter the result set to include only those rows with LineItemCount greater than 1. Group 
			the result set by account description, and sort it by descending LineItemCount. Hint: Join the GLAccounts table to the InvoiceLineItems table."*/

--2. Similarly to the last problem we are SELECTing 3 columns, two of which are aggregate functions
SELECT AccountDescription, COUNT(*) AS LineItemCount, SUM(InvoiceLineItemAmount) AS LineItemSum
--1. Similarly to the last two problems, we are joining two tables in order to Select different values from different tables.
FROM GLAccounts JOIN InvoiceLineItems ON GLAccounts.AccountNo = InvoiceLineItems.AccountNo
--3. Again, we are grouping and ordering as requested, the only wrinkle here is the HAVING statement I actually tried to use the WHERE clause at first but realized HAVING was what would work best.
GROUP BY AccountDescription HAVING COUNT(*) > 1
ORDER BY LineItemCount DESC;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH6.5.	"Write a SELECT statement that returns four columns: VendorName, InvoiceID, InvoiceSequence, and InvoiceLineItemAmount for each invoice that has more than one line item in the 
			InvoiceLineItems table. Hint: Use a subquery that tests for InvoiceSequence > 1.*/

-- 2. From here, I am pulling my SELECT statement, to choose what I need to pull 
SELECT VendorName, InvoiceID, InvoiceSequence, InvoiceLineItemAmount
-- 1. So first, I will need to see which two tables I am JOINing, this one is the Vendor table and the InvoiceLineItems table
FROM Vendors JOIN InvoiceLineItems ON Vendors.DefaultAccountNo = InvoiceLineItems.AccountNo
-- 3. And finally my subquery is here stipulating I needed more than one line item in the InvoiceLineItems table
WHERE InvoiceSequence > 1;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH6.6.	"Write a SELECT statement that returns a single value that represents the sum of the largest unpaid invoices submitted by each vendor. Use a derived table that returns MAX(InvoiceTotal)
			grouped by VendorID, filtering for invoices with a balance due."*/
-- I would first like to state I struggled with this and I don't know if this is correct or not, I utilized page 201, but I still don't know if this is the right answer.

-- 7. Finally we are SELECTing a single value that represents the *SUM* of the largest unpaid invoices submitted by each vendor. One single value.
SELECT SUM(InvoiceTotal) AS SumofLargestUnpaidInvoices
-- 1. We are Joining two tables, one of which is a derived table which we will be creating, the other one is Invoices
FROM Invoices JOIN
-- 2. So we JOIN Invoices on our derived table, we want this derived table to return the MAX(InvoiceTotal)
	(SELECT VendorID, MAX(InvoiceTotal) AS MaxInvTotal
-- 3. In the derived table we are selecting from the same Invoices table
	FROM Invoices
-- 4. We are setting our clause of filtering for invoices with a balance due
	WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0
-- 5. And grouping it by the VendorID, We also need to set up a name for our table
	GROUP BY VendorID) AS Blah
-- 6. Here is where we JOIN our two tables on the VendorID
	ON Invoices.VendorID = Blah.VendorID;


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH6.7.	"Write a SELECT statement that returns the name, city, and state of each vendor that's located in a unique city and state. In other words, don't include vendors that have a city and state
			in common with another vendor."*/
-- I also threw myself off with this because I convinced myself I would need to join tables, but nope! This one only needs a subquery and the NOT statement

-- 3. Finally, we are SELECTing our name, city, and state. What's interesting is the word DISTINCT, I took it out and left it in and it results in 38 responses, but they are organized differently, any reason why that is?
Select DISTINCT VendorName, VendorCity, VendorState
-- 1. First we are setting up our FROM Vendors Table
FROM Vendors
-- 2. Up next our subquery, here we are SELECTING our VendorCity and VendorState, I had to research because I tried doing it as
-- "WHERE VendorCity AND VendorState" but it returned an error about aggregate functions only having one result, so I had to Concatenate the two and that was peachy keen
WHERE VendorCity + VendorState
    IN
-- Again, I had to use the + because I received the error "Only one expression can be specified in the select list when the subquery is not introduced with EXISTS." It's interesting this appears in the subquery clause
-- But I am glad I don't have to do different WHERE clauses to stipulate and I can use the + symbol
   (SELECT VendorCity + VendorState
    FROM   Vendors
-- Notice here, no issues with the comma, but that's because at this point we are GROUPing and not SELECTing
    GROUP BY VendorCity, VendorState
-- Finally, the most important bit, we want our vendors to have unique city and state! So that would be only 1, here I put it as less than 2, now we can go back to our SELECT statement
    HAVING COUNT(*) < 2 );


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH7.4.	"Write an UPDATE statement that modifies the VendorCopy table. Change the default account number to 403 for each vendor that has a default account number of 400."*/


--1. First, we need to create the VendorCopy table, This we do by selecting all from vendors into a new table named VendorCopy
SELECT *
INTO VendorCopy
FROM Vendors;

--2. From here we are going to write an UPDATE statement that modifies this VendorCopy table we just made. We use SET to SET the Default Account No. from 400 to 403
UPDATE VendorCopy
SET DefaultAccountNo = 403
WHERE DefaultAccountNo = 400;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH7.5.	"Write an UPDATE statement that modifies the InvoiceCopy table. Change the PaymentDate to today's date and the PaymentTotal to the balance due for each invoice with a balance due. Set
			today's date with a literal date string, or use the GETDATE() function."*/

-- 1. Again, the first thing we need to do is create the InvoiceCopy table, just like we did for VendorCopy, you will need to hit refresh to see it
SELECT *
INTO InvoiceCopy
FROM Invoices;

-- 2. The next part makes it pretty easy for us, we are updating the InvoiceCopy where the PaymentDate is the current date. Luckily, the text tells us to use the GETDATE() function.
UPDATE InvoiceCopy
SET PaymentDate = GETDATE()

-- 3. I was a little confused with what it was asking for the last part here: "and the PaymentTotal to the balance due for each invoice with a balance due."  I *believe* it wants to only have the active
-- balances showing so that is what I will update it to.

--UPDATE InvoiceCopy
--SET PaymentTotal = InvoiceTotal WHERE (InvoiceTotal > 0)
-- Haha I goofed everything up here this just made them equal each other not what I wanted and had to delete the copy table and redo

-- 3. (continued) I was going off page 229, I fear I am overthinking this, Here we have SET the payment total to be the balance due for each invoice with a balance due.
UPDATE InvoiceCopy
SET PaymentTotal = InvoiceTotal - CreditTotal
WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0;


/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*CH7.6.	"Write an UPDATE statement that modifies the InvoiceCopy table. Change TermsID to 2 for each invoice that's from a vendor with a DefaultTermsId of 2. Use a subquery."*/

-- Okay so we can see this is an UPDATE that also requires a JOIN clause with the Vendor table, I am referencing p.229 in the textbook

-- 2. Finally, we want to do our UPDATE where we SET our TermsID to 2 to match
UPDATE InvoiceCopy
SET TermsID = 2
-- 1. First thing, let's set up our FROM clause and set up the JOIN statement
FROM InvoiceCopy JOIN VendorCopy ON InvoiceCopy.VendorID = VendorCopy.VendorID
-- 2. Next, we want to set up our subquery where we want the DefaultTermsID = 2
WHERE DefaultTermsID = 2;



/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Please make sure that your are commenting each line of code to explain what your code is accomplishing!!! */
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Write a query which finds the UNITID, INSTNM, CITY, STABBR, TUITION2 (from IC2019_AY) for a college with name LIKE(SQL operator) Pembroke. */

-- Setting up the Ipeds Database
USE [IPEDS 2019-2020]
GO

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Write a query which finds the UNITID, INSTNM, CITY, STABBR, HBCU, TRIBAL, MIN(TUITION2) (from IC2019_AY) for the college(s) in NC. */

-- 3. We are SELECTing our required items, making note to specify that UNITID is from the HD2019 table.
SELECT HD2019.UNITID, INSTNM, CITY, STABBR, HBCU, TRIBAL, MIN(TUITION2) AS MinimumTuition
-- 1. Our FROM statement needs to JOIN the HD2109 table with the IC2019 on the UNITID
FROM HD2019 JOIN IC2019_AY ON HD2019.UNITID = IC2019_AY.UNITID
-- 2. We need to specify we are only looking for NC
WHERE STABBR = 'NC'
-- 4. Now, in order to avoid seeing the error appear "is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause" I need to include everything in 
-- my SELECT statement that istn't an aggregate (which would be MIN(Tuition2)) into the GROUP BY clause 
GROUP BY HD2019.UNITID, INSTNM, CITY, STABBR, HBCU, TRIBAL;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Write a query which finds us the UNITID, INSTNM, CITY, STABBR of the college/university with the largest total enrollment of students in NC. */

-- 3. We are setting up our SELECT statement selecting what we want, including the EFYTOTLT to get us the largest total enrollment
SELECT HD2019.UNITID, INSTNM, CITY, STABBR, EFYTOTLT
-- 1. Joining the two requried tables, HD2019 and EFFY2109
FROM HD2019 JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
-- 2. Setting up our subquery
WHERE EFYTOTLT=(
-- 2a. To find the largest total enrollment we will be using the MAX() aggregate function
SELECT MAX(EFYTOTLT)
-- 2b. We will need to join tables again in this subquery
FROM HD2019 JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
-- 2c. In order to set our STABBR
WHERE STABBR = 'NC');

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Write a query which finds us the average cost of attending college/university in NC. */

-- 3. > us being able to select CHG2AY3 and CHG3AY3 from the IC2019_AY table. We use the AVG() aggregate function to get answers for both in state and out of state tuition.
SELECT AVG(CHG2AY3) AS 'AVERAGE IN STATE NC TUITION', AVG(CHG3AY3) AS 'AVERAGE OUT OF STATE NC TUITION'
-- 1. We are joining our two tables this is due to >
FROM HD2019 JOIN IC2019_AY ON HD2019.UNITID = IC2019_AY.UNITID
-- 2. > us needing to set our STABBR in HD2019 for NC only and >
WHERE STABBR = 'NC'

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Find total enrollment (in table EFFY2019 use column EFYTOTLT in each of the community colleges of NC and insert this data into a new table called NCCommunityCollegesEnrollment. The table 
should include: UNITID, INSTNM, TotalEnrollment. */

-- 3. These are the items we are SELECTing, We must specify UNITID from HD2019, we use DISTINCT to not get duplicates
SELECT DISTINCT HD2019.UNITID, INSTNM, EFYTOTLT AS "TotalEnrollment"
-- 1. We are making a new table
INTO NCCommunityCollegesEnrollment
-- 2. This table requires information from two other tables so they must be JOINed
FROM HD2019 JOIN EFFY2019 ON HD2019.UNITID = EFFY2019.UNITID
-- 4. We set our specifications for community colleges in NC
WHERE STABBR = 'NC' AND ICLEVEL = 2;