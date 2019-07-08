

CREATE PROCEDURE [tournament].[usp_TournamentDetail]
	@TournamentID INT
AS
BEGIN
	SELECT	td.TournamentID AS TournamentID, td.Name AS TournamentName, td.StartTime AS TournamentStartTime, td.EndTime AS TournamentEndTime
			, td.RegStartTime AS RegistrationStartTime, td.RegEndTime AS RegistrationEndTime, td.ParticipantsTotal AS ParticipantsTotal
			, td.ParticipantsRegistered, td.InfoDesc, td.FormatName, td.FormatRules, json_query(td.TournamentPrizeList_JSON) AS Prizes, td.PrizeCount, td.FormatMode
			, td.GameID, td.FormatID, td.RegionID, td.RegionName, td.TournamentInfoID, td.InfoName, td.ListingLiveDate, td.IsCancelled, td.OnHold
			, td.EntryFee_TypeID, td.EntryFee_CurrencyID, td.EntryFee_Unit, td.GameMapID, td.GameMapName, td.TotalSlots, td.AvailableSlots
	FROM	tournament.vw_tournament_detail td
	WHERE	td.TournamentID = @TournamentID
	FOR JSON PATH
END