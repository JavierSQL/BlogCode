USE DemoIndexes;
GO

DROP TABLE IF EXISTS  dbo.CountriesInMem;

CREATE TABLE dbo.CountriesInMem(
	CountryCode		CHAR(2)			NOT NULL
--      By Default PRIMARY KEYS create Clustered Indexes
--      In Memory tables required NONCLUSTERED PRIMARY KEY
		CONSTRAINT PK_CountriesInMem PRIMARY KEY NONCLUSTERED	
	, CountryName		VARCHAR(50)		NOT NULL
		INDEX ix_UserId NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000)
	, CountryISO3		CHAR(3)			NOT NULL
--      By Default UNIQUE CONSTRAINT  create Non-Clustered Indexes
--		CONSTRAINT UN_CountriesInMem_CountryISO3 UNIQUE
) WITH (MEMORY_OPTIMIZED=ON);

INSERT dbo.CountriesInMem
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


SELECT * FROM dbo.CountriesInMem WHERE CountryISO3='GTM'

