CREATE TABLE [common].[mst_games] (
    GameID         SMALLINT       IDENTITY (1, 1) NOT NULL,
    [GameName]   VARCHAR (500)  NULL,
    [GameDesc]   VARCHAR (2000) NULL,
    [PlatformID] SMALLINT            NULL, 
    CONSTRAINT [PK_mst_games] PRIMARY KEY (GameID), 
    CONSTRAINT [FK_mst_games_ToPlatform] FOREIGN KEY (PlatformID) REFERENCES common.mst_platform(PlatformID)
);

