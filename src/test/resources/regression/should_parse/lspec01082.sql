ALTER TABLE PartitionTable1 
REBUILD PARTITION = ALL 
WITH (DATA_COMPRESSION = PAGE ON PARTITIONS(1) ) ;
GO
