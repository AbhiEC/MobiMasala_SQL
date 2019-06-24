﻿CREATE TABLE common.[dtl_UserTeams]
(
	ID INT NOT NULL PRIMARY KEY
	, TeamName NVARCHAR(2000) NOT NULL
	, GameID SMALLINT NOT NULL
	, FormatID SMALLINT NOT NULL
	, [CreatedBy] INT NOT NULL
	, CreatedOn DATETIME DEFAULT(GETDATE()), 
    [ModifiedBy] NCHAR(10) NULL, 
    [ModifiedOn] DATETIME NULL
)