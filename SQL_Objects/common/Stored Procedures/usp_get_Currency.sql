CREATE PROCEDURE common.[usp_get_Currency]
	@CurrencyID SMALLINT
AS
BEGIN
	SELECT	c.CurrencyID AS CurrencyID, c.CurrencyName AS CurrencyName, c.CurrencyShortName AS CurrencyShortName
			, c.CurrencySymbol AS CurrencySymbol
	FROM	common.mst_currency c
	WHERE	(	@CurrencyID = 0 OR c.CurrencyID = @CurrencyID	)
END