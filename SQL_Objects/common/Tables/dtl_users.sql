CREATE TABLE [common].[dtl_users] (
    [UserID]         INT            IDENTITY (1, 1) NOT NULL,
    [UserName]       VARCHAR (200)  NOT NULL,
    [Pwd]            VARCHAR (2000) NULL,
    [EmailID]        VARCHAR (1000) NOT NULL,
    [FirstName]      VARCHAR (200)  NULL,
    [MiddleName]     VARCHAR (200)  NULL,
    [LastName]       VARCHAR (200)  NULL,
    [MobileNumber]   VARCHAR (20)   NULL,
    [CityID]         SMALLINT       NULL,
    [Token]          VARCHAR (200)  NULL,
    [TokenCreatedOn] DATETIME       NOT NULL,
    [IsEnabled]      BIT            CONSTRAINT [DF_dtl_users_IsEnabled] DEFAULT ((1)) NOT NULL,
    [IsBanned]       BIT            NULL,
    [CreatedBy]      INT            NULL,
    [CreatedOn]      DATETIME       CONSTRAINT [DF__dtl_users__Creat__08B54D69] DEFAULT (getdate()) NULL,
    [ModifiedBy]     INT            NULL,
    [ModifiedOn]     DATETIME       NULL,
    CONSTRAINT [PK_dtl_user] PRIMARY KEY CLUSTERED ([UserID] ASC),
    CONSTRAINT [FK_dtl_users_ToCity] FOREIGN KEY ([CityID]) REFERENCES [common].[mst_city] ([CityID]),
    CONSTRAINT [UK_dtl_users_EmailID] UNIQUE NONCLUSTERED ([EmailID] ASC),
    CONSTRAINT [UK_dtl_users_UserName] UNIQUE NONCLUSTERED ([UserName] ASC)
);







