CREATE TABLE [common].[dtl_users_banned] (
    [ID]         INT            IDENTITY (1, 1) NOT NULL,
    [UserID]     INT            NULL,
    [BanStart]   DATETIME       NULL,
    [BanEnd]     DATETIME       NULL,
    [BanReason]  VARCHAR (4000) NULL,
    [IsBanValid] BIT            CONSTRAINT [DF_dtl_users_banned_IsBanValid] DEFAULT ((1)) NULL,
    [ModifiedBy] INT            CONSTRAINT [DF__dtl_users__Modif__208CD6FA] DEFAULT ((0)) NULL,
    [ModifiedOn] DATETIME       CONSTRAINT [DF__dtl_users__Modif__2180FB33] DEFAULT (getdate()) NULL
);

