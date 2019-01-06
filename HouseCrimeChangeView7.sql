use [Crime Project]
go

-- Create a View for the Yearly Change in house price and crime
-- Done for efficiency in Tableau
CREATE VIEW VW_CrimeHouse_Change AS (
SELECT
	C.[LSOA Code]
	,YEAR(C.[YEAR]) AS [Year]
	,C.[Crimes Change %]
	,H.[House Price Change %]
FROM DBO.[Crime Count Change VW] C
JOIN DBO.[House Price Change VW] H
	ON H.[LSOA code] = C.[LSOA Code] AND YEAR(C.[YEAR]) = YEAR(H.[YEAR])	-- Same LSOA and SAME YEAR
)