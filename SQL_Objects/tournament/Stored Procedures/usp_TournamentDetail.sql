

CREATE PROCEDURE [tournament].[usp_TournamentDetail]
	@TournamentID INT
AS
BEGIN
	SELECT	tn.id AS TournamentID, tn.Name AS TournamentName, tn.StartTime AS TournamentStartTime
			, tn.RegStartTime AS RegistrationStartTime, tn.RegEndTime AS RegistrationEndTime, tn.ParticipantsTotal AS TotalParticipants
			, tn.ParticipantsRegistered, ti.InfoDesc, fm.FormatName, fm.FormatRules, pp.Prizes, pp.PrizeCount
	FROM	tournament.dtl_tournaments tn
			INNER JOIN tournament.mst_tournament_info ti
				ON tn.InfoID = ti.TournamentInfoID
			INNER JOIN common.mst_format fm
				ON tn.FormatID = fm.FormatID
			OUTER APPLY	(
							SELECT	JSON_QUERY(CONCAT('[', string_agg(CONCAT('{"rank":"'
									, dpp.RankNo, '","PrizeType":"', mpp.PrizeName, '","units":"', dpp.Units, '"}'), ','), ']')) AS Prizes
									, COUNT(1) AS PrizeCount
							FROM	tournament.dtl_prizepool dpp
									INNER JOIN common.mst_prizepool mpp
										ON mpp.PrizePoolID = dpp.PrizePoolID
							WHERE	dpp.TournamentID = tn.id
							GROUP BY dpp.TournamentID
						) pp
	WHERE	tn.id = @TournamentID
	FOR JSON PATH
END