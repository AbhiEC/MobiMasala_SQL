CREATE TABLE [common].[mst_state] (
    StateID        SMALLINT      IDENTITY (1, 1) NOT NULL,
    [StateName] VARCHAR (200) NULL,
    [CountryID] SMALLINT      NULL, 
    CONSTRAINT [PK_mst_state] PRIMARY KEY (StateID), 
    CONSTRAINT [FK_mst_state_ToCountry] FOREIGN KEY (CountryID) REFERENCES common.mst_country(CountryID)
);

