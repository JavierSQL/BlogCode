USE DemoIndexes;
GO
DROP TABLE IF EXISTS  dbo.CountriesColNoCl;
CREATE TABLE dbo.CountriesColNoCl(
	CountryCode		CHAR(2)			NOT NULL
--      By Default PRIMARY KEYS create Clustered Indexes
--		CONSTRAINT PK_CountriesColNoCl PRIMARY KEY	
	, CountryName		VARCHAR(50)		NOT NULL
	, CountryISO3		CHAR(3)			NOT NULL
--      By Default UNIQUE CONSTRAINT  create Non-Clustered Indexes
--		CONSTRAINT UN_CountriesColNoCl UNIQUE
);

-- NONCLUSTERED is the DEFAULT 
CREATE NONCLUSTERED COLUMNSTORE INDEX CC_CountriesColNoCl  
ON dbo.CountriesColNoCl(CountryName, CountryISO3);

INSERT dbo.CountriesColNoCl
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
-- Con tan pocos datos no es posible que use el indice
SELECT * FROM dbo.CountriesColNoCl WHERE CountryISO3='ECU'


/*
---- UNIQUE is Optional but desirerable
CREATE UNIQUE NONCLUSTERED INDEX UN_CountriesColNoCl_CountryISO3
ON  dbo.CountriesColNoCl(CountryISO3)
*/

--- Agregra CLUSTERED...
