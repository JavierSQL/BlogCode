USE TempTables;
GO
ALTER TABLE  Sales.SalesPerson SET (SYSTEM_VERSIONING = OFF);
GO
DROP TABLE IF EXISTS Sales.SalesPerson;
DROP TABLE IF EXISTS Sales.SalesPersonHistory;
GO