﻿CREATE PROCEDURE [cms].[usp_crud_Tournament]
	@Action CHAR(1) --Options currently available 'U', 'I'
	, @TournamentID INT
	, @TournamentName VARCHAR(500)
	, @TournamentDesc VARCHAR(2000)
	, @GameID SMALLINT
	, @FormatID SMALLINT
	, @RegionID SMALLINT
	, @TournamentInfoID SMALLINT
	, @ParticipantsTotal SMALLINT
	, @RegistrationStartTime DATETIME
	, @RegistrationEndTime DATETIME
	, @TournamentStartTime DATETIME
	, @TournamentEndTime DATETIME
	, @ListingLiveDate DATETIME
	, @ActionedByAdminUserID INT
	, @IsCancelled BIT = 0
	, @OnHold BIT = 0
	, @Prizes NVARCHAR(4000)
	, @EntryFee_TypeID SMALLINT
	, @EntryFee_CurrencyID INT
	, @EntryFee_Units DECIMAL(18,2)
	, @TournamentBannerImageLink VARCHAR(4000)

AS
BEGIN
	DECLARE @ErrMsg VARCHAR(8000) = ''

	BEGIN TRY
		BEGIN --Tournament validations
			IF	@RegistrationStartTime >= @RegistrationEndTime
				THROW 51000, 'Registration StartTime is ahead of/same as Registration EndTime!', 1;
			ELSE IF	@RegistrationStartTime >= @TournamentStartTime
				THROW 51000, 'Registration StartTime is ahead of/same as Tournament StartTime!', 1;
			ELSE IF	@RegistrationEndTime >= @TournamentEndTime
				THROW 51000, 'Registration EndTime is ahead of/same as Tournament EndTime!', 1;
			ELSE IF	@TournamentStartTime >= @TournamentEndTime
				THROW 51000, 'Tournament StartTime is ahead of/same as Tournament EndTime!', 1;
			ELSE IF	@ListingLiveDate > @RegistrationStartTime
				THROW 51000, 'Listing Live Date should earlier than Registration StartTime!', 1;
			ELSE IF @Action = 'U' AND @TournamentDesc <= 0
				THROW 51000, 'Invalid tournament ID!', 1;
		END

		BEGIN --Prizes JSON parsing and validation
			IF OBJECT_ID('TempDB..#Prizes') IS NOT NULL
				DROP TABLE #Prizes
			CREATE TABLE #Prizes
			(
				PrizeRank SMALLINT NOT NULL PRIMARY KEY,
				PrizeType VARCHAR(200) NOT NULL,
				Units DECIMAL(10,2) NOT NULL,
				PrizeTypeID SMALLINT NOT NULL,
				GrpID TINYINT
			)

			INSERT INTO #Prizes
			(PrizeRank, PrizeType, Units, PrizeTypeID, GrpID)
			SELECT	J.[rank], J.PrizeType, J.units, PP.PrizeTypeID, 1
			FROM	(
						SELECT	* 
						FROM	OPENJSON ( @Prizes )  
						WITH	(	rank smallint '$.rank' ,  
									PrizeType VARCHAR(100) '$.PrizeType',  
									Units DECIMAL(10,2) '$.units'
								) 
					) J
					LEFT OUTER JOIN common.mst_PrizeType pp
						ON J.PrizeType = PrizeName

			IF EXISTS	(	SELECT	GrpID
							FROM	#Prizes
							GROUP BY GrpID
							HAVING (COUNT(1) <> MAX(PrizeRank) OR MIN(PrizeRank) <> 1 OR COUNT(1) = 0)
						)
				THROW 51000, 'Something wrong in PrizePool JSON!', 1;
		END

		BEGIN TRANSACTION

		IF @Action = 'U'
			BEGIN
				DECLARE @UpdateCnt INT = 0
				UPDATE	t
				SET		t.[Name] = @TournamentName
						, t.[Desc] = @TournamentDesc
						, t.GameID = @GameID
						, t.FormatID = @FormatID
						, t.RegionID = @RegionID
						, t.InfoID = @TournamentInfoID
						, t.ParticipantsTotal = @ParticipantsTotal
						, t.RegStartTime = @RegistrationStartTime
						, t.RegEndTime = @RegistrationEndTime
						, t.StartTime = @TournamentStartTime
						, t.EndTime = @TournamentEndTime
						, t.ListingLiveDate = @ListingLiveDate
						, t.OnHold = @OnHold
						, t.IsCancelled = @IsCancelled
						, t.LastModifiedOn = GETDATE()
						, t.LastModifiedBy = @ActionedByAdminUserID
						, t.EntryFee_TypeID = @EntryFee_TypeID
						, t.EntryFee_CurrencyID = @EntryFee_CurrencyID
						, t.EntryFee_Units = @EntryFee_Units
						, t.TournamentBannerImageLink = @TournamentBannerImageLink
				FROM	tournament.dtl_tournaments t
				WHERE	t.TournamentID = @TournamentID
				SELECT @UpdateCnt = @@ROWCOUNT

				IF @UpdateCnt <> 1
					BEGIN
						SELECT @ErrMsg = CONCAT('Something''s wrong while updating record. Record count is ', @UpdateCnt, '!');
						THROW 51000, @ErrMsg, 1;
					END

				;MERGE tournament.dtl_prizepool AS TARGET
				USING #Prizes AS SOURCE 
					ON (TARGET.TournamentID = @TournamentID AND TARGET.RankNo = SOURCE.PrizeRank) 
				WHEN MATCHED 
					THEN UPDATE SET TARGET.PrizeTypeID = SOURCE.PrizeTypeID, TARGET.Units = SOURCE.Units 
				WHEN NOT MATCHED BY TARGET 
					THEN	INSERT (TournamentID, RankNo, PrizeTypeID, Units, PrizeDesc) 
							VALUES (@TournamentID, SOURCE.PrizeRank, SOURCE.PrizeTypeID, SOURCE.Units, '')
				WHEN NOT MATCHED BY SOURCE 
					THEN DELETE ;


				SELECT 'Record updated successfully!' AS Msg, 0 AS MsgCode, @TournamentID AS TournamentID
			END

		IF @Action = 'I'
			BEGIN
				DECLARE @TournamentIDNew INT = 0
				INSERT INTO tournament.dtl_tournaments
						([Name], [Desc], GameID, FormatID, RegionID, InfoID, ParticipantsTotal
						, ParticipantsRegistered, RegStartTime, RegEndTime, StartTime, EndTime, ListingLiveDate
						, OnHold, IsCancelled, CreatedOn, CreatedBy
						, EntryFee_TypeID, EntryFee_CurrencyID, EntryFee_Units, TournamentBannerImageLink)
				SELECT	@TournamentName, @TournamentDesc, @GameID, @FormatID, @RegionID, @TournamentInfoID, @ParticipantsTotal
						, 0, @RegistrationStartTime, @RegistrationEndTime, @TournamentStartTime, @TournamentEndTime, @ListingLiveDate
						, @OnHold, @IsCancelled, GETDATE(), @ActionedByAdminUserID
						, @EntryFee_TypeID, @EntryFee_CurrencyID, @EntryFee_Units, @TournamentBannerImageLink
				SELECT @TournamentIDNew = @@IDENTITY

				IF ISNULL(@TournamentIDNew, 0) = 0
					BEGIN
						SELECT @ErrMsg = CONCAT('Something''s wrong while inserting record. New tournament ID is ', ISNULL(@TournamentIDNew, 0), '!');
						THROW 51000, @ErrMsg, 1;
					END

				INSERT INTO tournament.dtl_prizepool
						(TournamentID, RankNo, SubRankNo, PrizeTypeID, Units, PrizeDesc)
				SELECT	@TournamentIDNew, PrizeRank, 1, PrizeTypeID, Units, ''
				FROM	#Prizes
						
				SELECT @TournamentID = @TournamentIDNew

				SELECT 'Record inserted successfully!' AS Msg, 0 AS MsgCode, @TournamentID AS TournamentID
			END

		IF @Action IN ('I', 'U')
			EXEC [tournament].[usp_crud_PrizeDetails_In_Tournament] @TournamentID

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@ROWCOUNT > 0
			ROLLBACK TRANSACTION

		SELECT ERROR_MESSAGE() AS Msg, 2 AS MsgCode, @TournamentID AS TournamentID

	END CATCH

END
