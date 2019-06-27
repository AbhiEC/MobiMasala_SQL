
CREATE PROCEDURE [cms].[usp_get_cms_login]
	@emailID VARCHAR(100),
	@pwd NVARCHAR(4000)
AS
BEGIN
	DECLARE	@loginMsg VARCHAR(1000) = 'EmailID not found!'
			, @LoginCode smallint = 2
			, @UserID INT
			, @FullName VARCHAR(1000)
			, @cms_role SMALLINT
			, @IsEnabled BIT

	SELECT	@loginMsg = CASE WHEN cdu.Pwd = @pwd THEN 'Login Successful!' ELSE 'EmailID and password combination does not match!' END
			, @LoginCode = CASE WHEN cdu.Pwd = @pwd THEN 0 ELSE 1 END
			, @UserID = cdu.AdminUserID, @FullName = cdu.FullName, @cms_role = cdu.CmsRole, @IsEnabled = cdu.IsEnabled
	FROM	cms.dtl_users cdu
	WHERE	cdu.EmailID = @emailID

	SELECT @loginMsg AS LoginMsg, @LoginCode AS LoginCode, @UserID AS UserID, @FullName AS FullName, @cms_role AS cms_role, @IsEnabled AS IsEnabled

	RETURN 999
END
