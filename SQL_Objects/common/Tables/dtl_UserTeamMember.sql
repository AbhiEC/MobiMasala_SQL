CREATE TABLE [common].[dtl_UserTeamMember] (
    [ID]               INT      IDENTITY (1, 1) NOT NULL,
    [TeamID]           INT      NOT NULL,
    [TeamMemberUserID] INT      NOT NULL,
    [TeamInvitationID] INT      NOT NULL,
    [CreatedBy]        INT      NOT NULL,
    [CreatedOn]        DATETIME CONSTRAINT [DF__dtl_UserT__Creat__3D2915A8] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]       INT      NULL,
    [ModifiedOn]       DATETIME CONSTRAINT [DF__dtl_UserT__Modif__3E1D39E1] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_dtl_UserTeamMember] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_dtl_UserTeamMember_ToUsers] FOREIGN KEY ([TeamMemberUserID]) REFERENCES [common].[dtl_users] ([UserID]),
    CONSTRAINT [FK_dtl_UserTeamMember_ToUserTeam] FOREIGN KEY ([TeamID]) REFERENCES [common].[dtl_UserTeams] ([TeamID])
);






