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

	BEGIN TRY
		BEGIN TRANSACTION

		IF @Action = 'I'
			BEGIN
				INSERT INTO common.dtl_UserTeams
						(TeamName, GameID, TeamIcon_Link, TeamBanner_Link, CreatedByUserID)
				SELECT	@TeamName, @GameID, @TeamIcon_Link, @TeamBanner_Link, @CreatorUserID
				SELECT	@NewTeamID = SCOPE_IDENTITY()

				INSERT INTO common.dtl_UserTeamInvitations
						(TeamID, TeamMemberUserID, InviterUserID, InvitedOn, IsInvitationCanceled, IsInvitationAccepted, IsTeamMemberKickedOut)
				SELECT	@NewTeamID, @CreatorUserID, @CreatorUserID, GETDATE(), 0, 1, 0
				SELECT	@InvitationID = SCOPE_IDENTITY()

				INSERT INTO common.dtl_UserTeamMember
						(TeamID, TeamMemberUserID, TeamInvitationID, CreatedBy, CreatedOn)
				SELECT	@NewTeamID, @CreatorUserID, @InvitationID, @CreatorUserID, GETDATE()
				SELECT @Insert_dtl_UserTeamMember_Cnt = @@ROWCOUNT

				IF @NewTeamID <> 0 OR @InvitationID <> 0 OR @Insert_dtl_UserTeamMember_Cnt <> 1
					BEGIN
						

					END
			END
		ELSE IF @Action = 'U'
			BEGIN
				UPDATE	dtu
				SET		TeamIcon_Link = @TeamIcon_Link, TeamBanner_Link = @TeamBanner_Link
				FROM	common.dtl_UserTeams dtu
				WHERE	dtu.TeamID = @TeamID
				SELECT @UpdateRowCnt = @@ROWCOUNT
			END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION


	END CATCH
END


