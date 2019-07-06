CREATE FUNCTION [dbo].[fn_get_CheckTeamNameExists]
(
	@TeamName NVARCHAR(2000)
)
RETURNS SMALLINT
AS
BEGIN
	DECLARE @DoesTeamExists SMALLINT = 1

	SELECT	@DoesTeamExists = 0
	FROM	common.dtl_UserTeams dut
	WHERE	dut.TeamName = @TeamName

	RETURN @DoesTeamExists
END
