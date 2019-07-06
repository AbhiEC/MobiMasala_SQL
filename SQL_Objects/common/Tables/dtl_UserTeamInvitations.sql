CREATE TABLE [common].[dtl_UserTeamInvitations] (
    [TeamInvitationID]            INT      IDENTITY (1, 1) NOT NULL,
    [TeamID]                      INT      NULL,
    [TeamMemberUserID]            INT      NULL,
    [InviterUserID]               INT      NULL,
    [InvitedOn]                   DATETIME DEFAULT (getdate()) NULL,
    [IsInvitationCanceled]        BIT      DEFAULT ((0)) NULL,
    [InvitationCanceledOn]        DATETIME NULL,
    [InvitationCanceledByUserID]  INT      NULL,
    [IsInvitationAccepted]        BIT      DEFAULT ((0)) NULL,
    [IsTeamMemberKickedOut]       BIT      DEFAULT ((0)) NULL,
    [TeamMemberKickedOutOn]       DATETIME NULL,
    [TeamMemberKickedOutByUserID] INT      NULL
);

