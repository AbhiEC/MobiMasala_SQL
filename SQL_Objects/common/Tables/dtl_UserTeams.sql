CREATE TABLE [common].[dtl_UserTeams] (
    [TeamID]          INT             NOT NULL,
    [TeamName]        NVARCHAR (2000) NOT NULL,
    [GameID]          SMALLINT        NOT NULL,
    [TeamIcon_Link]   VARCHAR (2000)  NOT NULL,
    [TeamBanner_Link] VARCHAR (2000)  NOT NULL,
    [CreatedByUserID] INT             NOT NULL,
    [CreatedOn]       DATETIME        CONSTRAINT [DF__dtl_UserT__Creat__3F115E1A] DEFAULT (getdate()) NULL,
    [ModifiedBy]      NCHAR (10)      NULL,
    [ModifiedOn]      DATETIME        NULL,
    CONSTRAINT [PK_dtl_UserTeams] PRIMARY KEY CLUSTERED ([TeamID] ASC),
    CONSTRAINT [FK_dtl_UserTeams_ToGame] FOREIGN KEY ([GameID]) REFERENCES [common].[mst_games] ([GameID]), 
    CONSTRAINT [UK_dtl_UserTeams_TeamName] UNIQUE (TeamName)
);




