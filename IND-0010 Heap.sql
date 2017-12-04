USE DemoIndexes;
GO
DROP TABLE IF EXISTS  dbo.CountriesHeap;

CREATE TABLE dbo.CountriesHeap(
	CountryCode		CHAR(2)			NOT NULL
--      By Default PRIMARY KEYS Create Clustered Indexes
		CONSTRAINT PK_CountriesHeap PRIMARY KEY	 NONCLUSTERED
	, CountryName		VARCHAR(50)		NOT NULL
	, CountryISO3		CHAR(3)			NOT NULL
--      By Default UNIQUE CONSTRAINT  Create Non-Clustered Indexes
--		CONSTRAINT UN_CountriesHeap_CountryISO3 UNIQUE
);

INSERT dbo.CountriesHeap
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

--- Opctional: Check the Estimated Execution Plan
SELECT * FROM dbo.CountriesHeap WHERE CountryISO3='GTM'

