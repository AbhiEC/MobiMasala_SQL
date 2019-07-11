CREATE PROCEDURE common.[usp_get_UserName]
	@UserName VARCHAR(200)
AS
BEGIN
	SELECT	du.UserID AS userID, du.UserName AS userName
	FROM	common.dtl_users du
	WHERE	du.UserName = @UserName
END
