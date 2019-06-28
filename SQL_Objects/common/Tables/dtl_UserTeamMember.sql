CREATE TABLE [common].[dtl_UserTeamMember] (
    [ID]               INT      NOT NULL,
    [TeamID]           INT      NOT NULL,
    [TeamMemberUserID] INT      NOT NULL,
    [CreatedBy]        INT      NOT NULL,
    [CreatedOn]        DATETIME DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]       INT      NULL,
    [ModifiedOn]       DATETIME DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_dtl_UserTeamMember] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_dtl_UserTeamMember_ToUsers] FOREIGN KEY ([TeamMemberUserID]) REFERENCES [common].[dtl_users] ([UserID]),
    CONSTRAINT [FK_dtl_UserTeamMember_ToUserTeam] FOREIGN KEY ([TeamID]) REFERENCES [common].[dtl_UserTeams] ([TeamID])
);


