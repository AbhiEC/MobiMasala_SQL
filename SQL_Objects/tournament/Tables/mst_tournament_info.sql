CREATE TABLE [tournament].[mst_tournament_info] (
    TournamentInfoID       SMALLINT       IDENTITY (1, 1) NOT NULL,
    [InfoName] VARCHAR (200)  NULL,
    [GameID]   SMALLINT       NULL,
    [InfoDesc] VARCHAR (4000) NULL, 
    CONSTRAINT [PK_mst_tournament_info] PRIMARY KEY (TournamentInfoID), 
    CONSTRAINT [FK_mst_tournament_info_ToGame] FOREIGN KEY (GameID) REFERENCES common.mst_games(GameID)
);

