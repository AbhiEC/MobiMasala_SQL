CREATE TABLE [tournament].[dtl_prizepool] (
    PrizePoolID           BIGINT          IDENTITY (1, 1) NOT NULL,
    [TournamentID] INT             NULL,
    [RankNo]       SMALLINT        NULL,
    [SubRankNo]    SMALLINT        CONSTRAINT [DF__dtl_prize__SubRa__5FB337D6] DEFAULT ((1)) NULL,
    PrizeTypeID  SMALLINT        NULL,
    [Units]        DECIMAL (18, 2) NULL,
    [PrizeDesc]    VARCHAR (200)   NULL, 
    CONSTRAINT [FK_dtl_prizepool_TNMT] FOREIGN KEY ([TournamentID]) REFERENCES tournament.dtl_tournaments(TournamentID), 
    CONSTRAINT [PK_dtl_prizepool] PRIMARY KEY (PrizePoolID), 
    CONSTRAINT [FK_dtl_prizepool_mstPP] FOREIGN KEY (PrizeTypeID) REFERENCES common.mst_PrizeType(PrizeTypeID),
	CONSTRAINT [UK_dtl_prizePool] UNIQUE (TournamentID, RankNo, SubRankNo)
);

