CREATE TABLE [common].[mst_GameMap] (
    [GameMapID]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [GameMapName] VARCHAR (200) NOT NULL,
    [GameID]      SMALLINT      NOT NULL, 
    CONSTRAINT [PK_mst_GameMap] PRIMARY KEY ([GameMapID]), 
    CONSTRAINT [FK_mst_GameMap_ToGames] FOREIGN KEY (GameID) REFERENCES common.mst_games(GameID), 
    CONSTRAINT [UK_mst_GameMap_GameID_Name] UNIQUE (GameID, GameMapName)
);

