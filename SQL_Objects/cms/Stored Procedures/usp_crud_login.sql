CREATE PROCEDURE cms.usp_crud_login
	@emailID VARCHAR(100),
	@pwd NVARCHAR(4000),
	@FullName VARCHAR(1000)
AS
BEGIN
	INSERT INTO cms.dtl_users
			(emailId, pwd, FullName, cms_role)
	SELECT	@emailID, @pwd, @FullName, 1

	IF @@ROWCOUNT = 1
		SELECT 'Record added successful!' AS ResponseMsg
	ELSE
		SELECT 'Something is not right' AS ResponseMsg
END;