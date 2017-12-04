USE DemoIndexes;
GO
DROP TABLE IF EXISTS  dbo.CountriesClust;
CREATE TABLE dbo.CountriesClust(
	CountryCode		CHAR(2)			NOT NULL
--      By Default PRIMARY KEYS create Clustered Indexes
		CONSTRAINT PK_CountriesClust PRIMARY KEY	
	, CountryName		VARCHAR(50)		NOT NULL
	, CountryISO3		CHAR(3)			NOT NULL
--      By Default UNIQUE CONSTRAINT  create Non-Clustered Indexes
		--CONSTRAINT UN_CountriesClust UNIQUE
);
------------------------------------------- 
-- The alternative is to declare the Index
------------------------------------------- 
ALTER TABLE dbo.CountriesClust
	DROP CONSTRAINT PK_CountriesClust
--UNIQUE is Optional but desirerable
CREATE UNIQUE CLUSTERED INDEX UN_CountriesClust
ON  dbo.CountriesClust(CountryCode);


INSERT dbo.CountriesClust
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

SELECT * FROM dbo.CountriesClust WHERE CountryCode='EC'

--SELECT * FROM dbo.CountriesClust WHERE CountryISO3='ECU'

