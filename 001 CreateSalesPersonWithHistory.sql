USE TempTables;
GO
CREATE TABLE Sales.SalesPerson (
	SalesPersonCode			CHAR(4)
		--- PRIMARY KEY Required
		CONSTRAINT PK_SalesPerson PRIMARY KEY,
	FirstName				VARCHAR(20) NOT NULL,
	MiddleName				VARCHAR(50)	NULL,
	LastName				VARCHAR(20) NOT NULL,
		--- Computed columns will be persited in the history table
	FullName AS (CAST(CONCAT(FirstName, ' '
					, COALESCE(MiddleName+' ', '')
					, LastName) AS VARCHAR(125))),
	SalesQuota				NUMERIC(18,4) NULL,
	Bonus					NUMERIC(18,4) NOT NULL,
	CommissionPct			NUMERIC(7,4) NOT NULL,
	--- Both columns must be: DATETIME2, NOT NULL even when NOT Specified
	--- GENERATED ALWAYS AS ROW (START/END)
	Starting				DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL ,
	Ending					DATETIME2 GENERATED ALWAYS AS ROW END   HIDDEN NOT NULL ,
	--- Declare the Period using columns. Period is not a column
	PERIOD					FOR SYSTEM_TIME (Starting, Ending)
) WITH (SYSTEM_VERSIONING=ON (HISTORY_TABLE=Sales.SalesPersonHistory));
------ Naming Alternative: SalesHistory.SalesPerson

--- Populate TABLE
INSERT Sales.SalesPerson
WITH(TABLOCK)
--(SalesPersonCode, FirstName, MiddleName, LastName, SalesQuota, Bonus, CommissionPct)
SELECT UPPER(LEFT(LastName, 4)) AS SalesPersonCode , P.FirstName, P.MiddleName
	, P.LastName, SP.SalesQuota, SP.Bonus, SP.CommissionPct
FROM AdventureWorks2014.Sales.SalesPerson AS SP
JOIN AdventureWorks2014.Person.Person AS P
	ON SP.BusinessEntityID=P.BusinessEntityID;

--- Starting and Ending are Hidden 
SELECT * FROM SALES.SalesPerson
--- Starting and Ending are Visible, History es Empty
SELECT * FROM SALES.SalesPersonHistory


