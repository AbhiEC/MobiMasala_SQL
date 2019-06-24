
CREATE PROCEDURE [cms].[usp_get_cms_login_New]
	@emailID VARCHAR(100)
AS
BEGIN
	SELECT	cdu.AdminUserID AS UserID, cdu.emailId, cdu.pwd, cdu.FullName, cdu.cms_role, cdu.isenabled
	FROM	cms.dtl_users cdu
	WHERE	cdu.emailId = @emailID AND cdu.isenabled = 1

	RETURN 99

END
