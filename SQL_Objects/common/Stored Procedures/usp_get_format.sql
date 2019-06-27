CREATE PROCEDURE common.[usp_get_format]
	@GameID SMALLINT
	, @FormatID SMALLINT -- Options are -1 for Id shortname all rows, 0 FOr all rows all columns and GameID for all column for specific GameID
AS
BEGIN
	SELECT	f.FormatID AS FormatID, f.FormatName AS FormatName
			, CASE WHEN @FormatID = -1 THEN '' ELSE f.FormatRules END FormatRules
	FROM	common.mst_format f
	WHERE	f.GameID = @GameID AND (@FormatID IN (0, -1) OR f.FormatID = @FormatID)
END