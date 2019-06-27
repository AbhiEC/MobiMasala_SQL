
CREATE PROCEDURE [common].[usp_get_UserDetail]
	@UserID VARCHAR(200)
AS
BEGIN

	SELECT	du.UserID, du.Pwd, du.EmailID, du.FirstName, du.MiddleName, du.LastName, MobileNumber
			, CASE WHEN ban.ID IS NULL THEN 'N' ELSE 'Y' END AS IsBanned, ban.BanStart, ban.BanEnd, ban.BanReason
	FROM	common.dtl_users du
			LEFT OUTER JOIN common.dtl_users_banned ban
				ON du.UserID = ban.UserID AND GETDATE() BETWEEN ban.BanStart and ban.BanEnd
	WHERE	du.UserID = @UserID
END
