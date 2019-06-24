CREATE PROCEDURE cms.usp_crud_AdminToken_Update
	@UserID INT
	, @Token VARCHAR
AS
BEGIN
	DECLARE @RCnt INT = 0
	UPDATE	du
	SET		Token = @Token, TokenCreatedOn = GETDATE()
	FROM	cms.dtl_users du
	WHERE	du.id = @UserID
	SELECT @RCnt = @@ROWCOUNT

	IF @RCnt = 1
		BEGIN
			SELECT 'Token updated successfully!' AS Msg, 0 AS MsgCode
		END
	ELSE
		BEGIN
			SELECT CONCAT('Something went wrong! RecordCount - ', @RCnt, '!') AS Msg, 1 AS MsgCode
		END
END