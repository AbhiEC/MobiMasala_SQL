CREATE FUNCTION common.[fn_get_TeamMembersWithPendingInvites]
(
	@TeamID INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @TeamMembers_JSON VARCHAR(MAX) = ''

	;WITH CTE AS
		(
			SELECT	utm.TeamMemberUserID AS userID, CAST(1 AS BIT) AS isInviteAccepted
			FROM	common.dtl_UserTeamMember utm
			WHERE	utm.TeamID = 1
			UNION
			SELECT	uti.TeamMemberUserID, uti.IsInvitationAccepted AS isInviteAccepted
			FROM	common.dtl_UserTeamInvitations uti
			WHERE	uti.TeamID  = 1 AND uti.IsInvitationAccepted = 0 AND uti.IsInvitationCanceled = 0
		)
	SELECT @TeamMembers_JSON = 
	(
		SELECT	c.userID AS userID, u.UserName AS userName, u.UserAvataarUrl AS userAvataarUrl, c.isInviteAccepted AS isInviteAccepted
		FROM	CTE c
					INNER JOIN common.dtl_users u
						ON c.userID = u.UserID
		FOR JSON PATH
	)

	RETURN @TeamMembers_JSON
END
