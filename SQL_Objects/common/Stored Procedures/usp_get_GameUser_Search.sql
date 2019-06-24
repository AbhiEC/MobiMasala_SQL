

CREATE PROCEDURE [common].[usp_get_GameUser_Search]
	@SearchColumnName VARCHAR(200) -- Currently supported values : "UserID", "UserName", "EmailID", '<blank>'
	, @SearchValue VARCHAR(200) --Search values should be beginning part of the value or complete. In-between string search is not available for avoiding performance issues.
	, @PageNumber INT = 1
	, @PageSize INT = 20
AS
BEGIN
	SELECT	du.UserID, du.UserName, du.EmailID, du.FirstName, du.MiddleName, du.LastName, du.IsEnabled
			, du.MobileNumber, CASE WHEN ban.ID IS NULL THEN 'N' ELSE 'Y' END AS IsBanned
	FROM	common.dtl_users du
			LEFT OUTER JOIN common.dtl_users_banned ban
				ON du.UserID = ban.UserID AND GETDATE() BETWEEN ban.BanStart and ban.BanEnd
	WHERE	(@SearchColumnName = 'UserID' AND CAST(du.UserID AS VARCHAR(20)) = @SearchValue)
			OR (@SearchColumnName = 'UserName' AND du.UserName like @SearchValue + '%')
			OR (@SearchColumnName = 'EmailID' AND du.EmailID like @SearchValue + '%')
			OR (@SearchColumnName = '')
	ORDER BY du.UserID DESC
	OFFSET @PageSize * (@PageNumber - 1) ROWS
	FETCH NEXT @PageSize ROWS ONLY

END
