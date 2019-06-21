CREATE TABLE [cms].[dtl_users] (
    [id]        INT             IDENTITY (1, 1) NOT NULL,
    [emailId]   VARCHAR (100)   NOT NULL,
    [pwd]       NVARCHAR (4000) NOT NULL,
    [FullName]  VARCHAR (200)   NOT NULL,
    [cms_role]  SMALLINT        NULL,
    [isenabled] BIT             CONSTRAINT [DF__dtl_users__isena__38996AB5] DEFAULT ((1)) NOT NULL,
    [createdon] DATETIME        DEFAULT (getdate()) NULL,
    CONSTRAINT [cms_dtl_users_pk] PRIMARY KEY CLUSTERED ([id] ASC)
);

