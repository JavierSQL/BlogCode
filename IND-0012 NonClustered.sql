USE DemoIndexes;
GO
DROP TABLE IF EXISTS  dbo.CountriesNoClust;
CREATE TABLE dbo.CountriesNoClust(
	CountryCode		CHAR(2)			NOT NULL
--      By Default PRIMARY KEYS create Clustered Indexes
		CONSTRAINT PK_CountriesNoClust PRIMARY KEY	
	, CountryName		VARCHAR(50)		NOT NULL
	, CountryISO3		CHAR(3)			NOT NULL
--      By Default UNIQUE CONSTRAINT  create Non-Clustered Indexes
		CONSTRAINT UN_CountriesNoClust UNIQUE
);
-- UNIQUE is Optional but desirerable when possible

CREATE UNIQUE NONCLUSTERED INDEX UN_CountriesNoClust
ON  dbo.CountriesNoClust(CountryCode)

INSERT dbo.CountriesNoClust
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

SELECT * FROM dbo.CountriesNoClust WHERE CountryCode='EC'

SELECT * FROM dbo.CountriesNoClust WHERE CountryISO3='ECU'

--- Agregra CLUSTERED...
