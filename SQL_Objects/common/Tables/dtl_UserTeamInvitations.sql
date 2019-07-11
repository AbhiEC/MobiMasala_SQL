CREATE TABLE [common].[dtl_UserTeamInvitations] (
    [TeamInvitationID]            INT      IDENTITY (1, 1) NOT NULL,
    [TeamID]                      INT      NULL,
    [TeamMemberUserID]            INT      NULL,
    [InviterUserID]               INT      NULL,
    [InvitedOn]                   DATETIME CONSTRAINT [DF__dtl_UserT__Invit__58671BC9] DEFAULT (getdate()) NULL,
    [IsInvitationCanceled]        BIT      CONSTRAINT [DF__dtl_UserT__IsInv__595B4002] DEFAULT ((0)) NULL,
    [InvitationCanceledOn]        DATETIME NULL,
    [InvitationCanceledByUserID]  INT      NULL,
    [IsInvitationAccepted]        BIT      CONSTRAINT [DF__dtl_UserT__IsInv__5A4F643B] DEFAULT ((0)) NULL,
    [InvitationAcceptedOn]        DATETIME NULL,
    [IsTeamMemberKickedOut]       BIT      CONSTRAINT [DF__dtl_UserT__IsTea__5B438874] DEFAULT ((0)) NULL,
    [TeamMemberKickedOutOn]       DATETIME NULL,
    [TeamMemberKickedOutByUserID] INT      NULL
);



