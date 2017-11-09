--USE DimensionalSamples

--GO
--DROP TABLE IF EXISTS Dimensions.Dates;
--GO
--CREATE SCHEMA Dimensions;
--GO

CREATE TABLE Dimensions.Dates(
	  DateId				INT					NOT NULL
		CONSTRAINT PK_Dates PRIMARY KEY 
	, Date					DATE				NOT NULL
	, DateFullName			VARCHAR(15)			NOT NULL
--- Numbers to use as MEASURES. Use a View to create a "FactTable". 
--- They can be use to create averages or trendlines
	, DayNumberOfMonth		INT					NOT NULL
	, DayNumberOfQuarter	INT					NOT NULL
	, DayNumberOfYear		INT					NOT NULL

-- Month
--- Key   : To optimize performance, order attribute, simplify MDX/DAX queries and support multilanguage
--- Name  : To display
--- Full  : Year+Month use for hierarchies, drilldown.
--- Simple: To dice: Year as column, Month as Rows.
--- BeginandEndDate to simplify reports
	, MonthKey				SMALLINT			NOT NULL
	, MonthName				VARCHAR(10)			NOT NULL
	, MonthFullKey			INT					NOT NULL
	, MonthFullName			VARCHAR(15)			NOT NULL
	, MonthNumberOfQuarter	INT					NOT NULL
	, MonthNumberOfYear		INT					NOT NULL
	, MonthDaysInMonth		INT					NOT NULL	
	, MonthBeginDate		VARCHAR(15)			NOT NULL
	, MonthEndDate			VARCHAR(15)			NOT NULL

-- Quarter
	, QuarterKey		SMALLINT			NOT NULL
	, QuarterName		CHAR(2)				NOT NULL
	, QuarterFullKey	INT					NOT NULL
	, QuarterFullName	CHAR(7)				NOT NULL
	, QuarterNumberOfDays			INT NOT NULL
	, QuarterBeginDate	VARCHAR(15)			NOT NULL
	, QuarterEndDate	VARCHAR(15)			NOT NULL

-- Year
	, YearKey			SMALLINT			NOT NULL
	, YearName			VARCHAR(4)			NOT NULL
	, YearNumberOfDays						INT NOT NULL
	, YearBeginDate		VARCHAR(15)			NOT NULL
	, YearEndDate		VARCHAR(15)			NOT NULL

-- Day
	, DayKey				SMALLINT			NOT NULL
	, DayName				VARCHAR(10)			NOT NULL
	
-- Week	
	, WeekKey					SMALLINT			NOT NULL
	, WeekName					CHAR(3)				NOT NULL	
	, WeekFullKey				INT					NOT NULL
	, WeekFullName				CHAR(8)				NOT NULL	
	, WeekBeginDate				VARCHAR(15)			NOT NULL
	, WeekEndDate				VARCHAR(15)			NOT NULL

-- Fiscal
	, FiscalMonthFullName		VARCHAR(20)	NOT NULL
	, FiscalQuarterFullName		VARCHAR(12)	NOT NULL
	, FiscalYearKey				SMALLINT	NOT NULL
	, FiscalYearName			VARCHAR(9)	NOT NULL
	, FiscalYearBeginDate		VARCHAR(15)	NOT NULL
	, FiscalYearEndDate			VARCHAR(15)	NOT NULL

-- Holidays
	, DateTypeKey				SMALLINT		NOT NULL
	, DateTypeName				VARCHAR(12)		NOT NULL
	, HolidayKey				INT				NOT NULL
	, HolidayName				VARCHAR(40)		NOT NULL
	
-- Weather Season
	, WeatherSeasonKey			SMALLINT		NOT NULL
	, WeatherSeasonName			VARCHAR(20)		NOT NULL
	, WeatherSeasonFullKey		INT				NOT NULL
	, WeatherSeasonFullName		VARCHAR(20)		NOT NULL
	, WeatherYearKey			SMALLINT		NOT NULL
	, WeatherYearName			VARCHAR(4)		NOT NULL

-- Business Season
	, BusinessSeasonKey			SMALLINT		NOT NULL
	, BusinessSeasonName		VARCHAR(20)		NOT NULL
	, BusinessSeasonFullKey		INT				NOT NULL
	, BusinessSeasonFullName	VARCHAR(26)		NOT NULL
	, BusinessYearKey			SMALLINT		NOT NULL
	, BusinessYearName			VARCHAR(4)		NOT NULL

);


