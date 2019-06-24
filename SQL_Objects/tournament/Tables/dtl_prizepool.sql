CREATE TABLE [tournament].[dtl_prizepool] (
    [id]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [TournamentID] INT             NULL,
    [RankNo]       SMALLINT        NULL,
    [SubRankNo]    SMALLINT        CONSTRAINT [DF__dtl_prize__SubRa__5FB337D6] DEFAULT ((1)) NULL,
    [PrizePoolID]  SMALLINT        NULL,
    [Units]        DECIMAL (18, 2) NULL,
    [PrizeDesc]    VARCHAR (200)   NULL, 
    CONSTRAINT [FK_dtl_prizepool_TNMT] FOREIGN KEY ([TournamentID]) REFERENCES tournament.dtl_tournaments(id), 
    CONSTRAINT [PK_dtl_prizepool] PRIMARY KEY (id), 
    CONSTRAINT [FK_dtl_prizepool_mstPP] FOREIGN KEY ([PrizePoolID]) REFERENCES common.mst_prizepool(PrizePoolID)
);

