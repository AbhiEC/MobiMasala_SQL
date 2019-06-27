CREATE PROCEDURE common.[usp_get_region]
	@RegionID SMALLINT -- 0 FOr all rows all columns and <RegionID> for all column for specific RegionID
AS
BEGIN
	SELECT	r.RegionID AS RegionID, r.RegionName AS RegionName
	FROM	common.mst_region r
	WHERE	(@RegionID IN (0) OR r.RegionID = @RegionID)
END