CREATE TABLE [common].mst_PrizeType (
    PrizeTypeID        SMALLINT     IDENTITY (1, 1) NOT NULL,
    [PrizeName] VARCHAR (50) NULL, 
    CONSTRAINT [PK_mst_prizeType] PRIMARY KEY (PrizeTypeID)
);

