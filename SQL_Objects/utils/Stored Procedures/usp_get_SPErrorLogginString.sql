CREATE PROCEDURE utils.usp_get_SPErrorLogginString
	@SP_Name VARCHAR(2000)
AS 
BEGIN
	SELECT	s.name AS SchemaName, p.name AS SPName
			, CONCAT(	'INSERT INTO applog.dtl_CRUDErrors(CallerUserID, CalledSpName, SpParameter_String, SpErrorMsg, SpCalledOn) SELECT '
						, '0', ', ''', CONCAT(PARSENAME(@SP_Name, 2), '.', PARSENAME(@SP_Name, 1)), ''', '
						, 'CONCAT(', STRING_AGG(CONCAT('''', ap.name, ''', '' = '''''', '
						, CASE WHEN t.[name] = 'DATETIME' THEN 'CONVERT(VARCHAR(30), ' ELSE '' END
						, ap.name, CASE WHEN t.[name] = 'DATETIME' THEN ', 121)' ELSE '' END
						, ','''''), ''', '', '), ''''')', ', ', 'ERROR_MESSAGE(), ', 'GETDATE()'
						)
	FROM	sys.procedures p
			INNER JOIN sys.schemas s
				ON p.schema_id = s.schema_id
			INNER JOIN sys.all_parameters ap
				ON ap.object_id = p.object_id
			INNER JOIN sys.types t
				ON t.system_type_id = ap.system_type_id
	WHERE	p.name = PARSENAME(@SP_Name, 1) AND s.name = PARSENAME(@SP_Name, 2) AND t.name <> 'sysname'
	GROUP BY s.name, p.name
END