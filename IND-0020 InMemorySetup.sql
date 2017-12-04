-- Alter the databas to allow a memory-optimized filegroup and "File"
ALTER DATABASE DemoIndexes ADD FILEGROUP DemoIndexes_MEM CONTAINS MEMORY_OPTIMIZED_DATA   
ALTER DATABASE DemoIndexes ADD FILE (name='DemoIndexes_MEM'
	, filename='S:\MSSQL\MSSQL14.MSSQLSERVER\MSSQL\DATA\DemoIndexes_MEM') TO FILEGROUP DemoIndexes_MEM   
-- Best practice
ALTER DATABASE DemoIndexes SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT=ON ;
 
GO
