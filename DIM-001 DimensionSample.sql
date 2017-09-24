USE DimensionalSamples;
GO
CREATE SCHEMA Dimensions;
GO
--- ISO 1176-5 Naming Standard: Pascal case, conceptual names.
-- Tables: Plural, columns: singular.
CREATE TABLE Dimensions.Customers(
--- SubrogateKey (Identity)
	CustomerID						INT NOT NULL	IDENTITY(1,1)			
		CONSTRAINT PK_Customers		PRIMARY KEY,
--- Business Key
	CustomerCode					VARCHAR(10)		NOT NULL,

--- Name
	FirstName						VARCHAR(50)		NOT NULL,
	MiddleName						VARCHAR(50)		NOT NULL,
	LastName						VARCHAR(50)		NOT NULL,

--- Demographics
	BirthDate						DATE			NOT NULL,
	MaritalStatus					VARCHAR(20)		NOT NULL,
	Gender							VARCHAR(20)		NOT NULL,
	EmailAddress					VARCHAR(50)		NOT NULL,
	Occupation						VARCHAR(50)		NOT NULL,

--- Address
	AddressLine1					VARCHAR(120)	NOT NULL,
	AddressLine2					VARCHAR(120)	NOT NULL,
	PostalArea						VARCHAR(20)		NOT NULL,
	CityTown						VARCHAR(120)	NOT NULL,

	StateProvinceISOCode			VARCHAR(5)		NOT NULL
--- Use CONSTRAINTs 
		CONSTRAINT CH_Customers_StateProvinceISOCode
			CHECK(StateProvinceISOCode LIKE '[A-Z][A-Z]-[A-Z][A-Z]'),
		--- ISO 3166-2							
--- Denormalized column, no need to have another table.
	StateProvinceName				VARCHAR(120)	NOT NULL,
--- Calculated Column: 
	StateProvinceFullName		
		AS CAST((StateProvinceISOCode+' - '+StateProvinceName) AS VARCHAR(125)),
	CountryISOCode					CHAR(2)			NOT NULL
		CONSTRAINT CH_Customers_CountyISOCode
		CHECK(CountryISOCode LIKE '[A-Z][A-Z]'),
		--- ISO 3166-1 Alpha-2 code
	CountryName						VARCHAR(120)	NOT NULL,
	CountryFullName		
		AS CAST((CountryISOCode+' - '+CountryName) AS VARCHAR(125)),
---- Customer Information
	CreditLimit						NUMERIC(18,4)	NOT NULL,
	CustomerType					VARCHAR(20)		NOT NULL,
	RFMClassification				CHAR(3)			NOT NULL,
---- Add more attributes: WIDE Tables
	
---- Metadata
	DimStart						DATETIME NOT NULL,
	DimEnd							DATETIME NULL,
	LoadGUID						UNIQUEIDENTIFIER NOT NULL,
	LoadHash						BINARY(20) NOT NULL
) ;
GO

--- Optional: Enforce the Business Primary Key for actual rows
CREATE UNIQUE INDEX BPK_Customers
ON Dimensions.Customers(CustomerCode)
INCLUDE (CustomerID, DimEnd)
WHERE DimEnd IS NULL;


