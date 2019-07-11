CREATE PROCEDURE common.[usp_get_Currency]
	@CurrencyID SMALLINT
AS
BEGIN
	SELECT	c.CurrencyID AS CurrencyID, c.CurrencyName AS CurrencyName, c.CurrencyShortName AS CurrencyShortName
			, c.CurrencySymbol AS CurrencySymbol, cpl.PrizeTypeID
	FROM	common.mst_currency c
			LEFT OUTER JOIN common.mst_Currency_PrizeType_Linking cpl
				ON c.CurrencyID = cpl.CurrencyID
	WHERE	(		@CurrencyID = 0 
				OR	c.CurrencyID = @CurrencyID	) 
			AND c.IsListable = '1'
END