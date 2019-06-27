CREATE PROCEDURE tournament.[usp_get_tournament_info]
	@GameID SMALLINT
	, @TournamentInfoID SMALLINT -- Options are -1 for Id shortname all rows, 0 FOr all rows all columns and GameID for all column for specific GameID
AS
BEGIN
	SELECT	ti.TournamentInfoID AS TournamentInfoID, ti.InfoName AS InfoName
			, CASE WHEN @TournamentInfoID IN (-1) THEN '' ELSE ti.InfoDesc END FormatRules
	FROM	tournament.mst_tournament_info ti
	WHERE	ti.GameID = @GameID AND (@TournamentInfoID IN (0, -1) OR ti.TournamentInfoID = @TournamentInfoID)
END