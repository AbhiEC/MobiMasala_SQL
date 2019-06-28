﻿CREATE TABLE [tournament].[dtl_tournaments] (
    [TournamentID]           INT            IDENTITY (1, 1) NOT NULL,
    [Name]                   VARCHAR (500)  NULL,
    [Desc]                   VARCHAR (2000) NULL,
    [GameID]                 SMALLINT       NULL,
    [FormatID]               INT            NULL,
    [RegionID]               SMALLINT       NULL,
    [InfoID]                 SMALLINT       NULL,
    [ParticipantsTotal]      SMALLINT       NULL,
    [ParticipantsRegistered] SMALLINT       CONSTRAINT [DF__dtl_tourn__Parti__68487DD7] DEFAULT ((0)) NULL,
    [RegStartTime]           DATETIME       NULL,
    [RegEndTime]             DATETIME       NULL,
    [StartTime]              DATETIME       NULL,
    [EndTime]                DATETIME       NULL,
    [ListingLiveDate]        DATETIME       NULL,
    [OnHold]                 BIT            CONSTRAINT [DF_dtl_tourn_IsHold] DEFAULT ((0)) NULL,
    [IsCancelled]            BIT            CONSTRAINT [DF__dtl_tourn__IsCan__693CA210] DEFAULT ((0)) NULL,
    [CreatedOn]              DATETIME       CONSTRAINT [DF__dtl_tourn__Creat__693CA210] DEFAULT (getdate()) NULL,
    [CreatedBy]              INT            NULL,
    [LastModifiedOn]         DATETIME       NULL,
    [LastModifiedBy]         INT            NULL,
    CONSTRAINT [tournament_dtl_tournaments_pk] PRIMARY KEY CLUSTERED ([TournamentID] ASC),
    CONSTRAINT [FK_dtl_tournaments_ToFormat] FOREIGN KEY ([FormatID]) REFERENCES [common].[mst_format] ([FormatID]),
    CONSTRAINT [FK_dtl_tournaments_ToGame] FOREIGN KEY ([GameID]) REFERENCES [common].[mst_games] ([GameID]),
    CONSTRAINT [FK_dtl_tournaments_ToInfo] FOREIGN KEY ([InfoID]) REFERENCES [tournament].[mst_tournament_info] ([TournamentInfoID]),
    CONSTRAINT [FK_dtl_tournaments_ToRegion] FOREIGN KEY ([RegionID]) REFERENCES [common].[mst_region] ([RegionID])
);



