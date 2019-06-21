CREATE TABLE [common].[mst_config] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [ConfigName]   VARCHAR (200)  NOT NULL,
    [ConfigDesc]   VARCHAR (4000) NOT NULL,
    [ConfigValue1] VARCHAR (200)  NULL,
    [ConfigValue2] VARCHAR (200)  NULL,
    [ConfigValue3] VARCHAR (200)  NULL
);

