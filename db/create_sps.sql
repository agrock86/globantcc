CREATE PROCEDURE SP_INSERT_DEPARTMENTS(@FileName NVARCHAR(50))
AS
BEGIN

DECLARE @FilePath NVARCHAR(100) = 'data-import/' + @FileName;
DECLARE @Sql NVARCHAR(MAX) = 'BULK INSERT departments FROM ''' + @FilePath + ''' WITH (DATA_SOURCE = ''BlobStorageImport'', FORMAT = ''CSV'')'

EXEC(@Sql)

END
GO

CREATE PROCEDURE SP_INSERT_JOBS(@FileName NVARCHAR(50))
AS
BEGIN

DECLARE @FilePath NVARCHAR(100) = 'data-import/' + @FileName;
DECLARE @Sql NVARCHAR(MAX) = 'BULK INSERT jobs FROM ''' + @FilePath + ''' WITH (DATA_SOURCE = ''BlobStorageImport'', FORMAT = ''CSV'')'

EXEC(@Sql)

END
GO

CREATE PROCEDURE SP_INSERT_EMPLOYEES(@FileName NVARCHAR(50))
AS
BEGIN

DECLARE @FilePath NVARCHAR(100) = 'data-import/' + @FileName;
DECLARE @Sql NVARCHAR(MAX) = 'BULK INSERT hired_employees FROM ''' + @FilePath + ''' WITH (DATA_SOURCE = ''BlobStorageImport'', FORMAT = ''CSV'')'

EXEC(@Sql)

END