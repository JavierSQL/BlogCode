---- List of  AUTOCREATED Statistics
SELECT OBJECT_SCHEMA_NAME(O.object_id) AS SchemaName
	, O.name AS ObjectName
	, S.name AS StastisticsName
FROM sys.stats AS S
JOIN sys.objects AS O
	ON S.object_id=O.object_id
WHERE S.auto_created=1
	AND O.type='U '
	AND O.is_ms_shipped=0;
GO

-- Simple by Table 
SELECT OBJECT_SCHEMA_NAME(O.object_id) AS SchemaName
	, O.name AS  ObjectName
	, I.name AS  StatisticsName
	, STATS_DATE(id,indid) as LastUpdate
FROM sys.sysindexes AS I
INNER JOIN sys.objects AS O
	ON I.id = O.object_id
WHERE O.type = 'U'			--- User Table
	AND O.is_ms_shipped=0	--- Not MS Component
	AND I.indid>0			--- No Heaps
ORDER BY LastUpdate	ASC;

--- More Complex: by Column plus additional information
SELECT  OBJECT_SCHEMA_NAME(T.object_id) AS SchemaName
		, T.name AS ObjectName
		, S.name AS StatisticsName
		, SCol.stats_column_id 
		, C.name AS ColumnName
		, SProp.last_updated
		, SProp.rows
		, SProp.rows_sampled
		, SProp.steps
		, SProp.unfiltered_rows
		, SProp.modification_counter
FROM    sys.stats AS S
INNER JOIN sys.stats_columns AS SCol
	ON S.stats_id = SCol.stats_id
		AND s.object_id = SCol.object_id
INNER JOIN sys.columns AS C 
	ON C.object_id = SCol.object_id
		AND C.column_id = SCol.column_id
INNER JOIN sys.tables AS T 
	ON c.object_id = T.object_id
OUTER APPLY sys.dm_db_stats_properties(S.object_id,s.stats_id) AS SProp
ORDER BY 1, 2, 3, 4;

GO
SELECT object_name, StatisticsName, auto_created, user_created
	,  [1],  [2],  [3],  [4],  [5],  [6],  [7],  [8],  [9], [10] 
	, [11], [12], [13], [14], [15], [16], [17], [18], [19], [20] 
	, [21], [22], [23], [24], [25], [26], [27], [28], [29], [30] 
	, [31], [32]
FROM (
	SELECT OBJECT_NAME(S.object_id) AS object_name
		, SCol.stats_column_id
		, C.name AS ColumnName
		, S.name AS StatisticsName
		, S.auto_created, S.user_created
	FROM sys.stats AS S 
	JOIN sys.stats_columns AS SCol
		ON s.object_id=SCol.object_id
		 and s.stats_id = SCol.stats_id
	INNER JOIN sys.columns AS C 
		ON C.object_id = SCol.object_id
			AND C.column_id = SCol.column_id
	WHERE s.object_id not in (select object_id from sys.objects where is_ms_shipped=1)
	) AS Source
PIVOT (MAX(ColumnName) 
	FOR stats_column_id  IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10] 
							, [11], [12], [13], [14], [15], [16], [17], [18], [19], [20] 
							, [21], [22], [23], [24], [25], [26], [27], [28], [29], [30]
							, [31], [32])) AS Pvt
ORDER BY StatisticsName;


---- Drop all Auto-Create Statistics
DECLARE @Cmd VARCHAR(MAX);

WITH AutoStats AS (
	SELECT OBJECT_SCHEMA_NAME(O.object_id) AS SchemaName
		, O.name AS ObjectName
		, S.name AS StastisticsName
		, ROW_NUMBER() OVER (ORDER BY S.object_id, S.stats_id) AS RN
	FROM sys.stats AS S
	JOIN sys.objects AS O
		ON S.object_id=O.object_id
	WHERE S.auto_created=1
		AND O.type='U '
		AND O.is_ms_shipped=0
), RecursiveAutoStats AS (
	SELECT TOP 1 CAST('DROP STATISTICS ' 
		+ QUOTENAME(SchemaName)+'.'
		+ QUOTENAME(ObjectName)+'.'
		+ QUOTENAME(StastisticsName) AS VARCHAR(MAX)) Cmd
		, RN
	FROM AutoStats
	ORDER BY RN DESC
	UNION ALL
	SELECT CAST(RAS.Cmd+ ' , '+ QUOTENAME(A.SchemaName)+'.'
		+ QUOTENAME(A.ObjectName)+'.'
		+ QUOTENAME(A.StastisticsName) AS VARCHAR(MAX)) Cmd
		, A.RN
	FROM RecursiveAutoStats AS  RAS
	JOIN AutoStats AS A
	ON RAS.RN-1=A.RN
)
SELECT @Cmd=Cmd
FROM RecursiveAutoStats
WHERE RN=1
EXEC (@Cmd)

