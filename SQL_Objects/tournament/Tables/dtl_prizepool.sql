CREATE TABLE [tournament].[dtl_prizepool] (
    [PrizePoolID]  BIGINT          IDENTITY (1, 1) NOT NULL,
    [TournamentID] INT             NOT NULL,
    [RankNo]       SMALLINT        NOT NULL,
    [SubRankNo]    SMALLINT        CONSTRAINT [DF__dtl_prize__SubRa__5FB337D6] DEFAULT ((1)) NULL,
    [PrizeTypeID]  SMALLINT        NOT NULL,
    [CurrencyID]   SMALLINT        NULL,
    [Units]        DECIMAL (18, 2) NOT NULL,
    [PrizeDesc]    VARCHAR (200)   NULL,
    CONSTRAINT [PK_dtl_prizepool] PRIMARY KEY CLUSTERED ([PrizePoolID] ASC),
    CONSTRAINT [FK_dtl_prizepool_mstPP] FOREIGN KEY ([PrizeTypeID]) REFERENCES [common].[mst_PrizeType] ([PrizeTypeID]),
    CONSTRAINT [FK_dtl_prizepool_TNMT] FOREIGN KEY ([TournamentID]) REFERENCES [tournament].[dtl_tournaments] ([TournamentID]),
    CONSTRAINT [UK_dtl_prizePool] UNIQUE NONCLUSTERED ([TournamentID] ASC, [RankNo] ASC, [SubRankNo] ASC)
);



