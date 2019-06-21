CREATE TABLE [tournament].[dtl_tournaments] (
    [id]                     INT            IDENTITY (1, 1) NOT NULL,
    [Name]                   VARCHAR (500)  NULL,
    [Desc]                   VARCHAR (2000) NULL,
    [GameID]                 SMALLINT       NULL,
    [FormatID]               SMALLINT       NULL,
    [PlatformID]             SMALLINT       NULL,
    [RegionID]               SMALLINT       NULL,
    [InfoID]                 SMALLINT       NULL,
    [ParticipantsTotal]      SMALLINT       NULL,
    [ParticipantsRegistered] SMALLINT       CONSTRAINT [DF__dtl_tourn__Parti__68487DD7] DEFAULT ((0)) NULL,
    [RegStartTime]           DATETIME       NULL,
    [RegEndTime]             DATETIME       NULL,
    [StartTime]              DATETIME       NULL,
    [EndTime]                DATETIME       NULL,
    [ListingLiveDate]        DATETIME       NULL,
    [CreatedOn]              DATETIME       CONSTRAINT [DF__dtl_tourn__Creat__693CA210] DEFAULT (getdate()) NULL,
    [CreatedBy]              INT            NULL,
    [LastModifiedOn]         DATETIME       NULL,
    [LastModifiedBy]         INT            NULL,
    CONSTRAINT [tournament_dtl_tournaments_pk] PRIMARY KEY CLUSTERED ([id] ASC)
);

