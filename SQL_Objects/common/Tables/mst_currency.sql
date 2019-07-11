CREATE TABLE [common].[mst_currency] (
    [CurrencyID]        INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyName]      VARCHAR (500) NOT NULL,
    [CurrencyShortName] VARCHAR (3)   NOT NULL,
    [CurrencySymbol]    NVARCHAR (1)  NOT NULL,
    [CountryID]         SMALLINT      NOT NULL,
    [IsListable]        BIT           CONSTRAINT [DF_mst_currency_IsListable] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mst_currency] PRIMARY KEY CLUSTERED ([CurrencyID] ASC),
    CONSTRAINT [FK_mst_currency_ToCountry] FOREIGN KEY ([CountryID]) REFERENCES [common].[mst_country] ([CountryID])
);



