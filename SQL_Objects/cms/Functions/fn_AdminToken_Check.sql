
CREATE FUNCTION [cms].[fn_AdminToken_Check]
(
	@Token VARCHAR(200)
)
RETURNS INT
AS
BEGIN
	DECLARE @AdminUserID INT = 0
	
	SELECT	@AdminUserID = du.AdminUserID
	FROM	cms.dtl_users du
	WHERE	du.Token = @Token

	-- Return the result of the function
	RETURN @AdminUserID

END