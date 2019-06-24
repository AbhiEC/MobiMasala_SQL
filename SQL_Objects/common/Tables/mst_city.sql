CREATE TABLE [common].[mst_city] (
    CityID       SMALLINT      IDENTITY (1, 1) NOT NULL,
    [CityName] VARCHAR (200) NULL,
    [StateID]  SMALLINT      NULL, 
    CONSTRAINT [PK_mst_city] PRIMARY KEY (CityID), 
    CONSTRAINT [FK_mst_city_ToState] FOREIGN KEY (StateID) REFERENCES common.mst_state(StateID)
);

