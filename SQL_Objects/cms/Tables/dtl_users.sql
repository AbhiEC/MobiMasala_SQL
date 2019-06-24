CREATE TABLE [cms].[dtl_users] (
    [id]             INT             IDENTITY (1, 1) NOT NULL,
    [emailId]        VARCHAR (100)   NOT NULL,
    [pwd]            VARCHAR(2000) NULL,
    [FullName]       VARCHAR (200)   NOT NULL,
    [cms_role]       SMALLINT        NULL,
    [isenabled]      BIT             CONSTRAINT [DF__dtl_users__isena__38996AB5] DEFAULT ((1)) NOT NULL,
    [Token]          VARCHAR (200)   NULL,
    [TokenCreatedOn] DATETIME        NULL,
    [createdon]      DATETIME        CONSTRAINT [DF__dtl_users__creat__7F2BE32F] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [cms_dtl_users_pk] PRIMARY KEY CLUSTERED ([id] ASC)
);



