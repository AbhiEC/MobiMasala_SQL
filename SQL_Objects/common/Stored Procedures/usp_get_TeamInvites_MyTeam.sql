CREATE PROCEDURE [common].[usp_get_TeamInvites_MyTeam]
	@UserID int
AS
BEGIN
	DECLARE @TeamID INT = 0
	DECLARE @TeamInvitation_JSON VARCHAR(MAX)
	DECLARE @TeamPrize_JSON NVARCHAR(4000)
	DECLARE @TeamMemberLimit INT = 0

	SELECT @TeamID = utm.TeamID FROM common.dtl_UserTeamMember utm WHERE utm.TeamMemberUserID = @UserID

	SELECT	@TeamMemberLimit = c.ConfigValue1 
	FROM	common.mst_config c
	WHERE	c.ConfigName = 'TeamMemberLimit'

	SELECT @TeamInvitation_JSON = 
	(SELECT	uti.TeamInvitationID AS teamInvitationID, ut.TeamName AS teamName, ut.TeamMember_Count AS teamMemberCount
			, ut.TournamentWon AS tournamentWon, ut.TournamentJoined - ut.TournamentWon AS tournamentLoss
			, CASE WHEN ut.TournamentWon = 0 THEN 0 ELSE (ut.TournamentWon * 100)/ ut.TournamentJoined END AS winRate
			, ut.TeamIcon_Link AS teamIconUrl
	FROM	common.dtl_UserTeams ut
			INNER JOIN common.dtl_UserTeamInvitations uti
				ON uti.TeamID = ut.TeamID
	WHERE	uti.TeamMemberUserID = @UserID AND uti.IsInvitationAccepted = 0
	FOR JSON PATH)

	SELECT JSON_QUERY(@TeamInvitation_JSON) AS teamInvitation, @TeamMemberLimit AS teamMemberLimit, JSON_QUERY(common.fn_get_TeamDetailsByTeamID(@TeamID)) AS myTeamDetail
	FOR JSON PATH
END