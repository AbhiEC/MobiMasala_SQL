
CREATE PROCEDURE [cms].[usp_get_cms_login_New]
	@emailID VARCHAR(100)
AS
BEGIN
	SELECT	cdu.AdminUserID AS UserID, cdu.EmailID, cdu.Pwd, cdu.FullName, cdu.CmsRole, cdu.IsEnabled
	FROM	cms.dtl_users cdu
	WHERE	cdu.EmailID = @emailID AND cdu.IsEnabled = 1

	RETURN 99

END
