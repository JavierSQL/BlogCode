USE DimensionalSamples;
GO
-- CREATE SCHEMA Accounting;

--- Place Holders
CREATE TABLE Accounting.Dates(
	DateId		INT NOT NULL
		PRIMARY KEY
);
CREATE TABLE Accounting.Accounts(
	AccountID		INT NOT NULL
		PRIMARY KEY
);
CREATE TABLE Accounting.Ledgers(
	LedgerID		INT NOT NULL
		PRIMARY KEY
);


DROP TABLE IF EXISTS Accounting.AccountBalances;

CREATE TABLE Accounting.AccountBalances(
--- Context: Dimension FKs
	  DateID					INT NOT NULL
		CONSTRAINT FK_AccountBalances_Dates 
		FOREIGN KEY
		REFERENCES Accounting.Dates (DateID)
	, AccountID					INT NOT NULL
		CONSTRAINT FK_AccountBalances_Accounts
			FOREIGN KEY
			REFERENCES Accounting.Accounts(AccountID)
	, LedgerID					INT NOT NULL
		CONSTRAINT FK_AccountBalances_LedgerID
			FOREIGN KEY
			REFERENCES Accounting.Ledgers(LedgerID)
-- Additive Measures
	, PeriodDebits			DECIMAL(18, 4) NOT NULL
	, PeriodCredits			DECIMAL(18, 4) NOT NULL
	, PeriodBalance			AS PeriodDebits-PeriodCredits
-- Semi-additive Measures
	, InitialBalance		DECIMAL(18, 4) NOT NULL
	, FinalBalance			AS InitialBalance+PeriodDebits-PeriodCredits

--- Metadata
	, ETLGuid				CHAR(40) NOT NULL
	--- NO NEED PRIMARY KEY
	--- If you need one use: DateID, AccountID, LedgerID
);

---- Clustered Index: Evaluate need if Primary Key is added
CREATE CLUSTERED INDEX  IDX_AccountBalances_Clustered
ON Accounting.AccountBalances (DateID)
WITH (DATA_COMPRESSION = PAGE)
	ON ByYear (DateID);




