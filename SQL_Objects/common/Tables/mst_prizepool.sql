CREATE TABLE [common].[mst_prizepool] (
    PrizePoolID        SMALLINT     IDENTITY (1, 1) NOT NULL,
    [PrizeName] VARCHAR (50) NULL, 
    CONSTRAINT [PK_mst_prizepool] PRIMARY KEY (PrizePoolID)
);

