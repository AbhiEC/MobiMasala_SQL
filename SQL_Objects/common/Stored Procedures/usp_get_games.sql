CREATE PROCEDURE common.[usp_get_games]
	@PlatformID SMALLINT
	, @GameID SMALLINT -- Options are 0 FOr all rows all columns and GameID for all column for specific GameID
AS
BEGIN

	SELECT	g.GameID AS GameID, g.GameName AS GameName
	FROM	common.mst_games g
	WHERE	g.PlatformID = @PlatformID AND (@GameID IN (0) OR g.GameID = @GameID)

END
