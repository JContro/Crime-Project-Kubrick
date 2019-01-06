use [Crime Project]
go
/*
NEW TABLE VIEW TIME!!
*/


WITH CTE1 AS (

-- Join the Nearest Neighbours, Deprivation and Crime change tables/view on the LSOA codes
-- Create the average crime change for the closest LSOAs (1-5)
SELECT 
	NN.[Base LSOA Code]
	,NN.[Base LSOA Name]
	,AVG(C.[Crimes Change %]) AS [(1-5) Average NN Yearly Crime Change %]
FROM clean.[LSOA Nearest Neighbour] NN
JOIN clean.[Deprivation 2015 London] D
	ON NN.[Base LSOA Code] = D.[LSOA Code]
JOIN [Crime Count Change VW] C
	ON NN.[Neigh LSOA Code] = C.[LSOA Code]
WHERE YEAR(C.YEAR) > 2014 AND NN.[Rank] <6 
GROUP BY NN.[Base LSOA Code], NN.[Base LSOA Name]

), CTE2 AS (
-- Join the Nearest Neighbours, Deprivation and Crime change tables/view on the LSOA codes
-- Create the average crime change for the further LSOAs (5-10)
SELECT 
	NN.[Base LSOA Code]
	,NN.[Base LSOA Name]
	,AVG(C.[Crimes Change %]) AS [(5-10) Average NN Yearly Crime Change %]
FROM clean.[LSOA Nearest Neighbour] NN
JOIN clean.[Deprivation 2015 London] D
	ON NN.[Base LSOA Code] = D.[LSOA Code]
JOIN [Crime Count Change VW] C
	ON NN.[Neigh LSOA Code] = C.[LSOA Code]
WHERE YEAR(C.YEAR) > 2014 AND NN.[Rank] > 5 
GROUP BY NN.[Base LSOA Code], NN.[Base LSOA Name]
)

-- Create the resulting table by adding the cte2 columns (5-10)
SELECT 
	CTE1.[Base LSOA Code]
	,CTE1.[Base LSOA Name]
	,CTE1.[(1-5) Average NN Yearly Crime Change %]
	,CTE2.[(5-10) Average NN Yearly Crime Change %]
	INTO ANALYSIS.[NN Crime Change LDN]
FROM CTE1
JOIN CTE2
	ON CTE1.[Base LSOA Code] = CTE2.[Base LSOA Code]

