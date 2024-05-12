USE MyDatabase;
GO
DROP INDEX PK_MyClusteredIndex 
ON dbo.MyTable
WITH (
    MOVE TO MyPartitionScheme
        FILESTREAM_ON MyPartitionScheme
    )
;
GO

