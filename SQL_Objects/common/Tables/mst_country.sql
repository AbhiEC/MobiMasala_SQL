CREATE TABLE [common].[mst_country] (
    [CountryID]   SMALLINT      IDENTITY (1, 1) NOT NULL,
    [CountryName] VARCHAR (200) NOT NULL,
    [IsListable]  BIT           CONSTRAINT [DF_mst_country_IsListable] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mst_country] PRIMARY KEY CLUSTERED ([CountryID] ASC)
);



