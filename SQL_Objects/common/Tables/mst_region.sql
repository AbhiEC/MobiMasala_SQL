CREATE TABLE [common].[mst_region] (
    RegionID         SMALLINT      IDENTITY (1, 1) NOT NULL,
    [RegionName] VARCHAR (200) NULL, 
    CONSTRAINT [PK_mst_region] PRIMARY KEY (RegionID)
);

