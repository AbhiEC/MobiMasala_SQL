CREATE FUNCTION [dbo].[fn_get_TeamMembers]
(
	@TeamID int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @TeamMembers_JSON VARCHAR(MAX) = ''

	SELECT @TeamMembers_JSON = 
	(	
		SELECT	u.UserID AS userID, u.UserName AS userName, u.UserAvataarUrl AS userAvataarUrl
		FROM	common.dtl_UserTeamMember utm
				INNER JOIN common.dtl_users u
					ON utm.TeamMemberUserID = u.UserID
		WHERE	utm.TeamID = @TeamID
		FOR JSON PATH
	)

	RETURN @TeamMembers_JSON
END
