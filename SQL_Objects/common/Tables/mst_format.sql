CREATE TABLE [common].[mst_format] (
    FormatID          SMALLINT       IDENTITY (1, 1) NOT NULL,
    [FormatName]  VARCHAR (200)  NULL,
    [FormatDesc]  VARCHAR (2000) NULL,
    [GameID]      SMALLINT       NULL,
    [FormatRules] VARCHAR (4000) NULL, 
    CONSTRAINT [PK_mst_format] PRIMARY KEY (FormatID), 
    CONSTRAINT [FK_mst_format_ToGame] FOREIGN KEY (GameID) REFERENCES common.mst_games(GameID)
);

