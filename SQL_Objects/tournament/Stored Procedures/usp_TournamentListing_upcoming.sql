
CREATE PROCEDURE [tournament].[usp_TournamentListing_upcoming]
AS
BEGIN
 	SELECT	vtd.TournamentID AS TournamentID, vtd.Name AS TournamentName, vtd.FormatImageLink_1, vtd.TournamentStatus, vtd.FormatImageLink_2, vtd.ModeImageLink
			, vtd.FormatName, vtd.FormatMode, vtd.RegStartTime AS RegistrationStartTime, vtd.StartTime AS TournamentStartTime
			, vtd.TournamentRegistrationStatus, vtd.EntryFee_Unit AS EntryFee_Unit, vtd.EntryFee_TypeName AS EntryFee_Type
			, JSON_QUERY(vtd.TournamentPrizePool_JSON) AS PrizePool_JSON, vtd.PrizePool_Cnt, vtd.TeamSize, vtd.MatchCount
			, vtd.RegEndTime AS RegistrationEndTime, vtd.TotalSlots, vtd.AvailableSlots, vtd.GameMapName
			, JSON_QUERY(vtd.TournamentPrizeList_JSON) AS PrizeList_JSON, vtd.PrizeCount
			, vtd.InfoName AS TournamentInfo, vtd.ScoringText, vtd.FormatRules
	FROM	[tournament].[vw_tournament_detail] vtd
	WHERE	vtd.RegEndTime > GETDATE() AND vtd.ListingLiveDate < GETDATE()
			AND vtd.OnHold = 0
	FOR JSON PATH
END
 