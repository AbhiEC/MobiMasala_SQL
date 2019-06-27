
CREATE PROCEDURE [common].[usp_crud_login]
	@Action VARCHAR(1) --Options are : I = Insert, U = Update
	, @UserID INT = 0
	, @Token VARCHAR(1000) = ''
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
	DECLARE @ErrorMsg VARCHAR(8000) = 0
	DECLARE @TokenMsg VARCHAR(1000) = ''

	BEGIN TRY
		BEGIN TRANSACTION

		IF @Action = 'I'
			BEGIN
				SELECT @Token = NEWID(), @TokenMsg = 'NEW'

				INSERT INTO common.dtl_users
						(UserName, Pwd, EmailID, FirstName, MiddleName, LastName, CreatedBy, Token, TokenCreatedOn, MobileNumber)
				SELECT	@UserName, @PassWord, @EmailID, @FirstName, @MiddleName, @LastName, 0, @Token, GETDATE(), @MobileNumber
				SET @Identity = @@IDENTITY
			END
		ELSE IF @Action = 'U'
			BEGIN

				EXECUTE common.usp_crud_LoginToken
					@UserID = @UserID
					, @Token = @Token out
					, @TokenMsg = @TokenMsg out

				--SELECT @Token, @TokenMsg

				UPDATE	du
				SET		UserName = @UserName, Pwd = @PassWord, EmailID = @EmailID
						, FirstName = @FirstName, MiddleName = @MiddleName, LastName = @LastName
						, ModifiedBy = 0, ModifiedOn = GETDATE(), MobileNumber = @MobileNumber
				FROM	common.dtl_users du
				WHERE	du.UserID = @UserID AND Token = @Token
				SET @RowCnt = @@ROWCOUNT
			END

		IF (@Action = 'I' AND @Identity > 0) OR (@Action = 'U' AND @RowCnt = 1)
			BEGIN
				SELECT CASE WHEN @Action = 'I' THEN 'User inserted successfully!' WHEN @Action = 'U' THEN 'User Record updated successfully' END AS Msg
						, CASE WHEN @Action = 'I' THEN @Identity WHEN @Action = 'U' THEN @UserID END AS USerID, @Token AS Token, @TokenMsg AS TokenState

				COMMIT TRANSACTION
			END
		ELSE 
			BEGIN
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION

				IF @Action = 'U' AND @RowCnt = 0
					BEGIN
						SELECT 'User does not exists' AS Msg, @UserID AS USerID
					END
				ELSE
					BEGIN
						SELECT @ErrorMsg = CONCAT('Something gone wrong in this operation. Identity : ', @Identity, ', RowCount : ', @RowCnt, '.')
						;THROW 50000, @ErrorMsg, 1;
					END
			END

		RETURN
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		;THROW;
	END CATCH
END
