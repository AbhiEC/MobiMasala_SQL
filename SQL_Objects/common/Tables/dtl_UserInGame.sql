CREATE TABLE [common].[dtl_UserInGame]
(
	ID INT NOT NULL PRIMARY KEY
	, GameID SMALLINT NOT NULL
	, InGameUserName NVARCHAR(100) NOT NULL
	, InGameUserID VARCHAR(200)
	, CreatedOn DATETIME DEFAULT GETDATE()
	, ModifiedOn DATETIME
	, CONSTRAINT [FK_dtl_UserInGame_ToGame] FOREIGN KEY (GameID) REFERENCES common.mst_games(GameID)
	, CONSTRAINT [UK_dtl_UserInGame_InGameUserName] UNIQUE (InGameUserName)
	, CONSTRAINT [UK_dtl_UserInGame_InGameUserID] UNIQUE (InGameUserID)
)
