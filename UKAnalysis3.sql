

USE [Crime Project]
GO


/*
Create a table called analysis.[Crime Count LSOA] which contains the number of crimes recorded by LSOA and year
*/

SELECT 
	[LSOA Code]
	,[LSOA Name]
	,[YEAR]
	,COUNT(*) AS [Crimes]
	INTO ANALYSIS.[Crime Count LSOA]
FROM CLEAN.[Crime Data]
GROUP BY [LSOA Code],[LSOA Name],[YEAR]
GO 


 
/*
Created a view which has the year on year percenatge change in total crimes recorded, by LSOA. 
Use LAG to get the crime value of the previous year (by partitioning by LSOA and ordering by year).
Discard 2011 because the crime reports from 2010 are not complete and therefor there are year on year
changes in the thousands %.
*/
GO
ALTER VIEW [Crime Count Change VW] AS
WITH CTE
AS
(
SELECT 
	[LSOA Code]
	,[LSOA Name]
	,[YEAR]
	,LAG([YEAR],1) OVER (PARTITION BY [LSOA CODE] ORDER BY year([YEAR])) AS [Previous Year]
	,CAST([Crimes] AS FLOAT) AS	[Crimes]
	,CAST(LAG([CRIMES],1,0) OVER (PARTITION BY [LSOA CODE] ORDER BY year([YEAR])) AS FLOAT) AS [Previous Year Crimes]
FROM Analysis.[Crime Count LSOA]

), CTE2 AS(
SELECT
	[LSOA Code]
	,[LSOA Name]
	,[YEAR]
	,[Previous Year]
	,Crimes
	,[Previous Year Crimes]
	,([CRIMES] - [Previous Year Crimes])/[Previous Year Crimes]*100 AS [Crimes Change %]
	INTO Analysis.[Crime Count Change]
FROM CTE
WHERE [Previous Year Crimes] != 0 and  DATEDIFF(YEAR,[PREVIOUS YEAR],[YEAR]) =1 and [year] > '2012-01-01'
)
SELECT
	*
	,AVG([Crimes Change %]) OVER (PARTITION BY [LSOA CODE]) AS [Average Crimes Change 2012-2018 %]
FROM CTE2
GO


-- Do not save an analysis table, but keep the view
ALTER SCHEMA TRASH
	TRANSFER ANALYSIS.[CRIME COUNT CHANGE]
-------------
GO

-- Create a view of the Yearly house price change
CREATE VIEW [House Price Change VW] AS
WITH CTE
AS
(
SELECT [LSOA code]
      ,[LSOA name]
      ,[Year]
      ,[Mean House Price]
	  ,CAST(LAG([MEAN HOUSE PRICE],1,0) OVER (PARTITION BY [LSOA CODE] ORDER BY YEAR([YEAR])) AS FLOAT) AS [Previous Year House Price]
  FROM [Analysis].[Mean House Price]
),

CTE2 AS
(
SELECT [LSOA code]
      ,[LSOA name]
      ,[Year]
	  ,([Mean House Price] - [Previous Year House Price])/[Previous Year House Price]*100 AS [House Price Change %]
  FROM CTE
  WHERE [Previous Year House Price] != 0 AND [Year] > '2011-01-01' -- Data from the previous years appears to be incomplete/unreliable
)

-- Check the View

SELECT * FROM DBO.[House Price Change VW]

