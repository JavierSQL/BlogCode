USE DimensionalSamples;
GO
/*
--- Dimension Place Holders
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

*/
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
	, PeriodBalance			DECIMAL(18, 4) NOT NULL		--	AS PeriodDebits-PeriodCredits
-- Semi-additive Measures
	, InitialBalance		DECIMAL(18, 4) NOT NULL
	, FinalBalance			DECIMAL(18, 4) NOT NULL		-- AS InitialBalance+PeriodDebits-PeriodCredits

--- Metadata
	, ETLGuid				CHAR(40) NOT NULL
	--- NO NEED PRIMARY KEY
	--- If you need one use: DateID, AccountID, LedgerID
) ON ByYear (DateID);

CREATE CLUSTERED COLUMNSTORE INDEX IDX_AccountBalances_CS
ON Accounting.AccountBalances
ON ByYear (DateID);

CREATE NONCLUSTERED INDEX  IDX_AccountBalances_Accounts
ON Accounting.AccountBalances (AccountID)
WITH (DATA_COMPRESSION = PAGE)
	ON ByYear (DateID);

CREATE NONCLUSTERED INDEX  IDX_AccountBalances_Ledgers
ON Accounting.AccountBalances (LedgerID)
WITH (DATA_COMPRESSION = PAGE)
	ON ByYear (DateID);


