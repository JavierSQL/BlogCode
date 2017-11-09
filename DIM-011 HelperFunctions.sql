USE DimensionalSamples
GO
--- Scalar Function: HUGE Performance ISSUES.
--- TODO: Replace with Inline function
CREATE FUNCTION dbo.Eastern (@Yr as int) 
RETURNS DATETIME 
AS 
BEGIN 
--    Code found in: http://www.tek-tips.com/faqs.cfm?fid=5075 
	Declare @Cent int, @I int, @J int, @K int, @Metonic int, @EMo int, @EDay int 
	Set @Cent=@Yr/100 
	Set @Metonic=@Yr % 19 
	Set @K=(@Cent-17)/25 
	Set @I=(@Cent-@Cent/4-(@Cent-@K)/3+19*@Metonic+15) % 30 
	Set @I=@I-(@I/28)*(1-(@I/28)*(29/(@I+1))*((21-@Metonic)/11)) 
	Set @J=(@Yr+@Yr/4+@I+2-@Cent+@Cent/4) % 7 
	Set @EMo=3+(@I-@J+40)/44 
	Set @EDay=@I-@J+28-31*(@EMo/4) 
	RETURN CAST(CAST(@Yr*10000+@Emo*100+@Eday AS VARCHAR(8)) AS DATETIME); 
	-- This algorithm is from the work done by JM Oudin in 1940 and is accurate from year 1754 to 3400.
END; 
GO
-- HelperFunctions to Convert DateIDs to Dates and viceversa
-- INLINE Functions
CREATE FUNCTION DateToKey (@Date DATE)
RETURNS TABLE 
AS
	RETURN  SELECT YEAR(@Date)*10000 + MONTH(@Date)*100 +DAY(@Date) AS DateId;
GO
CREATE FUNCTION KeyToDate (@Key int)
RETURNS TABLE
AS
	RETURN SELECT CAST(CAST(@Key AS CHAR(8)) AS DATE) AS DATE
GO

CREATE FUNCTION dbo.FirstDayOf (@Date DATE, @Period VARCHAR(10) )
-- @Period IN ('Month', 'Quarter', 'Year')
RETURNS TABLE 
AS
RETURN SELECT CASE @Period
			WHEN 'Month'     THEN DATEADD(DD, 1 - DAY(@Date), @Date)
			WHEN 'Quarter'   THEN DATEADD(Month,  1- MONTH(@Date)
								  + (3*(DATEPART(Quarter, @Date)-1))
								 , DATEADD(DD, 1 - DAY(@Date), @Date))
			WHEN 'Year'		 THEN DATEADD(Month, 1-MONTH(@Date)
										, DATEADD(DD, 1 - DAY(@Date), @Date))
			END AS FirstDayOf
GO

CREATE FUNCTION LastDayOf(@Date DATE, @Period VARCHAR(10) )	
-- @Period IN ('Month', 'Quarter', 'Year')
RETURNS TABLE 
AS
RETURN SELECT CASE @Period
			WHEN 'Month'	THEN DATEADD(DD, -1, DATEADD(Month, 1, FDO.FirstDayOf))
			WHEN 'Quarter'	THEN DATEADD(DD, -1, DATEADD(Month, 3, FDO.FirstDayOf))
			WHEN 'Year'		THEN DATEADD(DD, -1, DATEADD(YEAR, 1, FDO.FirstDayOf))
		END AS LastDayOf
		FROM dbo.FirstDayOf(@Date, @Period) AS FDO
GO

