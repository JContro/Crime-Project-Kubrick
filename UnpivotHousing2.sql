/*
Unpivot the table clean.[Mean House Price] into analysis.[Mean House Price]
This is to make the analysis easier (OLAP)
*/

USE [Crime Project]
GO

-- Wrap the unpivoted table in a cte to filter by houseprice != -1 
-- In the first Staging all null values were replaced with -1, so must be filtered out
WITH CTE AS
(

SELECT 
      [LSOA code]
      ,[LSOA name]
	  ,CAST(SUBSTRING([Year],13,8) AS DATE) AS [Year] -- Get the year and month and cast as a date (to maintain a consistant format throughout the tables)
	  ,[Mean House Price]
      
 FROM (
 SELECT 
	   [LSOA code]
      ,[LSOA name]
      ,[Year ending Jun 2006]
      ,[Year ending Jun 2007]
      ,[Year ending Jun 2008]
      ,[Year ending Jun 2009]
      ,[Year ending Jun 2010]
      ,[Year ending Jun 2011]
      ,[Year ending Jun 2012]
      ,[Year ending Jun 2013]
      ,[Year ending Jun 2014]
      ,[Year ending Jun 2015]
      ,[Year ending Jun 2016]
      ,[Year ending Jun 2017]
      ,[Year ending Jun 2018]
	  
	  FROM CLEAN.[Mean House Price]
	  ) P
	 
UNPIVOT 
	([Mean House Price] FOR [Year] IN 
		( [Year ending Jun 2006]
      ,[Year ending Jun 2007]
      ,[Year ending Jun 2008]
      ,[Year ending Jun 2009]
      ,[Year ending Jun 2010]
      ,[Year ending Jun 2011]
      ,[Year ending Jun 2012]
      ,[Year ending Jun 2013]
      ,[Year ending Jun 2014]
      ,[Year ending Jun 2015]
      ,[Year ending Jun 2016]
      ,[Year ending Jun 2017]
      ,[Year ending Jun 2018])
) AS Unpvt
)


SELECT * 
	INTO ANALYSIS.[Mean House Price]
FROM CTE
WHERE [Mean House Price] != -1

go
