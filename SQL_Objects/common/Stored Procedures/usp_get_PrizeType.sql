CREATE PROCEDURE common.[usp_get_PrizeType]
	@PrizeTypeID SMALLINT
AS
BEGIN
	SELECT	pt.PrizeTypeID AS PrizeTypeID, pt.PrizeName AS PrizeName
	FROM	common.mst_PrizeType pt
	WHERE	(	@PrizeTypeID = 0 OR pt.PrizeTypeID = @PrizeTypeID	)
END