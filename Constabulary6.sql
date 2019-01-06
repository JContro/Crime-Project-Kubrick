USE [Crime Project]
GO
/*
Create a table which relates each LSOA with a Constabulary
*/
WITH CTE AS
(
SELECT	
	[LSOA Code]
	,[FALLS WITHIN] AS [Constabulary]
	,COUNT(*) AS [REPORTS]				-- Count the reports in the LSOA by CONSTABULARY
FROM STAGE.[Crime data]
WHERE [LSOA code] != ''
GROUP BY [LSOA CODE],[FALLS WITHIN]


)
, CTE2 AS
(
SELECT 
	[LSOA CODE]
	,MAX([REPORTS]) AS [MAX REPORTS]	-- Select the constabulary that responded the most
FROM CTE
GROUP BY [LSOA CODE]
)

SELECT DISTINCT
	CAST(B.[LSOA CODE] AS VARCHAR(100)) AS [LSOA Code]
	,CAST(A.Constabulary AS VARCHAR(200)) AS [Constabulary]
	--INTO CLEAN.[LSOA to Constabulary]
FROM CTE A								-- Join the two tables together to keep only the constabulary which most responded to the LSOA
LEFT JOIN CTE2 B
	ON A.[REPORTS] = B.[MAX REPORTS] AND A.[LSOA CODE] = B.[LSOA CODE] and A.[LSOA code] is not null


