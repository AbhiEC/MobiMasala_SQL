
CREATE PROCEDURE [common].[usp_crud_login]
	@Action VARCHAR(1) --Options are : I = Insert, U = Update
	, @UserID INT = 0
	, @UserName VARCHAR(200)
	, @PassWord NVARCHAR(4000)
	, @EmailID VARCHAR(100)
	, @FirstName VARCHAR(200) = ''
	, @MiddleName VARCHAR(200) = ''
	, @LastName VARCHAR(200) = ''
	, @MobileNumber VARCHAR(20) = ''
AS
BEGIN
	DECLARE @Identity INT = 0
	DECLARE @RowCnt INT = 0
	DECLARE @ErrorMsg VARCHAR(8000) = ''
	DECLARE @ErrorCode SMALLINT = 2
	DECLARE @TokenMsg VARCHAR(1000) = ''

	BEGIN TRY
		BEGIN TRANSACTION


		SELECT	@ErrorMsg = REVERSE(SUBSTRING(REVERSE(CASE WHEN du.UserName = @UserName THEN 'Username/' ELSE '' END
				+ CASE WHEN du.EmailID = @EmailID THEN 'Emailid/' ELSE '' END
				+ CASE WHEN du.MobileNumber = @MobileNumber THEN 'MobileNumber/' ELSE '' END), 2, 4000))
				+ ' already exists!'
		FROM	common.dtl_users du
		WHERE	du.UserName = @UserName OR du.EmailID = @EmailID OR du.MobileNumber = @MobileNumber

		IF @ErrorMsg <> ''
			BEGIN
				SELECT @ErrorCode = 1;
				THROW 50000, @ErrorMsg, 1;
			END


		IF @Action = 'I'
			BEGIN
				INSERT INTO common.dtl_users
						(UserName, Pwd, EmailID, FirstName, MiddleName, LastName, CreatedBy, TokenCreatedOn, MobileNumber)
				SELECT	@UserName, @PassWord, @EmailID, @FirstName, @MiddleName, @LastName, 0, GETDATE(), @MobileNumber
				SET @Identity = @@IDENTITY
			END
		ELSE IF @Action = 'U'
			BEGIN
				UPDATE	du
				SET		UserName = @UserName, Pwd = @PassWord, EmailID = @EmailID
						, FirstName = @FirstName, MiddleName = @MiddleName, LastName = @LastName
						, ModifiedBy = 0, ModifiedOn = GETDATE(), MobileNumber = @MobileNumber
				FROM	common.dtl_users du
				WHERE	du.UserID = @UserID
				SET @RowCnt = @@ROWCOUNT
			END

		IF (@Action = 'I' AND @Identity > 0) OR (@Action = 'U' AND @RowCnt = 1)
			BEGIN
				SELECT CASE WHEN @Action = 'I' THEN 'User inserted successfully!' WHEN @Action = 'U' THEN 'User Record updated successfully' END AS Msg
						, CASE WHEN @Action = 'I' THEN @Identity WHEN @Action = 'U' THEN @UserID END AS USerID
						, 0 AS MsgCode
			END
		ELSE 
			BEGIN
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION

				IF @Action = 'U' AND @RowCnt = 0
					BEGIN
						SELECT 'User does not exists' AS Msg, @UserID AS USerID, 1 AS MsgCode
					END
				ELSE
					BEGIN
						SELECT @ErrorMsg = CONCAT('Something gone wrong in this operation. Identity : ', @Identity, ', RowCount : ', @RowCnt, '.')
								, @ErrorMsg = 1
						;THROW 50000, @ErrorMsg, 1;
					END
			END

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SELECT Error_Message() AS Msg, @UserID AS UserID, @ErrorCode AS MsgCode
	END CATCH
END
