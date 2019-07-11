CREATE TABLE common.[mst_Currency_PrizeType_Linking]
(
	[CPLinkId] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	CurrencyID INT NOT NULL,
	PrizeTypeID SMALLINT NOT NULL, 
    CONSTRAINT [FK_mst_Currency_PrizeType_Linking_ToCurrency] FOREIGN KEY (CurrencyID) REFERENCES common.mst_currency(CurrencyID), 
    CONSTRAINT [FK_mst_Currency_PrizeType_Linking_ToPrizeType] FOREIGN KEY (PrizeTypeID) REFERENCES common.mst_PrizeType(PrizeTypeID)
)
