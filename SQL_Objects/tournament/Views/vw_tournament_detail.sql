

CREATE VIEW [tournament].[vw_tournament_detail]
AS
SELECT	tn.TournamentID, tn.[Name], tn.[Desc], tn.ParticipantsTotal, tn.ParticipantsRegistered, tn.RegStartTime, tn.RegEndTime, tn.StartTime
		, tn.EndTime, tn.ListingLiveDate, tn.OnHold, tn.IsCancelled, tn.CreatedOn, tn.CreatedBy, tn.LastModifiedOn, tn.LastModifiedBy
		, ti.TournamentInfoID, ti.InfoName, ti.GameID, ti.InfoDesc, rg.RegionID, rg.RegionName
		, fm.FormatID, fm.FormatGameGroupID, fm.FormatName, fm.FormatDesc, fm.TeamSize, fm.FormatMode, fm.FormatRules, fm.IsActive
		, tn.Prize_Cnt AS PrizeCount, tn.EntryFee_TypeID AS EntryFee_TypeID, fept.PrizeName AS EntryFee_TypeName
		, CASE WHEN tn.EntryFee_Units = 0 THEN N'FREE' ELSE CONCAT(ISNULL(fecc.CurrencySymbol, ''), tn.EntryFee_Units) END AS EntryFee_Unit
		, fm.FormatImageLink_1, fm.FormatImageLink_2, fm.ModeImageLink, tn.TournamentBannerImageLink, fecc.CurrencyID AS EntryFee_CurrencyID
		, tn.TournamentPrizeList_JSON, tn.TournamentPrizePool_JSON, tn.PrizePool_Cnt, tn.IsFinalScorecardUploaded
		, tn.GameMapID, gm.GameMapName, tn.MatchCount, tn.ScoringText
		, CASE	WHEN GETDATE() BETWEEN tn.RegStartTime AND tn.RegEndTime THEN CASE WHEN tn.ParticipantsTotal > tn.ParticipantsRegistered THEN 'OPEN' ELSE 'FULL' END
					ELSE 'CLOSE'
		  END TournamentRegistrationStatus
		, CASE	WHEN GETDATE() <= tn.StartTime THEN 'UPCOMING'	
				WHEN tn.StartTime < GETDATE() AND tn.IsFinalScorecardUploaded = 0 AND tn.EndTime > GETDATE() THEN 'IN PROGRESS'
				WHEN tn.IsFinalScorecardUploaded = 1 OR tn.EndTime < GETDATE() THEN 'COMPLETED'
		  END AS TournamentStatus
		, CONCAT(tn.ParticipantsTotal, ' ', fm.ParticipantUnit, CASE tn.ParticipantsTotal WHEN 1 THEN '' ELSE 's' END) AS TotalSlots
		, CONCAT(tn.ParticipantsTotal - tn.ParticipantsRegistered, ' ', fm.ParticipantUnit
				, CASE tn.ParticipantsTotal - tn.ParticipantsRegistered WHEN 1 THEN '' ELSE 's' END) AS AvailableSlots
FROM	tournament.dtl_tournaments tn
		INNER JOIN tournament.mst_tournament_info ti
			ON tn.InfoID = ti.TournamentInfoID
		INNER JOIN common.mst_format fm
			ON tn.FormatID = fm.FormatID
		INNER JOIN common.mst_region rg
			ON tn.RegionID = rg.RegionID
		INNER JOIN common.mst_GameMap gm
			ON gm.GameMapID = tn.GameMapID
		LEFT OUTER JOIN common.mst_PrizeType fept
			ON fept.PrizeTypeID = tn.EntryFee_TypeID
		LEFT OUTER JOIN common.mst_currency fecc
			ON fecc.CurrencyID = tn.EntryFee_CurrencyID