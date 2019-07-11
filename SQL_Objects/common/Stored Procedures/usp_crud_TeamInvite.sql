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

	BEGIN TRY
		SELECT	@UserID = du.UserID
		FROM	common.dtl_users du
		WHERE	du.UserName = @InvitedUserName

		IF @UserID IS NULL
			BEGIN
				SELECT	@Msg = 'Username does not exists!', @MsgCode = 1
			END
		ELSE
			BEGIN
				SELECT	@TeamMemberLimit = c.ConfigValue1
				FROM	common.mst_config c
				WHERE	c.ConfigName = 'TeamMemberLimit'

				SELECT	@TeamMemberCount = SUM(MemberCount)
				FROM	(
							SELECT	COUNT(1) AS PendingInvitationsCount
							FROM	common.dtl_UserTeamInvitations uti
							WHERE	uti.TeamID = @TeamID AND uti.IsInvitationAccepted = 0
							UNION ALL
							SELECT	dut.TeamMember_Count AS TeamMemberCount
							FROM	common.dtl_UserTeams dut
							WHERE	dut.TeamID = @TeamID
						) TeamMemberCount(MemberCount)
	
				BEGIN TRANSACTION

				IF @TeamMemberLimit <= @TeamMemberCount
					BEGIN
						SELECT	@Msg = 'Cannot add User as team is full!', @MsgCode = 1
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

		SELECT	@Msg AS msg, @MsgCode AS msgCode

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SELECT ERROR_MESSAGE() AS msg, 2 AS msgCode

	END CATCH
END
