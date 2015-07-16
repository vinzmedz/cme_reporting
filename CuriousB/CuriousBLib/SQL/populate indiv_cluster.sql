UPDATE CME_I_CAR
SET Indiv_cluster=('Cluster '+CAST((SELECT ABS(CHECKSUM(NewId())) % 9)+1 AS varchar(10)))