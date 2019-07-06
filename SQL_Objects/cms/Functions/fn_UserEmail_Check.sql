
CREATE FUNCTION [cms].[fn_UserEmail_Check]
(
	@EmailID VARCHAR(200)
)
RETURNS INT
AS
BEGIN
	DECLARE @DoesEmailExists SMALLINT = 1
	
	SELECT	@DoesEmailExists = 0
	FROM	common.dtl_users cdu
	WHERE	cdu.EmailID = @EmailID

	-- Return the result of the function
	RETURN @DoesEmailExists

END