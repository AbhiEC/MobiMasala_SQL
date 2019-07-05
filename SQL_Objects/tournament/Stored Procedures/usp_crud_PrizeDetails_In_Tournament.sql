CREATE PROCEDURE [tournament].[usp_crud_PrizeDetails_In_Tournament]
	@TournamentID INT
AS
BEGIN
	DECLARE @PrizePoolJSON NVARCHAR(4000) = N''
	DECLARE @PrizePool_Cnt SMALLINT = 0
	DECLARE @PrizeListJSON NVARCHAR(4000) = N''
	DECLARE @PrizeList_Cnt SMALLINT = 0

	IF OBJECT_ID('TempDB..#PrizeData') IS NOT NULL
		DROP TABLE #PrizeData
	SELECT	dpp.TournamentID, dpp.RankNo, mpp.PrizeName, dpp.Units, dpp.PrizePoolID, mpp.PrizeTypeID, cr.CurrencyID, cr.CurrencySymbol
	INTO	#PrizeData
	FROM	tournament.dtl_prizepool dpp
			INNER JOIN common.mst_PrizeType mpp
				ON mpp.PrizeTypeID = dpp.PrizeTypeID
			LEFT OUTER JOIN common.mst_currency cr
				ON dpp.CurrencyID = cr.CurrencyID
	WHERE	dpp.TournamentID = @TournamentID

	SELECT	@PrizeListJSON = 
			JSON_QUERY	(CONCAT	('[', string_agg	(CONCAT	(	'{', '"rank":"', PD.RankNo, '"', ',"PrizeType":"', PD.PrizeName, '"'
																, ',"units":"', PD.Units, '"', ',"PrizePoolID":"', PD.PrizePoolID, '"'
																, ',"PrizeTypeID":"', PD.PrizeTypeID, '"', ',"CurrencyID":"', PD.CurrencyID, '"'
																, ',"CurrencySymbol":"', PD.CurrencySymbol, '"'
																, '}'
															), ','), ']'))
			, @PrizeList_Cnt = COUNT(1)
	FROM	#PrizeData PD
	GROUP BY PD.TournamentID

	--SELECT @PrizeListJSON

	SELECT	@PrizePoolJSON = 
			JSON_QUERY	(CONCAT	('[', string_agg	(CONCAT	(	'{', '"PrizeTypeID":"', PD.PrizeTypeID, '"', ',"PrizeType":"', PD.PrizeName, '"'
																, ',"CurrencySymbol":"', PD.CurrencySymbol, '"', ',"units":"', PD.TotalUnits, '"'
																, '}'
															), ','), ']'))
			, @PrizePool_Cnt = COUNT(1)
	FROM	(	SELECT	PD.TournamentID, PD.PrizeTypeID, PD.PrizeName, PD.CurrencyID, PD.CurrencySymbol, SUM(PD.Units) AS TotalUnits
				FROM	#PrizeData PD
				GROUP BY PD.TournamentID, PD.PrizeTypeID, PD.PrizeName, PD.CurrencyID, PD.CurrencySymbol
			) PD
	GROUP BY PD.TournamentID

	--SELECT @PrizePoolJSON

	UPDATE	tn
	SET		TournamentPrizePool_JSON = @PrizePoolJSON, TournamentPrizeList_JSON = @PrizeListJSON
			, PrizePool_Cnt = @PrizePool_Cnt, Prize_Cnt = @PrizeList_Cnt
	FROM	tournament.dtl_tournaments tn
	WHERE	tn.TournamentID = @TournamentID
END