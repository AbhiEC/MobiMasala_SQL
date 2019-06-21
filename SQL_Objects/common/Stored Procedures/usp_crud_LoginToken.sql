

CREATE PROCEDURE common.usp_crud_LoginToken
	@UserID INT
	, @Token VARCHAR(200) OUTPUT
	, @TokenMsg VARCHAR(1000) OUTPUT
AS
BEGIN
	DECLARE @TokenRefreshal INT, @TokenOld VARCHAR(200)
	SELECT	@TokenOld = @Token, @TokenMsg = ''

	SELECT	@TokenRefreshal = ConfigValue1
	FROM	common.mst_config
	WHERE	ConfigName = 'TokenRefreshal'

	SELECT	@Token = CASE WHEN x.TokenState = 'NEW' THEN NEWID() ELSE @Token END
			, @TokenMsg = x.TokenState
	FROM	common.dtl_users du
			OUTER APPLY ( SELECT CASE WHEN DATEADD(MINUTE, @TokenRefreshal, du.TokenCreatedOn) > GETDATE() THEN 'OLD' ELSE 'NEW' END AS TokenState) X
	WHERE	du.UserID = @UserID AND du.Token = @TokenOld

	IF @TokenMsg = 'NEW'
		BEGIN
			UPDATE	du
			SET		Token = @Token, TokenCreatedOn = GETDATE()
			FROM	common.dtl_users du
			WHERE	du.UserID = @UserID AND du.Token = @TokenOld
		END
END


