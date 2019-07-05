CREATE PROCEDURE [tournament].[usp_TournamentListing_upcoming]
AS
BEGIN
	SELECT	vtd.TournamentID AS TournamentID, vtd.Name AS TournamentName, vtd.GameID, vtd.RegionName AS Region, vtd.FormatName
			, vtd.StartTime AS TournamentStartTime, vtd.RegStartTime AS RegistrationStartTime, vtd.RegEndTime AS RegistrationEndTime
			, vtd.ParticipantsTotal AS TotalSlots, vtd.ParticipantsRegistered AS ParticipantsRegistered
			, vtd.FormatImageLink_1, vtd.FormatImageLink_2, vtd.ModeImageLink, vtd.TournamentPrizePool_JSON AS PrizePool_JSON
			, vtd.EntryFee_Unit AS EntryFee_Unit, vtd.EntryFee_TypeName AS EntryFee_Type, vtd.EntryFee_TypeID AS EntryFee_TypeID
			, CASE	WHEN GETDATE() BETWEEN vtd.RegStartTime AND vtd.RegEndTime THEN CASE WHEN vtd.ParticipantsTotal > vtd.ParticipantsRegistered THEN 'OPEN' ELSE 'FULL' END
					ELSE 'CLOSE'
			END TournamentRegistrationStatus
	FROM	[tournament].[vw_tournament_detail] vtd
	WHERE	vtd.RegEndTime > GETDATE() AND vtd.ListingLiveDate < GETDATE()
END
