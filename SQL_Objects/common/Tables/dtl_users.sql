CREATE TABLE [common].[dtl_users] (
    [UserID]         INT             IDENTITY (1, 1) NOT NULL,
    [UserName]       VARCHAR (200)   NOT NULL,
    [Pass_word]      NVARCHAR (4000) NULL,
    [EmailID]        VARCHAR (1000)  NOT NULL,
    [FirstName]      VARCHAR (200)   NULL,
    [MiddleName]     VARCHAR (200)   NULL,
    [LastName]       VARCHAR (200)   NULL,
    [MobileNumber]   VARCHAR (20)    NULL,
    [Token]          VARCHAR (200)   NOT NULL,
    [TokenCreatedOn] DATETIME        NOT NULL,
    [IsEnabled]      BIT             CONSTRAINT [DF_dtl_users_IsEnabled] DEFAULT ((1)) NOT NULL,
    [IsBanned]       BIT             NULL,
    [CreatedBy]      INT             NULL,
    [CreatedOn]      DATETIME        CONSTRAINT [DF__dtl_users__Creat__08B54D69] DEFAULT (getdate()) NULL,
    [ModifiedBy]     INT             NULL,
    [ModifiedOn]     DATETIME        NULL,
    CONSTRAINT [UC_UserName] UNIQUE NONCLUSTERED ([UserName] ASC)
);

