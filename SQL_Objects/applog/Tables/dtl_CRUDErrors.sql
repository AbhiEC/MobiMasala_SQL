CREATE TABLE [applog].[dtl_CRUDErrors] (
    [CRUDErrorID]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [CallerUserID]       INT            NULL,
    [CalledSpName]       VARCHAR (1000) NULL,
    [SpParameter_String] NVARCHAR (MAX) NULL,
    [SpErrorMsg]         NVARCHAR (MAX) NULL,
    [SpCalledOn]         DATETIME       DEFAULT (getdate()) NULL,
    [IsResolved]         BIT            DEFAULT ((0)) NULL,
    [ResolvedOn]         DATETIME       NULL,
    [ResolutionComment]  NVARCHAR (MAX) NULL
);



