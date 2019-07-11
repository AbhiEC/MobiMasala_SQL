CREATE PROCEDURE [common].[usp_crud_Team]
	@Action VARCHAR(1)	--Options supported 'I', 'U'
	, @TeamID INT = 0
	, @GameID SMALLINT
	, @TeamName NVARCHAR(2000)
	, @TeamIcon_Link VARCHAR(2000)
	, @TeamBanner_Link VARCHAR(2000)
	, @CreatorUserID INT
AS
BEGIN
	DECLARE @InvitationID INT = 0
	DECLARE @NewTeamID INT = 0
	DECLARE @Insert_dtl_UserTeamMember_Cnt SMALLINT = 0
	DECLARE @UpdateRowCnt SMALLINT = 0
	DECLARE @ErrorMsg VARCHAR(4000) = ''
	DECLARE @MsgCode SMALLINT = 2

	BEGIN TRY
		IF @Action = 'I'
			BEGIN
				IF EXISTS(SELECT 1 FROM common.dtl_UserTeams dut WHERE dut.TeamName = @TeamName)
					BEGIN
						SELECT 'Team name already exists!' AS msg, 1 AS msgCode, @TeamID AS teamID
						RETURN
					END
				ELSE
					BEGIN
						BEGIN TRANSACTION

						INSERT INTO common.dtl_UserTeams
								(TeamName, GameID, TeamIcon_Link, TeamBanner_Link, CreatedByUserID, TeamMember_Count)
						SELECT	@TeamName, @GameID, @TeamIcon_Link, @TeamBanner_Link, @CreatorUserID, 1
						SELECT	@NewTeamID = SCOPE_IDENTITY()

						INSERT INTO common.dtl_UserTeamInvitations
								(TeamID, TeamMemberUserID, InviterUserID, InvitedOn, IsInvitationCanceled, IsInvitationAccepted, IsTeamMemberKickedOut)
						SELECT	@NewTeamID, @CreatorUserID, @CreatorUserID, GETDATE(), 0, 1, 0
						SELECT	@InvitationID = SCOPE_IDENTITY()

						INSERT INTO common.dtl_UserTeamMember
								(TeamID, TeamMemberUserID, TeamInvitationID, CreatedBy, CreatedOn)
						SELECT	@NewTeamID, @CreatorUserID, @InvitationID, @CreatorUserID, GETDATE()
						SELECT @Insert_dtl_UserTeamMember_Cnt = @@ROWCOUNT

						IF @NewTeamID <> 0 OR @InvitationID <> 0 OR @Insert_dtl_UserTeamMember_Cnt = 1
							BEGIN
								COMMIT TRANSACTION

								SELECT 'Team created successfully.' AS msg, 0 AS msgCode, @NewTeamID AS teamID
							END
						ELSE
							BEGIN
								SELECT @ErrorMsg = CONCAT(	'Something went wrong while inserting record. @NewTeamID = '
															, @NewTeamID, '; @InvitationID = ', @InvitationID, '; @Insert_dtl_UserTeamMember_Cnt = ', @Insert_dtl_UserTeamMember_Cnt);

								THROW 50000, @ErrorMsg, 1; 
							END

						COMMIT TRANSACTION
					END
			END
		ELSE IF @Action = 'U'
			BEGIN
				BEGIN TRANSACTION

				UPDATE	dtu
				SET		TeamIcon_Link = @TeamIcon_Link, TeamBanner_Link = @TeamBanner_Link
				FROM	common.dtl_UserTeams dtu
				WHERE	dtu.TeamID = @TeamID
				SELECT @UpdateRowCnt = @@ROWCOUNT

				IF @UpdateRowCnt = 1
					BEGIN
						COMMIT TRANSACTION
					END
				ELSE
					BEGIN
						SELECT @ErrorMsg = CONCAT(	'Something went wrong while Updating record. @UpdateRowCnt = ', @UpdateRowCnt);

						THROW 50000, @ErrorMsg, 1; 
					END
				

				SELECT 'Team updated successfully.' AS msg, 0 AS msgCode, @TeamID AS teamID
			END

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SELECT @ErrorMsg AS msg, @MsgCode AS msgCode, @TeamID AS teamID

	END CATCH
END


