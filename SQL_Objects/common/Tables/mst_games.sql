CREATE TABLE [common].[mst_games] (
    [id]         SMALLINT       IDENTITY (1, 1) NOT NULL,
    [GameName]   VARCHAR (500)  NULL,
    [GameDesc]   VARCHAR (2000) NULL,
    [PlatformID] INT            NULL
);

