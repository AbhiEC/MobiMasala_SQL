CREATE PROCEDURE common.[usp_get_GameMaps]
	@GameMapID SMALLINT -- 0 FOr all rows all columns and <RegionID> for all column for specific RegionID
AS
BEGIN
	SELECT	gm.GameMapID AS GameMapID, gm.GameMapName AS GameMapName
	FROM	common.mst_GameMap gm
	WHERE	(@GameMapID IN (0) OR gm.GameMapID = @GameMapID)
END