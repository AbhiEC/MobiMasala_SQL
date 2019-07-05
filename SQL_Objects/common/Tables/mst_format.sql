CREATE TABLE [common].[mst_format] (
    [FormatID]          INT            IDENTITY (1, 1) NOT NULL,
    [FormatGameGroupID] SMALLINT       NULL,
    [FormatName]        VARCHAR (200)  NULL,
    [FormatDesc]        VARCHAR (2000) NULL,
    [GameID]            SMALLINT       NULL,
    [TeamSize]          SMALLINT       NULL,
    [FormatMode]        VARCHAR (50)   NULL,
    [FormatRules]       VARCHAR (4000) NULL,
    [IsActive]          BIT            CONSTRAINT [DF_mst_format_IsActive] DEFAULT ((1)) NULL,
    [FormatImageLink_1] VARCHAR (4000) NULL,
    [FormatImageLink_2] VARCHAR (4000) NULL,
    [ModeImageLink]     VARCHAR (4000) NULL,
    CONSTRAINT [PK_mst_format] PRIMARY KEY CLUSTERED ([FormatID] ASC),
    CONSTRAINT [FK_mst_format_ToGame] FOREIGN KEY ([GameID]) REFERENCES [common].[mst_games] ([GameID]),
    CONSTRAINT [UK_mst_format] UNIQUE NONCLUSTERED ([GameID] ASC, [FormatGameGroupID] ASC)
);











