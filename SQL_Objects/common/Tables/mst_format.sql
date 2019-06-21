CREATE TABLE [common].[mst_format] (
    [id]          SMALLINT       IDENTITY (1, 1) NOT NULL,
    [FormatName]  VARCHAR (200)  NULL,
    [FormatDesc]  VARCHAR (2000) NULL,
    [GameID]      SMALLINT       NULL,
    [FormatRules] VARCHAR (4000) NULL
);

