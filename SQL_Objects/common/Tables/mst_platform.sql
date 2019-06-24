CREATE TABLE [common].[mst_platform] (
    PlatformID           SMALLINT       IDENTITY (1, 1) NOT NULL,
    [PlatformName] VARCHAR (100)  NULL,
    [PlatformDesc] VARCHAR (2000) NULL, 
    CONSTRAINT [PK_mst_platform] PRIMARY KEY (PlatformID)
);

