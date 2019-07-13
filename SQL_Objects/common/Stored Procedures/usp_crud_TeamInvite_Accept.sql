CREATE PROCEDURE [common].[usp_crud_TeamInvite_Accept]
	@TeamInvitationID INT
AS
BEGIN
	DECLARE @ErrorMsg VARCHAR(8000) = ''
	DECLARE @IsInviteAlreadyAccepted BIT = 0
	DECLARE @MsgCode SMALLINT = 2
	DECLARE @Msg VARCHAR(2000) = ''
	DECLARE @UserTeamCount INT = 0
	DECLARE @TeamJoiningLimit INT = 0
	DECLARE @InvitedUserID INT = 0
	DECLARE @TeamID INT = 0
	DECLARE @CancelPendingInvites BIT = 0
	DECLARE @TeamMemberAlreadyInTeam BIT = 0

	DECLARE @InvitationUpdateCnt INT = 0
	DECLARE @TeamMemberInsertCnt INT = 0

	SELECT	@TeamJoiningLimit = ConfigValue1
	FROM	common.mst_config
	WHERE	ConfigName = 'UserTeamLimit'

	SELECT	@CancelPendingInvites = ConfigValue1
	FROM	common.mst_config
	WHERE	ConfigName = 'CancelPendingInvitesTeamLimit'

	SELECT	@IsInviteAlreadyAccepted = uti.IsInvitationAccepted, @InvitedUserID = uti.TeamMemberUserID
			, @TeamID = uti.TeamID
	FROM	common.dtl_UserTeamInvitations uti
	WHERE	uti.TeamInvitationID = @TeamInvitationID

	SELECT	@UserTeamCount = COUNT(1), @TeamMemberAlreadyInTeam = MAX(CASE WHEN utm.TeamID = @TeamID THEN 1 ELSE 0 END)
	FROM	common.dtl_UserTeamMember utm
	WHERE	utm.TeamMemberUserID = @InvitedUserID

	BEGIN TRY
		IF @IsInviteAlreadyAccepted = 1
			BEGIN
				SELECT	@Msg = 'User already invited for the same team!', @MsgCode = 1
			END
		ELSE IF @TeamMemberAlreadyInTeam = 1
			BEGIN
				SELECT	@Msg = 'User already in the same team!', @MsgCode = 1
			END
		ELSE IF	1 = (CASE WHEN @TeamJoiningLimit = 0 THEN 0 WHEN @TeamJoiningLimit > @UserTeamCount THEN 0 ELSE 1 END)
			BEGIN
				SELECT	@Msg = CONCAT('Cannot join team as User is/will be associated with team beyond limt of ', @TeamJoiningLimit, '!')
						, @MsgCode = 1
			END
		ELSE
			BEGIN
				BEGIN TRANSACTION

				UPDATE	uti
				SET		IsInvitationAccepted = 1, InvitationAcceptedOn = GETDATE(), Comments = 'User triggered acceptance; '
				FROM	common.dtl_UserTeamInvitations uti
				WHERE	uti.TeamInvitationID = @TeamInvitationID
				SELECT	@InvitationUpdateCnt = @@ROWCOUNT

				INSERT INTO common.dtl_UserTeamMember
						(TeamID, TeamMemberUserID, TeamInvitationID, CreatedBy)
				SELECT	@TeamID, @InvitedUserID, @TeamInvitationID, @InvitedUserID
				SELECT	@TeamMemberInsertCnt = @@ROWCOUNT

				IF @CancelPendingInvites = 1 AND @TeamJoiningLimit = @UserTeamCount + 1
					BEGIN
						UPDATE	uti
						SET		IsInvitationCanceled = 1, InvitationCanceledOn = GETDATE(), InvitationCanceledByUserID = 0
								, Comments = 'Auto cancelled pending events due to "CancelPendingInvitesTeamLimit" configuration; '
						FROM	common.dtl_UserTeamInvitations uti
						WHERE	uti.IsInvitationAccepted = 0 AND uti.IsInvitationCanceled = 0

					END

				IF @InvitationUpdateCnt = 1 AND @TeamMemberInsertCnt = 1
					BEGIN
						COMMIT TRANSACTION

						SELECT	@Msg = 'Invitation accepted successfully!', @MsgCode = 0
					END
				ELSE
					BEGIN
						SELECT	@ErrorMsg = CONCAT('CRUD record audit does not match. @InvitationUpdateCnt = '
													, @InvitationUpdateCnt, '; @TeamMemberInsertCnt = ', @TeamMemberInsertCnt, '!');
						
						THROW 51000, @ErrorMsg, 1;
					END
			END

		SELECT	@Msg AS msg, @MsgCode AS msgCode--, JSON_QUERY(common.fn_get_TeamMembersWithPendingInvites(@TeamID)) AS teamMemberList
		FOR JSON PATH
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SELECT	'Something went wrong while updating records. Please contact administrator or try later!' AS msg, 2 AS msgCode
		FOR JSON PATH

	END CATCH

END
