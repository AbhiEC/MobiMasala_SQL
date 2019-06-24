CREATE TABLE [common].[mst_country] (
    CountryID          SMALLINT      IDENTITY (1, 1) NOT NULL,
    [CountryName] VARCHAR (200) NULL, 
    CONSTRAINT [PK_mst_country] PRIMARY KEY (CountryID)
);

