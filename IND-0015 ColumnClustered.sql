USE DemoIndexes;
GO
DROP TABLE IF EXISTS  dbo.CountriesColClust;
CREATE TABLE dbo.CountriesColClust(
	CountryCode		CHAR(2)			NOT NULL
--      By Default PRIMARY KEYS create Clustered Indexes
--		CONSTRAINT PK_CountriesColClust PRIMARY KEY	
	, CountryName		VARCHAR(50)		NOT NULL
	, CountryISO3		CHAR(3)			NOT NULL
--      By Default UNIQUE CONSTRAINT  create Non-Clustered Indexes
--		CONSTRAINT UN_CountriesColClust UNIQUE
);

CREATE CLUSTERED COLUMNSTORE INDEX CC_CountriesColClust  
ON dbo.CountriesColClust;


INSERT dbo.CountriesColClust
VALUES('CR', 'Costa Rica', 'CRI')
	,('EC','Ecuador', 'ECU')
	,('ES','Spain', 'ESP')
	,('GT','Guatemala', 'GTM')
	,('HN','Honduras', 'HND')
	,('MX','Mexico', 'MEX')
	,('PE','Peru', 'PER')
	,('SV','El Salvador', 'SLV')
	,('US','United States of America', 'USA');
GO

SELECT * FROM dbo.CountriesColClust WHERE CountryISO3='ECU'


/*
---- UNIQUE is Optional but desirerable
CREATE UNIQUE NONCLUSTERED INDEX UN_CountriesColClust_CountryISO3
ON  dbo.CountriesColClust(CountryISO3)
*/

--- Agregra CLUSTERED...
