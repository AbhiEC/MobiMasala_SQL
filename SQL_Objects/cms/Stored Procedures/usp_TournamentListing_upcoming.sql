

CREATE PROCEDURE [cms].[usp_TournamentListing_upcoming]
AS
BEGIN
	SELECT	vtd.TournamentID AS TournamentID, vtd.Name AS TournamentName, vtd.GameID, vtd.RegionName AS Region, vtd.FormatName
			, vtd.StartTime AS TournamentStartTime, vtd.RegStartTime AS RegistrationStartTime, vtd.RegEndTime AS RegistrationEndTime
			, vtd.ParticipantsTotal AS TotalSlots, vtd.ParticipantsRegistered AS ParticipantsRegistered
			, vtd.FormatImageLink_1, vtd.FormatImageLink_2, vtd.ModeImageLink, JSON_QUERY(vtd.TournamentPrizePool_JSON) AS PrizePool_JSON
			, vtd.EntryFee_Unit AS EntryFee_Unit, vtd.EntryFee_TypeName AS EntryFee_Type, vtd.EntryFee_TypeID AS EntryFee_TypeID
			, vtd.TournamentRegistrationStatus, vtd.PrizePool_Cnt, vtd.TournamentStatus, vtd.FormatMode, vtd.MatchCount
	FROM	[tournament].[vw_tournament_detail] vtd
	WHERE	IsFinalScorecardUploaded = 0
	FOR JSON PATH
END