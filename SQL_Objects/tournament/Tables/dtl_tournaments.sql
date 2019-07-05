CREATE TABLE [tournament].[dtl_tournaments] (
    [TournamentID]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]                   VARCHAR (500)  NULL,
    [Desc]                   VARCHAR (2000) NULL,
    [GameID]                 SMALLINT       NOT NULL,
    [FormatID]               INT            NOT NULL,
    [RegionID]               SMALLINT       NOT NULL,
    [InfoID]                 SMALLINT       NOT NULL,
    [ParticipantsTotal]      SMALLINT       NOT NULL,
    [ParticipantsRegistered] SMALLINT       CONSTRAINT [DF__dtl_tourn__Parti__68487DD7] DEFAULT ((0)) NULL,
    [RegStartTime]           DATETIME       NOT NULL,
    [RegEndTime]             DATETIME       NOT NULL,
    [StartTime]              DATETIME       NOT NULL,
    [EndTime]                DATETIME       NOT NULL,
    [ListingLiveDate]        DATETIME       NOT NULL,
    [OnHold]                 BIT            CONSTRAINT [DF_dtl_tourn_IsHold] DEFAULT ((0)),
    [IsCancelled]            BIT            CONSTRAINT [DF__dtl_tourn__IsCan__693CA210] DEFAULT ((0)),
    [CreatedOn]              DATETIME       CONSTRAINT [DF__dtl_tourn__Creat__693CA210] DEFAULT (getdate()),
    [CreatedBy]              INT            NOT NULL,
    [LastModifiedOn]         DATETIME       NULL,
    [LastModifiedBy]         INT            NULL,
	[TournamentBannerImageLink]       VARCHAR (4000) NULL,
    CONSTRAINT [tournament_dtl_tournaments_pk] PRIMARY KEY CLUSTERED ([TournamentID] ASC),
    CONSTRAINT [FK_dtl_tournaments_ToFormat] FOREIGN KEY ([FormatID]) REFERENCES [common].[mst_format] ([FormatID]),
    CONSTRAINT [FK_dtl_tournaments_ToGame] FOREIGN KEY ([GameID]) REFERENCES [common].[mst_games] ([GameID]),
    CONSTRAINT [FK_dtl_tournaments_ToInfo] FOREIGN KEY ([InfoID]) REFERENCES [tournament].[mst_tournament_info] ([TournamentInfoID]),
    CONSTRAINT [FK_dtl_tournaments_ToRegion] FOREIGN KEY ([RegionID]) REFERENCES [common].[mst_region] ([RegionID])
);



