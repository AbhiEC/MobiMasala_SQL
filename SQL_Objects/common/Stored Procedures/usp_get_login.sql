

CREATE PROCEDURE [common].[usp_get_login]
	@UserID VARCHAR(200)
	, @Token VARCHAR(1000)
AS
BEGIN

	DECLARE @TokenMsg VARCHAR(1000) = ''

	EXECUTE common.usp_crud_LoginToken
		@UserID = @UserID
		, @Token = @Token out
		, @TokenMsg = @TokenMsg out

	SELECT	UserID, Pass_word, EmailID, FirstName, MiddleName, LastName, @Token AS Token, @TokenMsg AS TokenState
	FROM	common.dtl_users du
	WHERE	du.UserID = @UserID AND du.Token = @Token
END
