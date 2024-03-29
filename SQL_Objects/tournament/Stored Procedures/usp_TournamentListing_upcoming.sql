﻿CREATE PROCEDURE [tournament].[usp_TournamentListing_upcoming]
AS
BEGIN
	SELECT	tn.id AS TournamentID, tn.Name AS TournamentName, tn.GameID, rg.RegionName AS Region, fm.FormatName
			, tn.StartTime AS TournamentStartTime, tn.RegStartTime AS RegistrationStartTime, tn.RegEndTime AS RegistrationEndTime
	FROM	tournament.dtl_tournaments tn
			INNER JOIN common.mst_region rg
				ON tn.RegionID = rg.id
			INNER JOIN common.mst_format fm
				ON fm.id = tn.FormatID
	WHERE	tn.RegEndTime > GETDATE() AND tn.listingLiveDate < GETDATE()
END
