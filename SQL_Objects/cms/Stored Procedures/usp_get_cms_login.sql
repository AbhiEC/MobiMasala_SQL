
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

	SELECT	@loginMsg = CASE WHEN cdu.pwd = @pwd THEN 'Login Successful!' ELSE 'EmailID and password combination does not match!' END
			, @LoginCode = CASE WHEN cdu.pwd = @pwd THEN 0 ELSE 1 END
			, @UserID = cdu.id, @FullName = cdu.FullName, @cms_role = cdu.cms_role, @IsEnabled = cdu.isenabled
	FROM	CMS.dtl_users cdu
	WHERE	cdu.emailId = @emailID

	SELECT @loginMsg AS LoginMsg, @LoginCode AS LoginCode, @UserID AS UserID, @FullName AS FullName, @cms_role AS cms_role, @IsEnabled AS IsEnabled

	RETURN 999
END
