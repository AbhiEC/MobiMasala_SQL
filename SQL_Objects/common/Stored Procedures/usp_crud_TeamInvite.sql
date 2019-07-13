CREATE PROCEDURE common.[usp_crud_TeamInvite]
	@GameID SMALLINT = 1
	, @TeamID INT
	, @InvitedUserName VARCHAR(200)
	, @CreatorUserID INT
AS
BEGIN
	DECLARE @TeamMemberCount SMALLINT = 0
	DECLARE @TeamMemberLimit SMALLINT = 0
	DECLARE @TeamMemberExists BIT = 0
	DECLARE @InvitationID INT = 0
	DECLARE @UserID INT
	DECLARE @MsgCode SMALLINT = 2
	DECLARE @Msg VARCHAR(2000) = ''
	DECLARE @IsUserAlreadyInvited BIT = 0
	DECLARE @IsUserAlreadyInTeam BIT = 0
	DECLARE @PendingInvitationsCount INT = 0
	DECLARE @TeamMemberInTeamCount INT = 0
	DECLARE @TeamMemberAlreadyInTeam BIT = 0



	BEGIN TRY
		SELECT	@UserID = du.UserID
		FROM	common.dtl_users du
		WHERE	du.UserName = @InvitedUserName

		SELECT	@IsUserAlreadyInvited = MAX(CASE WHEN uti.TeamMemberUserID = @UserID THEN 1 ELSE 0 END)
				, @PendingInvitationsCount = COUNT(1)
		FROM	common.dtl_UserTeamInvitations uti
		WHERE	uti.TeamID = @TeamID AND uti.IsInvitationAccepted = 0 AND uti.IsInvitationCanceled = 0

		SELECT	@TeamMemberInTeamCount = COUNT(1)
				, @TeamMemberAlreadyInTeam = MAX(CASE WHEN utm.TeamMemberUserID = @UserID THEN 1 ELSE 0 END)
		FROM	common.dtl_UserTeamMember utm
		WHERE	utm.TeamID = @TeamID

		IF @UserID IS NULL
			BEGIN
				SELECT	@Msg = 'Username does not exists!', @MsgCode = 1
			END
		ELSE IF @IsUserAlreadyInvited = 1
			BEGIN
				SELECT	@Msg = 'User already invited for the same team!', @MsgCode = 1
			END
		ELSE IF @TeamMemberAlreadyInTeam = 1
			BEGIN
				SELECT	@Msg = 'User already in team!', @MsgCode = 1
			END
		ELSE
			BEGIN
				SELECT	@TeamMemberLimit = c.ConfigValue1
				FROM	common.mst_config c
				WHERE	c.ConfigName = 'TeamMemberLimit'

				SELECT	@TeamMemberCount = @TeamMemberInTeamCount + @PendingInvitationsCount
	
				BEGIN TRANSACTION

				IF @TeamMemberLimit <= @TeamMemberCount
					BEGIN
						SELECT	@Msg = CONCAT('Cannot add User as team is full. Max member count in a team is ', @TeamMemberLimit, '!'), @MsgCode = 1
					END
				ELSE
					BEGIN
						INSERT INTO common.dtl_UserTeamInvitations
								(TeamID, TeamMemberUserID, InviterUserID, InvitedOn, IsInvitationCanceled, IsInvitationAccepted, IsTeamMemberKickedOut)
						SELECT	@TeamID, @UserID, @CreatorUserID, GETDATE(), 0, 0, 0
						SELECT	@InvitationID = SCOPE_IDENTITY()

						IF @InvitationID > 0
							BEGIN
								SELECT	@Msg = 'User added successfully to the team!', @MsgCode = 0
							END
						ELSE
							BEGIN
								SELECT	@Msg = CONCAT('Something went wrong, the user was not added to the team. @InvitationID:', @InvitationID), @MsgCode = 2;
								THROW 51000, @Msg, 1;
							END
					END
				END

		SELECT	@Msg AS msg, @MsgCode AS msgCode, JSON_QUERY(common.fn_get_TeamMembersWithPendingInvites(@TeamID)) AS teamMemberList
		FOR JSON PATH

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SELECT ERROR_MESSAGE() AS msg, 2 AS msgCode, JSON_QUERY(common.fn_get_TeamMembersWithPendingInvites(@TeamID)) AS teamMemberList
		FOR JSON PATH

	END CATCH
END
