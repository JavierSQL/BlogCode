USE TempTables;
GO
CREATE TABLE Sales.SalesPerson (
	SalesPersonCode			CHAR(4)
		CONSTRAINT PK_SalesPerson PRIMARY KEY,
	FirstName				VARCHAR(20) NOT NULL,
	MiddleName				VARCHAR(50)	NULL,
	LastName				VARCHAR(20) NOT NULL,
	SalesQuota				NUMERIC(18,4) NULL,
	Bonus					NUMERIC(18,4) NOT NULL,
	CommissionPct			NUMERIC(7,4) NOT NULL
);

INSERT Sales.SalesPerson
WITH(TABLOCK)
(SalesPersonCode, FirstName, MiddleName, LastName, SalesQuota, Bonus, CommissionPct)
SELECT UPPER(LEFT(LastName, 4)) AS SalesPersonCode
, P.FirstName, P.MiddleName, P.LastName, SP.SalesQuota, SP.Bonus, SP.CommissionPct
FROM AdventureWorks2014.Sales.SalesPerson AS SP
JOIN AdventureWorks2014.Person.Person AS P
	ON SP.BusinessEntityID=P.BusinessEntityID
ORDER BY 1;

-- =============================================
-- =============================================
BEGIN TRAN;
--- Add Columns
ALTER TABLE  Sales.SalesPerson
ADD Starting DATETIME2 GENERATED ALWAYS AS ROW START 
				HIDDEN DEFAULT SYSUTCDATETIME(),
	Ending   DATETIME2 GENERATED ALWAYS AS ROW END 
			HIDDEN DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999')
	, PERIOD FOR SYSTEM_TIME (Starting, Ending);
--- Enable System_Versioning
ALTER TABLE Sales.SalesPerson
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE=Sales.SalesPersonHistory));
COMMIT;


--- Starting and Ending are Hidden 
SELECT * FROM SALES.SalesPerson
--- Starting and Ending are Visible, History es Empty
SELECT * FROM SALES.SalesPersonHistory

