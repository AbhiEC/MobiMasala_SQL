CREATE TABLE [tournament].[dtl_prizepool] (
    [id]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [TournamentID] INT             NULL,
    [RankNo]       SMALLINT        NULL,
    [SubRankNo]    SMALLINT        CONSTRAINT [DF__dtl_prize__SubRa__5FB337D6] DEFAULT ((1)) NULL,
    [PrizePoolID]  SMALLINT        NULL,
    [Units]        DECIMAL (18, 2) NULL,
    [PrizeDesc]    VARCHAR (200)   NULL
);

