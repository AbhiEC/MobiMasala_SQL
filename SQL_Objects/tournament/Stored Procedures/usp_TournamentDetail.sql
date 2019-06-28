

CREATE PROCEDURE [tournament].[usp_TournamentDetail]
	@TournamentID INT
AS
BEGIN
	SELECT	tn.TournamentID AS TournamentID, tn.Name AS TournamentName, tn.StartTime AS TournamentStartTime, tn.EndTime AS TournamentEndTime
			, tn.RegStartTime AS RegistrationStartTime, tn.RegEndTime AS RegistrationEndTime, tn.ParticipantsTotal AS ParticipantsTotal
			, tn.ParticipantsRegistered, ti.InfoDesc, fm.FormatName, fm.FormatRules, pp.Prizes, pp.PrizeCount
			, tn.GameID, fm.FormatID, rg.RegionID, rg.RegionName, ti.TournamentInfoID, ti.InfoName, tn.ListingLiveDate, tn.ISCancelled, tn.OnHold
	FROM	tournament.dtl_tournaments tn
			INNER JOIN tournament.mst_tournament_info ti
				ON tn.InfoID = ti.TournamentInfoID
			INNER JOIN common.mst_format fm
				ON tn.FormatID = fm.FormatID
			INNER JOIN common.mst_region rg
				ON tn.RegionID = rg.RegionID
			OUTER APPLY	(
							SELECT	JSON_QUERY(CONCAT('[', string_agg(CONCAT('{"rank":"'
									, dpp.RankNo, '","PrizeType":"', mpp.PrizeName, '","units":"', dpp.Units, '"}'), ','), ']')) AS Prizes
									, COUNT(1) AS PrizeCount
							FROM	tournament.dtl_prizepool dpp
									INNER JOIN common.mst_PrizeType mpp
										ON mpp.PrizeTypeID = dpp.PrizeTypeID
							WHERE	dpp.TournamentID = tn.TournamentID
							GROUP BY dpp.TournamentID
						) pp
	WHERE	tn.TournamentID = @TournamentID
	FOR JSON PATH
END