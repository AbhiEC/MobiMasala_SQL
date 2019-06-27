

CREATE PROCEDURE [common].[usp_get_login]
	@UserName VARCHAR(200)
	, @Pwd VARCHAR(1000)
AS
BEGIN

	DECLARE	@loginMsg VARCHAR(1000) = 'UserName not found!'
			, @LoginCode smallint = 2
			, @UserID INT
			, @EmailID VARCHAR(200)
			, @FirstName VARCHAR(1000)
			, @MiddleName VARCHAR(1000)
			, @LastName VARCHAR(1000)
			, @cms_role SMALLINT
			, @IsEnabled BIT
			, @IsBanned BIT
			, @MobileNumber VARCHAR(30)

	SELECT	@loginMsg = CASE WHEN du.Pwd = @Pwd THEN 'Login Successful!' ELSE 'UserName and password combination does not match!' END
			, @LoginCode = CASE WHEN du.Pwd = @Pwd THEN 0 ELSE 1 END, @EmailID = du.EmailID
			, @UserID = du.UserID, @FirstName = du.FirstName, @MiddleName = du.MiddleName, @LastName = du.LastName
			, @IsEnabled = du.IsEnabled, @IsBanned = CASE WHEN ub.ID IS NULL THEN 0 ELSE 1 END, @MobileNumber = du.MobileNumber
	FROM	common.dtl_users du
			LEFT OUTER JOIN common.dtl_users_banned ub
				ON du.UserID = ub.UserID AND ub.IsBanValid = 1 AND GETDATE() BETWEEN ub.BanStart AND ub.BanEnd
	WHERE	du.UserName = @UserName

	SELECT	@loginMsg AS loginMsg, @LoginCode AS LoginCode, @UserID AS UserID, @EmailID AS EmailID, @MobileNumber AS MobileNumber
			, @FirstName AS FirstName, @MiddleName AS MiddleName, @LastName AS LastName, @IsEnabled AS IsEnabled, @IsBanned AS IsBanned

END

