USE DimensionalSamples
GO

;WITH MajorFixedHolidays AS  (
--- Holidays that are set in a specific date of the year
--- HolidayDate is Month*100+Day: 101 is First of January and 1225 Christmas
	-- USA
	SELECT *
	FROM (VALUES('New Year’s Day', 101)
			    ,('Independence Day', 704)
			    ,('Christmas Day',1225)) AS A(HolidayName, HolidayDate)
	/*   
	-- Germany    
	SELECT *
	FROM (VALUES('New Year''s Day',  101)
		, ('Labour Day',  501)
		, ('German Unity Day', 1003)
		, ('Christmas Day', 1225)) AS A(HolidayName, HolidayDate) 

		-- El Salvador
	SELECT *
	FROM (VALUES('Año Nuevo'						, 101)
				, ('Día del Trabajo'				, 501)
				, ('Día del Padre'					, 617)
				, ( 'Fiestas Agostinas-4'			, 804)
				, ( 'Fiestas Agostinas-5'			, 805)
				, ( 'Fiestas Agostinas-6'			, 806)
				, ( 'Día de la independencia'		, 915)
				, ( 'Día de los difuntos'			, 1102)
				, ( 'Navidad'						, 1225)) A(HolidayName, HolidayDate)
	*/				
)
--- Holidays that are set in a specific day of week of Month
--- HolidayKey is only for ordering, Key based on 2010
, MajorMovableHolidays AS (
--- USA
	SELECT *
	FROM (VALUES	
      ('Birthday of Martin Luther King, Jr.',  3, 2,  1, 118)	--  3rd Monday of January each year
    , ('Washington’s Birthday'				,  3, 2,  2, 215)	--  3rd Monday of February
    , ('Memorial Day'						, -1, 2,  5, 531)	--  Last Monday of May (May 31 in 2010)
    , ('Labor Day'							,  1, 2,  9, 906)	--  First Monday in September 
    , ('Columbus Day'						,  2, 2, 10, 1011)  --  Second Monday of October
    , ('Veterans Day'						,  4, 5, 11, 1125)	--  Fourth Thursday in November
		) AS A(HolidayName, Week, Day, Month, HolidayKey)	

/* 
	--- Empty:
		-- Germany    
		-- El Salvador
	SELECT *
	FROM (VALUES	
      ('Birthday of Martin Luther King, Jr.',  3, 2,  1, 118)	--  3rd Monday of January each year
		) AS A(HolidayName, Week, Day, Month, HolidayKey)	
	WHERE 1=0
*/
)
, MayorEasterRelatedHolidays(HolidayName, days, HolidayKey)  
AS (
	SELECT *
	FROM (VALUES ('Easter,'		,  0, 404)) AS A(HolidayName, days, HolidayKey)  	
/*
--- Germany
	SELECT *
	FROM (VALUES ('Good Friday'		, -2, 402	)			-- Keys taken 2010
			   , ('Easter'			,  0, 404)
			  , ('Easter Monday'	,  1, 405)
	) AS A(HolidayName, days, HolidayKey)  	

	-- El Salvador
	SELECT *
	FROM (VALUES ( 'Jueves Santo'	, -3, 401	)			-- Keys taken 2010
	, ( 'Viernes Santo'				, -2, 402	)			-- Keys taken 2010
	, ( 'Domingo de Pascua,'		,  0, 404)) AS A(HolidayName, days, HolidayKey)  	
*/
)
, WeatherSeason(WeatherSeasonKey, WeatherStartDay, WeatherEndDay, WeatherSeasonName)
AS (
	SELECT 1,  101, 321,  'Invierno'	UNION ALL
	SELECT 2,  322, 621,  'Primavera'	UNION ALL
	SELECT 3,  622, 923,  'Verano'	UNION ALL
	SELECT 4,  924, 1221, 'Otoño' UNION ALL
	SELECT 5, 1222, 1231, 'Invierno'
), 
Dates AS(
	SELECT CAST('19800101' AS DATE) AS Date
	UNION ALL
	SELECT DATEADD(Day, 1, Date) FROM Dates
	WHERE Date<'20201231')
INSERT Dimensions.Dates(DateId, Date, DateFullName, DayNumberOfMonth, DayNumberOfQuarter, DayNumberOfYear, MonthKey, MonthName, MonthFullKey, MonthFullName, MonthNumberOfQuarter, MonthNumberOfYear, MonthDaysInMonth, MonthBeginDate, MonthEndDate, QuarterKey, QuarterName, QuarterFullKey, QuarterFullName, QuarterNumberOfDays, QuarterBeginDate, QuarterEndDate, YearKey, YearName, YearNumberOfDays, YearBeginDate, YearEndDate
	, DayKey, DayName, WeekKey, WeekName, WeekFullKey, WeekFullName, WeekBeginDate, WeekEndDate, FiscalMonthFullName, FiscalQuarterFullName, FiscalYearKey, FiscalYearName, FiscalYearBeginDate, FiscalYearEndDate
	, DateTypeKey, DateTypeName, HolidayKey, HolidayName, WeatherSeasonKey, WeatherSeasonName, WeatherSeasonFullKey, WeatherSeasonFullName, WeatherYearKey, WeatherYearName
	, BusinessSeasonKey, BusinessSeasonName, BusinessSeasonFullKey, BusinessSeasonFullName, BusinessYearKey, BusinessYearName
)

SELECT 
	  D.DateId
	, Date
	, CONVERT(VARCHAR(100), DATE, 106) AS DateFullName
	, DATEPART(Day, Date)										AS DayNumberOfMonth
	, 1+DATEDIFF(day, FQ.FirstDayOf, Date)	AS DayNumberOfQuarter
	, 1+DATEDIFF(day, FY.FirstDayOf, Date)	AS DayNumberOfYear
  
-- Month	
	, DATEPART(Month, Date) AS MonthKey
	, DATENAME(MONTH, DATE) AS MonthName
	, YEAR(DATE)*10000 +MONTH(DATE)*100 +1		AS MonthFullKey
	, DATENAME(MONTH, DATE)+'-'+CAST(YEAR(DATE) AS VARCHAR(4)) AS MonthFullName
	, CASE WHEN DATEPART(Month, Date)%3=0 THEN 3 ELSE DATEPART(Month, Date)%3 END AS MonthNumberOfQuarter
	, DATEPART(Month, Date) AS MonthNumberOfYear
	, DATEPART(Day, LM.LastDayOf) AS MonthDaysInMonth
	, CONVERT(VARCHAR(15), FM.FirstDayOf, 106) AS MonthBeginDate
	, CONVERT(VARCHAR(15), LM.LastDayOf, 106) AS MonthEndDate


-- Quarter
	, DATEPART(QUARTER, Date) AS QuarterKey
	, 'Q'+CAST(DATEPART(QUARTER, Date) AS VARCHAR(2)) AS QuarterName
	, YEAR(DATE)*10000
		+  ((DATEPART(QUARTER, Date)-1)*3+1) *100 
		+  1 AS QuarterFullKey
	, 'Q'+CAST(DATEPART(QUARTER, Date) AS VARCHAR(2))
		+'-'+CAST(YEAR(Date) AS CHAR(4))		AS QuarterFullName
	, 1+DATEDIFF(DAY, FQ.FirstDayOf, LQ.LastDayOf) AS  QuarterNumberOfDays			
	, CONVERT(VARCHAR(15), FQ.FirstDayOf , 106) AS QuarterBeginDate
	, CONVERT(VARCHAR(15), LQ.LastDayOf, 106) AS QuarterEndDate


-- Year
	, YEAR(Date) AS YearKey		
	, CAST(YEAR(DATE) AS CHAR(4)) AS YearName
	, 1+DATEDIFF(DAY, FY.FirstDayOf, LY.LastDayOf) AS  YearNumberOfDays			
	, CONVERT(VARCHAR(15), FY.FirstDayOf , 106) AS YearBeginDate
	, CONVERT(VARCHAR(15), LY.LastDayOf  , 106) AS YearEndDate
-- Day
	, DATEPART(WEEKDAY, DATE) AS DayKey
	, DATENAME(WEEKDAY, DATE) AS DayName
	
-- Week
	, DATEPART(Week, Date) AS WeekKey
	, 'W'+RIGHT('0'+CAST(DATEPART(Week, Date) AS VARCHAR(2)), 2) AS WeekName

    , CASE WHEN FW.DateId>YEAR(Date)*10000+101 THEN 	FW.DateId
           ELSE YEAR(Date)*10000+101 END AS WeekFullKey 
        
	, 'W'+RIGHT('0'+CAST(DATEPART(Week,date) AS VARCHAR(2)),2)+ '-'+ CAST(YEAR(Date) AS CHAR(4)) AS WeekFullName
	, CONVERT(VARCHAR(15), DATEADD(DAY, 1-DATEPART(WeekDay, Date), DATE), 106) AS WeekBeginDate
	, CONVERT(VARCHAR(15), DATEADD(DAY, 8-DATEPART(WeekDay, Date), DATE), 106) AS WeekEndDate

	-- Shares Key with MonthFullName
	, DATENAME(MONTH, Date)+'-'
		+ CASE WHEN MONTH(Date)>6  THEN 
			CAST(YEAR(DATE) AS VARCHAR(4)) + '/'+ CAST(YEAR(DATE)+1 AS VARCHAR(4)) 
			ELSE CAST(YEAR(DATE)-1 AS VARCHAR(4)) + '/'+ CAST(YEAR(DATE) AS VARCHAR(4)) 
			END AS FiscalMonthFullName


	-- Shares Key with QuarterFullName
	, 'Q'+ CASE WHEN MONTH(Date)<4  THEN '3-' +CAST(YEAR(DATE)-1 AS VARCHAR(4)) + '/'+ CAST(YEAR(DATE) AS VARCHAR(4))
				WHEN MONTH(Date)<7  THEN '4-' +CAST(YEAR(DATE)-1 AS VARCHAR(4)) + '/'+ CAST(YEAR(DATE) AS VARCHAR(4))
				WHEN MONTH(Date)<10 THEN '1-' +CAST(YEAR(DATE) AS VARCHAR(4)) + '/'+ CAST(YEAR(DATE)+1 AS VARCHAR(4))
				ELSE '2-'+CAST(YEAR(DATE) AS VARCHAR(4)) + '/'+ CAST(YEAR(DATE)+1 AS VARCHAR(4))
				END AS FiscalQuarterFullName
	, CASE WHEN MONTH(Date)>6  THEN YEAR(DATE)+1 	ELSE YEAR(DATE)
			END AS FiscalYearKey	
	, CASE WHEN MONTH(Date)>6  THEN 
			CAST(YEAR(DATE) AS VARCHAR(4)) + '/'+ CAST(YEAR(DATE)+1 AS VARCHAR(4)) 
			ELSE CAST(YEAR(DATE)-1 AS VARCHAR(4)) + '/'+ CAST(YEAR(DATE) AS VARCHAR(4)) 
			END AS FiscalYear			
	,  CASE WHEN MONTH(Date)>6  THEN CONVERT(VARCHAR(15), (SELECT Date FROM dbo.KeyToDate(YEAR(Date)*10000+701)), 106)
		ELSE CONVERT(VARCHAR(15), (SELECT DATE FROM dbo.KeyToDate((YEAR(Date)-1)*10000+701)),106)
			END AS FiscalYearBeginDate		
	,  CASE WHEN MONTH(Date)>6  THEN CONVERT(VARCHAR(15), 
			(SELECT DATE FROM dbo.KeyToDate((YEAR(Date)+1)*10000+630)),106)
		ELSE CONVERT(VARCHAR(15), 
			(SELECT DATE FROM dbo.KeyToDate((YEAR(Date))*10000+630)),106) END AS FiscalYearBeginDate		

-- VERSION 300			
--	DateType
	, CASE 	WHEN COALESCE(MayorEasterRelatedHolidays.HolidayName
					, MajorFixedHolidays.HolidayName
					, MajorMovableHolidays.HolidayName) IS NOT NULL THEN 3
		WHEN DATEPART(Weekday, Date) IN (7,1) THEN 2
		ELSE 1 END AS  DateTypeKey		
	, CASE 	WHEN COALESCE(MayorEasterRelatedHolidays.HolidayName
					, MajorFixedHolidays.HolidayName
					, MajorMovableHolidays.HolidayName) IS NOT NULL THEN 'Holiday'
		WHEN DATEPART(Weekday, Date) IN (7,1) THEN 'Weekend' 
		ELSE 'Business Day' END AS  DateTypeName

	, COALESCE(MayorEasterRelatedHolidays.HolidayKey
					, MajorFixedHolidays.HolidayDate
					, MajorMovableHolidays.HolidayKey
					, 1) AS HolidayKey

	, COALESCE(MayorEasterRelatedHolidays.HolidayName
					, MajorFixedHolidays.HolidayName
					, MajorMovableHolidays.HolidayName
					, 'No Holiday') AS HolidayName

-- Weather Season
     , WeatherSeason.WeatherSeasonKey%4 AS WeatherSeasonKey
     , WeatherSeasonName
     
     , CASE WHEN WeatherSeason.WeatherSeasonKey=1 THEN (YEAR(DATE)-1)*10000+1222
        ELSE YEAR(DATE)*10000+WeatherSeason.WeatherStartDay END AS WeatherSeasonFullKey
     , WeatherSeason.WeatherSeasonName+'-'+
		CASE WHEN  WeatherSeason.WeatherSeasonKey=5
		THEN CAST(YEAR(DATE)+1 AS VARCHAR(4))
		ELSE  CAST(YEAR(DATE) AS VARCHAR(4)) END AS WeatherSeasonFullName 
	, CASE WHEN WeatherSeason.WeatherSeasonKey=5 THEN (YEAR(DATE)+1)
		ELSE YEAR(DATE) END AS WeatherYearKey
	, CAST(CASE WHEN WeatherSeason.WeatherSeasonKey=5 THEN (YEAR(DATE)+1)
		    ELSE YEAR(DATE) END AS CHAR(4)) AS WeatherYearName		


-- Business Season
	, CASE WHEN D.DateId%10000 BETWEEN 1201 AND 1226			THEN 9	-- Christmas Season
		   WHEN D.DateId%10000> 1226 OR D.DateId %10000<118		THEN 3	-- Winter Clearance
		   WHEN D.DateId%10000 BETWEEN 715 AND 0908				THEN 4	-- Back to School
		   WHEN DATEPART(WEEKDAY, 
			(SELECT Date FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))>5			-- First Day of November Friday or Saturday
			 AND DATEADD(DAY, 1,												-- Black Friday
				 DATEADD(WEEK, 3,												-- Four Thurdsday of November 
				 DATEADD(DAY													-- First Thurdsday of November 
		                    , 7+5-DATEPART(WEEKDAY
								, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))
		                    , (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))))=Date		   THEN 5	-- Black Friday
		   WHEN DATEPART(WEEKDAY, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))<=5			
									-- First Day of November Sunday to Thursday
			AND  DATEADD(DAY, 1,													-- Black Friday
				 DATEADD(WEEK, 3,													-- Four Thurdsday of November 
				 DATEADD(DAY														-- First Thurdsday of November 
		                    , 5-DATEPART(WEEKDAY
								, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))
			                    , (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101) ) )))=Date	   THEN 8   --  Black Friday
   		   WHEN  D.DateId %10000 BETWEEN 118  AND 714 THEN 1
		   ELSE 2  
		   END AS BusinessSeasonKey

	, CASE WHEN D.DateId %10000 BETWEEN 1201 AND 1226 THEN 'Christmas Season' 
		   WHEN D.DateId %10000> 1226  
			 OR D.DateId %10000< 118 THEN 'Winter Clearance' 
		   WHEN D.DateId %10000 BETWEEN 715 AND 0908 THEN 'Back to School' 
		   WHEN DATEPART(WEEKDAY
				, (SELECT Date FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))>5			-- First Day of November Friday or Saturday
			 AND DATEADD(DAY, 1,													-- Black Friday
				 DATEADD(WEEK, 3,													-- Four Thurdsday of November 
				 DATEADD(DAY														-- First Thurdsday of November 
		                    , 7+5-DATEPART(WEEKDAY
							, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))
		                    , (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))))=Date
		         THEN 'Black Friday'
		   WHEN DATEPART(WEEKDAY
			, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))<=5			
					-- First Day of November Sunday to Thursday
			AND  DATEADD(DAY, 1,													-- Black Friday
				 DATEADD(WEEK, 3,													-- Four Thurdsday of November 
				 DATEADD(DAY														-- First Thurdsday of November 
		                    , 5-DATEPART(WEEKDAY
								, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))
								, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))))=Date
		          THEN 'Black Friday'
		   WHEN  D.DateId %10000 BETWEEN 118  AND 714 THEN 'Regular 1'
		   ELSE 'Regular 2'
		   END AS BusinessSeasonName

	, CASE WHEN D.DateId % 10000 BETWEEN 1201 AND 1226				   THEN YEAR(DATE)*10000+1201     -- Christmas Season
		   WHEN D.DateId % 10000> 1226								   THEN YEAR(DATE)*10000+1226
		   WHEN D.DateId % 10000<118 									   THEN (YEAR(DATE)-1)*10000+1226 -- Winter Clearance
		   WHEN D.DateId % 10000 BETWEEN 715 AND 0908					   THEN YEAR(DATE)*10000+715      -- Back to School
		   WHEN DATEPART(WEEKDAY
			, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))>5			-- First Day of November Friday or Saturday
			 AND DATEADD(DAY, 1,													-- Black Friday
				 DATEADD(WEEK, 3,													-- Four Thurdsday of November 
				 DATEADD(DAY														-- First Thurdsday of November 
		                    , 7+5-DATEPART(WEEKDAY
								, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))
		                    , (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))))=Date
											THEN YEAR(DATE)*10000+1130	 -- Black Friday
		   WHEN DATEPART(WEEKDAY, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))<=5			-- First Day of November Sunday to Thursday
			AND  DATEADD(DAY, 1,													-- Black Friday
				 DATEADD(WEEK, 3,													-- Four Thurdsday of November 
				 DATEADD(DAY														-- First Thurdsday of November 
		                    , 5-DATEPART(WEEKDAY
								, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))
		                    , (SELECT DATE FROM  dbo.KeyToDate(YEAR(Date)*10000+1101)))))=Date	   
								THEN YEAR(DATE)*10000+1130	 -- Black Friday
		   WHEN  D.DateId %10000 BETWEEN 118  AND 714 THEN YEAR(DATE)*10000+118
		   ELSE  YEAR(DATE)*10000+909  -- Regular
		   END AS BusinessSeasonFullKey

	, CASE WHEN D.DateId %10000 BETWEEN 1201 AND 1226 THEN 'Christmas Season' +'-' +CAST(YEAR(Date) AS VARCHAR(4))
		   WHEN D.DateId %10000> 1226 THEN  'Winter Clearance' + '-' +CAST(YEAR(Date)+1 AS VARCHAR(4))
		   WHEN D.DateId %10000<  118 THEN 'Winter Clearance' + '-' +CAST(YEAR(Date) AS VARCHAR(4))
		   WHEN D.DateId %10000 BETWEEN 715 AND 0908 THEN 'Back to School' + '-' +CAST(YEAR(Date) AS VARCHAR(4))

		   WHEN DATEPART(WEEKDAY, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))>5			-- First Day of November Friday or Saturday
			 AND DATEADD(DAY, 1,													-- Black Friday
				 DATEADD(WEEK, 3,													-- Four Thurdsday of November 
				 DATEADD(DAY														-- First Thurdsday of November 
		                    , 7+5-DATEPART(WEEKDAY
							, (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))
		                    , (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))))=Date
		         THEN 'Black Friday' + '-' +CAST(YEAR(Date) AS VARCHAR(4))
		   WHEN DATEPART(WEEKDAY, 
			(SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))<=5			-- First Day of November Sunday to Thursday
			AND  DATEADD(DAY, 1,													-- Black Friday
				 DATEADD(WEEK, 3,													-- Four Thurdsday of November 
				 DATEADD(DAY														-- First Thurdsday of November 
		                    , 5-DATEPART(WEEKDAY, 
								(SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))
		                    , (SELECT DATE FROM dbo.KeyToDate(YEAR(Date)*10000+1101)))))=Date
		          THEN 'Black Friday'+ '-' +CAST(YEAR(Date) AS VARCHAR(4))
		   WHEN  (SELECT DateId FROM dbo.DateToKey(Date)) %10000 BETWEEN 118  AND 714 
			THEN 'Regular Season 1 -'+CAST(YEAR(Date) AS VARCHAR(4))
			ELSE 'Regular Season 2 -' +CAST(YEAR(Date) AS VARCHAR(4))
		   END AS BusinessFullSeasonName
	
      
	, CASE WHEN D.DateID %10000> 1226  THEN (YEAR(DATE)+1)
		ELSE YEAR(DATE) END AS BusinessYearKey
	, CAST(CASE WHEN D.DateId %10000> 1226 THEN (YEAR(DATE)+1)
		ELSE YEAR(DATE) END AS CHAR(4)) AS BusinessYearName		

FROM Dates 
CROSS APPLY (SELECT DateId FROM dbo.DateToKey(DATE)) AS D
CROSS APPLY (SELECT FirstDayOf FROM dbo.FirstDayOf(DATE, 'Month')) AS FM
CROSS APPLY (SELECT LastDayOf FROM dbo.LastDayOf(DATE, 'Month'))   AS LM
CROSS APPLY (SELECT FirstDayOf FROM dbo.FirstDayOf(DATE, 'Quarter')) AS FQ
CROSS APPLY (SELECT LastDayOf FROM dbo.LastDayOf(DATE, 'Quarter'))   AS LQ
CROSS APPLY (SELECT FirstDayOf FROM dbo.FirstDayOf(DATE, 'Year')) AS FY
CROSS APPLY (SELECT LastDayOf FROM dbo.LastDayOf(DATE, 'Year'))   AS LY
CROSS APPLY (SELECT DateID FROM dbo.DateToKey(DATEADD(DAY, 1-DATEPART(Weekday, Date), Date))) AS FW

LEFT JOIN MajorFixedHolidays
ON d.DateId%10000=MajorFixedHolidays.HolidayDate
LEFT JOIN MajorMovableHolidays
ON	(MajorMovableHolidays.Week>0
		AND MONTH(Date)=MajorMovableHolidays.Month					
		AND DATEADD(Week
			, MajorMovableHolidays.Week-1
			, DATEADD(day
			, (7+MajorMovableHolidays.Day-
				DATEPART(WEEKDAY,  (SELECT DATE FROM dbo.KeyToDate(YEAR(DATE)*10000+MONTH(DATE)*100+1))))%7
			, (SELECT DATE FROM dbo.KeyToDate(YEAR(DATE)*10000+MONTH(DATE)*100+1))))=date
			AND DATEPART(Weekday, date)=MajorMovableHolidays.Day)
	OR (MajorMovableHolidays.Week<0
		AND MONTH(Date)=MajorMovableHolidays.Month
		AND DATEADD(Week
			, MajorMovableHolidays.Week+1
			, DATEADD(day
			    , -(7
					+DATEPART(WEEKDAY,DATEADD(day, -1, DATEADD(Month, 1
					, (SELECT DATE FROM dbo.KeyToDate(YEAR(DATE)*10000+MONTH(DATE)*100+1)))))
			        -MajorMovableHolidays.Day)%7
			    , DATEADD(day, -1, DATEADD(Month, 1, 
					(SELECT DATE FROM dbo.KeyToDate(YEAR(DATE)*10000+MONTH(DATE)*100+1))))))=date
		)

LEFT JOIN MayorEasterRelatedHolidays
	ON DATEADD(Day, MayorEasterRelatedHolidays.Days
		, dbo.Eastern(YEAR(date)))=dates.Date
LEFT JOIN WeatherSeason
	ON D.DateId%10000  BETWEEN WeatherSeason.WeatherStartDay AND WeatherSeason.WeatherEndDay
OPTION(MAXRECURSION 0);

--
