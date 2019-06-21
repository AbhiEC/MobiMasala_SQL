

CREATE PROCEDURE [cms].[usp_crud_GameUser_Details_bkp]
	@UserID INT = 0
	, @EmailID VARCHAR(100)
	, @FirstName VARCHAR(200) = ''
	, @MiddleName VARCHAR(200) = ''
	, @LastName VARCHAR(200) = ''
	, @MobileNumber VARCHAR(20)
	, @AdminUserID INT
AS
BEGIN
DECLARE @RowCount INT = 0

BEGIN TRY
	BEGIN TRANSACTION

	UPDATE	du
	SET		EmailID = @EmailID
			, FirstName = @FirstName, MiddleName = @MiddleName, LastName = @LastName
			, ModifiedBy = @AdminUserID, ModifiedOn = GETDATE(), MobileNumber = @MobileNumber
	FROM	common.dtl_users du
	WHERE	du.UserID = @UserID
	SELECT @RowCount = @@ROWCOUNT

	IF @@ROWCOUNT = 1
		BEGIN
			SELECT 'Record updated successfully' AS Msg, 0 AS MsgCode
		END
	ELSE
		BEGIN
			SELECT CONCAT('Error while updating. Record count - ', @RowCount, '.') AS Msg, 1 AS MsgCode
		END

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION

	SELECT 'Error while updating : ' + ERROR_MESSAGE() AS Msg, 2 AS MsgCode

END CATCH
END






