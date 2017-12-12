/*  
Description: Query to find duplicate indexes on SQL Server  
Author:		JavierSQL (Javier Loria)
Create Date: 20171210
Modified Date:  
Modification:   
*/  

WITH BaseNumbers AS (
--- Used to gather number columns in the Index
	SELECT 1 AS ColId
	UNION ALL
	SELECT ColId+1
	FROM BaseNumbers
	WHERE ColId<32
)
, IndexColumns AS (
	SELECT Sch.name AS SchemaName,
		Obj.name AS TableName,
		Idx.name AS IndexName,
		IdX.type_desc AS IndexType,
		Idx.index_id,
		Idc.key_ordinal,
		Col.name AS ColumnName
	FROM sys.indexes AS Idx
	INNER JOIN sys.objects AS Obj 
		ON Idx.object_id = Obj.object_id 
	INNER JOIN sys.schemas AS SCH 
		ON Obj.schema_id = SCH.schema_id 
	JOIN sys.index_columns AS Idc
		ON Idx.index_id = Idc.index_id
			AND Idx.object_id = Idc.object_id
	INNER JOIN sys.columns AS Col
		ON Col.column_id = Idc.column_id
		AND Col.object_id = Idc.object_id
	WHERE Idx.index_id > 0				--- No Heaps
		AND Obj.is_ms_shipped=0			--- Not MS Products
		AND Obj.type in ('U ', 'V ')	--- Tables and Views (No internal tables) 
		AND IDX.type IN (1,2,7)			--- CLUSTERED, NONCLUSTERED AND NONCLUSTERED HASH
		AND Idc.is_included_column=0	--- No included columns
)
, IndexColumnsAgg AS  (
	SELECT SchemaName,	TableName,	IndexName,	IndexType,	index_id, key_ordinal AS NumberOfCol
		, CAST(ColumnName AS VARCHAR(MAX)) AS IndexColumns
	FROM IndexColumns
	WHERE key_ordinal=1
	UNION ALL
	SELECT AGG.SchemaName,	AGG.TableName,	AGG.IndexName,	AGG.IndexType,	IC.index_id  AS NumberOfCol, IC.key_ordinal
		, CAST(CONCAT(AGG.IndexColumns, ', ', ColumnName) AS VARCHAR(MAX))   AS IndexColumns
	FROM IndexColumnsAgg AS AGG
	JOIN IndexColumns AS IC
		ON AGG.SchemaName=IC.SchemaName
		AND AGG.TableName=IC.TableName
		AND AGG.IndexName=IC.IndexName
		AND AGG.NumberOfCol+1=IC.key_ordinal
)
, IndexColumnsAggExt AS (
	SELECT *, 
	LAST_VALUE(NumberOfCol) 
		OVER(PARTITION BY SchemaName, TableName,  IndexName ORDER BY  NumberOfCol ASC
		RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS TotalNumberOfCol
		, LAST_VALUE(IndexColumns) 
		OVER(PARTITION BY SchemaName, TableName,  IndexName ORDER BY  NumberOfCol ASC
		RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS FullIndexColumns
	FROM IndexColumnsAgg
)
, IndexPairs AS (
SELECT L.SchemaName, L.TableName 
	, CONCAT(L.NumberOfCol, ' of ', L.TotalNumberOfCol, '/', R.TotalNumberOfCol) AS ColWidth
	, L.IndexName AS FirstIndexName
	, L.IndexType AS FirstIndexType
	, L.TotalNumberOfCol AS FirstNumberOfCol
	, R.IndexName AS SecnIndexName
	, R.IndexType AS SecnIndexType
	, R.TotalNumberOfCol AS SecnNumberOfCol
	, L.FullIndexColumns AS FirstFullIndexColumns
	, R.FullIndexColumns AS SecnFullIndexColumns
	, L.IndexColumns AS SharedColumns
	, L.NumberOfCol AS NumberOfSharedColumns
	, CASE WHEN L.TotalNumberOfCol> R.TotalNumberOfCol THEN  L.TotalNumberOfCol 
		ELSE R.TotalNumberOfCol END AS MaxNumberColumns
	, ROW_NUMBER() OVER(PARTITION BY L.SchemaName, L.TableName, L.IndexName, R.IndexName 
						ORDER BY L.NumberOfCol DESC) AS Pos
FROM IndexColumnsAggExt AS L
JOIN IndexColumnsAggExt AS R
	ON L.SchemaName=R.SchemaName
	AND L.TableName=R.TableName
	AND L.IndexColumns=R.IndexColumns
	AND L.NumberOfCol=R.NumberOfCol
	AND L.index_id<R.index_id
)
SELECT C.Criteria, IP.* 
FROM IndexPairs AS IP
CROSS APPLY (SELECT CASE WHEN NumberOfSharedColumns=MaxNumberColumns THEN '1. Same Keys'
	        WHEN FirstNumberOfCol=MaxNumberColumns OR SecnNumberOfCol=MaxNumberColumns
					THEN '2. Included'
			WHEN SharedColumns>3 THEN '3. +3 Shared Keys'
			ELSE '9. Shared Keys'
			END AS Criteria) AS C
WHERE Pos=1
ORDER BY 1 



