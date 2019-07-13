CREATE FUNCTION [common].[fn_get_TeamDetailsByTeamID]
(
	@TeamID int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @TeamDetails VARCHAR(MAX)
	DECLARE @TeamDetails2 VARCHAR(MAX)


	SELECT	@TeamDetails = 
			(
				SELECT	ut.TeamID AS teamID, ut.TeamName AS teamName, ut.TeamIcon_Link AS teamIconUrl, ut.TeamBanner_Link AS teamBannerUrl
						, 0 AS teamKills, ut.TournamentWon AS tournamentWon, ut.TournamentJoined - ut.TournamentWon AS tournamentLoss
						, CASE WHEN ut.TournamentWon = 0 THEN 0 ELSE (ut.TournamentWon * 100)/ ut.TournamentJoined END AS winRate
						, ut.TeamPrizeWinnings AS teamEarnings, JSON_QUERY(common.fn_get_TeamMembersWithPendingInvites(ut.TeamID)) AS teamMemberList
				FROM	common.dtl_UserTeams ut
				WHERE	ut.TeamID = @TeamID
				FOR JSON PATH
			)

	SELECT	@TeamDetails2 = JSON_QUERY(VALUE)
	FROM	OPENJSON(@TeamDetails)

	RETURN @TeamDetails2
END
