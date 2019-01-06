/*
SQL query to:
	- Create the database "Crime Project"
	- Create the Stage, Clean and Trash schemas
	- Stage the data: convert the columns to appropriate datatypes and deal with null values
*/

--------------------------------------
-- CREATE DATABASE AND STAGE SCHEMA -- 
--------------------------------------

CREATE DATABASE [Crime Project]
GO

USE [Crime Project]
GO

-- Transfer the imported tables from the dbo schema to the staging one. 

CREATE SCHEMA [Stage]
GO

ALTER SCHEMA STAGE
	TRANSFER [CRIME DATA]
GO

ALTER SCHEMA STAGE
	TRANSFER [LSOA NEAREST NEIGHBOUR]
GO

ALTER SCHEMA STAGE
	TRANSFER [LSOA TO WARD]
GO

ALTER SCHEMA STAGE
	TRANSFER [MEAN HOUSE PRICE]
GO

ALTER SCHEMA STAGE
	TRANSFER [MISSING LSOAS]
GO

ALTER SCHEMA STAGE
	TRANSFER [NEAREST NEIGHBOUR]
GO

ALTER SCHEMA STAGE
	TRANSFER [NON LSOAS IN WARD]
GO

-------------------------
-- CREATE CLEAN SCHEMA --
-------------------------

CREATE SCHEMA Clean
GO


--------------------
-- TABLE CLEAN UP --
--------------------
-- FIND MISSING LSOAS

SELECT 
	   [LSOA code]
	  ,[LSOA Name]
      ,CAST(SUBSTRING([MONTH],1,4) AS DATE) AS [YEAR]	-- cast from string
	  ,[Crime type]
      ,CAST([Longitude]	 AS FLOAT) AS [Longitude]		-- cast from string
      ,CAST([Latitude]	 AS FLOAT) AS [Latitude]	
	  INTO STAGE.[No LSOA Crimes]
  FROM [Stage].[Crime data]
WHERE [LSOA code] = ''
GO



SELECT 
	   [LSOA code]
	  ,[LSOA Name]
      ,CAST(SUBSTRING([MONTH],1,4) AS DATE) AS [YEAR]
	  ,[Crime type]
      ,CAST([Longitude]	 AS FLOAT) AS [Longitude]	
      ,CAST([Latitude]	 AS FLOAT) AS [Latitude]	
	  INTO CLEAN.[Crime Data]
  FROM [Stage].[Crime data]
WHERE [LSOA code] = ''

UNION ALL 

SELECT
	 [LSOA Code]
    ,[LSOA Name]
	,[Year] 
	,[Crime type]
    ,[Longitude]
	,[Latitude]      
  FROM [Stage].[Missing LSOAs]
GO

-- Create a schema in which the tables are transferred before being dropped definitely
CREATE SCHEMA TRASH
GO

--Transfer the previous table into the trash schema as the new table with the missing LSOAs is the correct version

ALTER SCHEMA TRASH
	TRANSFER STAGE.[No LSOA Crimes]
GO


-----------------------------
-- LSOA Nearest Neighbours -- 
-----------------------------

SELECT [ Base LSOA Code] AS [Base LSOA Code]
      ,[Base LSOA Name]
      ,[Neigh LSOA Code]
      ,[Neigh LSOA Name]
      ,CAST([Rank] AS INT) AS [Rank]
      ,CAST([Distnace (Miles)] AS FLOAT) AS [Distance (Miles)]
	  INTO CLEAN.[LSOA Nearest Neighbour]
  FROM [Stage].[LSOA Nearest Neighbour]
GO

-----------------
-- LSOA to LAD -- 
-----------------

USE [Crime Project]
GO

SELECT [LSOA Code]
      ,[LSOA Name]
      ,[Ward Code]
      ,[Ward name]
      ,[LAD16CD] AS [Local Authority Code]
      ,[LAD16NM] AS [Local Authority]
      ,[FID]
	  INTO CLEAN.[LSOA to LAD]
  FROM [Stage].[LSOA to Ward]
GO



----------------------
-- Mean House Price --
----------------------

SELECT TOP 20 * FROM CLEAN.[Mean House Price]

SELECT [Local authority code]
      ,[Local authority name]
      ,[LSOA code]
      ,[LSOA name]
	  -- If the value is null, return -1, it is better for the analysis later
      ,CAST(ISNULL([Year ending Dec 1995],-1) AS FLOAT) AS [Year ending Dec 1995]
      ,CAST(ISNULL([Year ending Mar 1996],-1) AS FLOAT) AS [Year ending Mar 1996]
      ,CAST(ISNULL([Year ending Jun 1996],-1) AS FLOAT) AS [Year ending Jun 1996]
      ,CAST(ISNULL([Year ending Sep 1996],-1) AS FLOAT) AS [Year ending Sep 1996]
      ,CAST(ISNULL([Year ending Dec 1996],-1) AS FLOAT) AS [Year ending Dec 1996]
      ,CAST(ISNULL([Year ending Mar 1997],-1) AS FLOAT) AS [Year ending Mar 1997]
      ,CAST(ISNULL([Year ending Jun 1997],-1) AS FLOAT) AS [Year ending Jun 1997]
      ,CAST(ISNULL([Year ending Sep 1997],-1) AS FLOAT) AS [Year ending Sep 1997]
      ,CAST(ISNULL([Year ending Dec 1997],-1) AS FLOAT) AS [Year ending Dec 1997]
      ,CAST(ISNULL([Year ending Mar 1998],-1) AS FLOAT) AS [Year ending Mar 1998]
      ,CAST(ISNULL([Year ending Jun 1998],-1) AS FLOAT) AS [Year ending Jun 1998]
      ,CAST(ISNULL([Year ending Sep 1998],-1) AS FLOAT) AS [Year ending Sep 1998]
      ,CAST(ISNULL([Year ending Dec 1998],-1) AS FLOAT) AS [Year ending Dec 1998]
      ,CAST(ISNULL([Year ending Mar 1999],-1) AS FLOAT) AS [Year ending Mar 1999]
      ,CAST(ISNULL([Year ending Jun 1999],-1) AS FLOAT) AS [Year ending Jun 1999]
      ,CAST(ISNULL([Year ending Sep 1999],-1) AS FLOAT) AS [Year ending Sep 1999]
      ,CAST(ISNULL([Year ending Dec 1999],-1) AS FLOAT) AS [Year ending Dec 1999]
      ,CAST(ISNULL([Year ending Mar 2000],-1) AS FLOAT) AS [Year ending Mar 2000]
      ,CAST(ISNULL([Year ending Jun 2000],-1) AS FLOAT) AS [Year ending Jun 2000]
      ,CAST(ISNULL([Year ending Sep 2000],-1) AS FLOAT) AS [Year ending Sep 2000]
      ,CAST(ISNULL([Year ending Dec 2000],-1) AS FLOAT) AS [Year ending Dec 2000]
      ,CAST(ISNULL([Year ending Mar 2001],-1) AS FLOAT) AS [Year ending Mar 2001]
      ,CAST(ISNULL([Year ending Jun 2001],-1) AS FLOAT) AS [Year ending Jun 2001]
      ,CAST(ISNULL([Year ending Sep 2001],-1) AS FLOAT) AS [Year ending Sep 2001]
      ,CAST(ISNULL([Year ending Dec 2001],-1) AS FLOAT) AS [Year ending Dec 2001]
      ,CAST(ISNULL([Year ending Mar 2002],-1) AS FLOAT) AS [Year ending Mar 2002]
      ,CAST(ISNULL([Year ending Jun 2002],-1) AS FLOAT) AS [Year ending Jun 2002]
      ,CAST(ISNULL([Year ending Sep 2002],-1) AS FLOAT) AS [Year ending Sep 2002]
      ,CAST(ISNULL([Year ending Dec 2002],-1) AS FLOAT) AS [Year ending Dec 2002]
      ,CAST(ISNULL([Year ending Mar 2003],-1) AS FLOAT) AS [Year ending Mar 2003]
      ,CAST(ISNULL([Year ending Jun 2003],-1) AS FLOAT) AS [Year ending Jun 2003]
      ,CAST(ISNULL([Year ending Sep 2003],-1) AS FLOAT) AS [Year ending Sep 2003]
      ,CAST(ISNULL([Year ending Dec 2003],-1) AS FLOAT) AS [Year ending Dec 2003]
      ,CAST(ISNULL([Year ending Mar 2004],-1) AS FLOAT) AS [Year ending Mar 2004]
      ,CAST(ISNULL([Year ending Jun 2004],-1) AS FLOAT) AS [Year ending Jun 2004]
      ,CAST(ISNULL([Year ending Sep 2004],-1) AS FLOAT) AS [Year ending Sep 2004]
      ,CAST(ISNULL([Year ending Dec 2004],-1) AS FLOAT) AS [Year ending Dec 2004]
      ,CAST(ISNULL([Year ending Mar 2005],-1) AS FLOAT) AS [Year ending Mar 2005]
      ,CAST(ISNULL([Year ending Jun 2005],-1) AS FLOAT) AS [Year ending Jun 2005]
      ,CAST(ISNULL([Year ending Sep 2005],-1) AS FLOAT) AS [Year ending Sep 2005]
      ,CAST(ISNULL([Year ending Dec 2005],-1) AS FLOAT) AS [Year ending Dec 2005]
      ,CAST(ISNULL([Year ending Mar 2006],-1) AS FLOAT) AS [Year ending Mar 2006]
      ,CAST(ISNULL([Year ending Jun 2006],-1) AS FLOAT) AS [Year ending Jun 2006]
      ,CAST(ISNULL([Year ending Sep 2006],-1) AS FLOAT) AS [Year ending Sep 2006]
      ,CAST(ISNULL([Year ending Dec 2006],-1) AS FLOAT) AS [Year ending Dec 2006]
      ,CAST(ISNULL([Year ending Mar 2007],-1) AS FLOAT) AS [Year ending Mar 2007]
      ,CAST(ISNULL([Year ending Jun 2007],-1) AS FLOAT) AS [Year ending Jun 2007]
      ,CAST(ISNULL([Year ending Sep 2007],-1) AS FLOAT) AS [Year ending Sep 2007]
      ,CAST(ISNULL([Year ending Dec 2007],-1) AS FLOAT) AS [Year ending Dec 2007]
      ,CAST(ISNULL([Year ending Mar 2008],-1) AS FLOAT) AS [Year ending Mar 2008]
      ,CAST(ISNULL([Year ending Jun 2008],-1) AS FLOAT) AS [Year ending Jun 2008]
      ,CAST(ISNULL([Year ending Sep 2008],-1) AS FLOAT) AS [Year ending Sep 2008]
      ,CAST(ISNULL([Year ending Dec 2008],-1) AS FLOAT) AS [Year ending Dec 2008]
      ,CAST(ISNULL([Year ending Mar 2009],-1) AS FLOAT) AS [Year ending Mar 2009]
      ,CAST(ISNULL([Year ending Jun 2009],-1) AS FLOAT) AS [Year ending Jun 2009]
      ,CAST(ISNULL([Year ending Sep 2009],-1) AS FLOAT) AS [Year ending Sep 2009]
      ,CAST(ISNULL([Year ending Dec 2009],-1) AS FLOAT) AS [Year ending Dec 2009]
      ,CAST(ISNULL([Year ending Mar 2010],-1) AS FLOAT) AS [Year ending Mar 2010]
      ,CAST(ISNULL([Year ending Jun 2010],-1) AS FLOAT) AS [Year ending Jun 2010]
      ,CAST(ISNULL([Year ending Sep 2010],-1) AS FLOAT) AS [Year ending Sep 2010]
      ,CAST(ISNULL([Year ending Dec 2010],-1) AS FLOAT) AS [Year ending Dec 2010]
      ,CAST(ISNULL([Year ending Mar 2011],-1) AS FLOAT) AS [Year ending Mar 2011]
      ,CAST(ISNULL([Year ending Jun 2011],-1) AS FLOAT) AS [Year ending Jun 2011]
      ,CAST(ISNULL([Year ending Sep 2011],-1) AS FLOAT) AS [Year ending Sep 2011]
      ,CAST(ISNULL([Year ending Dec 2011],-1) AS FLOAT) AS [Year ending Dec 2011]
      ,CAST(ISNULL([Year ending Mar 2012],-1) AS FLOAT) AS [Year ending Mar 2012]
      ,CAST(ISNULL([Year ending Jun 2012],-1) AS FLOAT) AS [Year ending Jun 2012]
      ,CAST(ISNULL([Year ending Sep 2012],-1) AS FLOAT) AS [Year ending Sep 2012]
      ,CAST(ISNULL([Year ending Dec 2012],-1) AS FLOAT) AS [Year ending Dec 2012]
      ,CAST(ISNULL([Year ending Mar 2013],-1) AS FLOAT) AS [Year ending Mar 2013]
      ,CAST(ISNULL([Year ending Jun 2013],-1) AS FLOAT) AS [Year ending Jun 2013]
      ,CAST(ISNULL([Year ending Sep 2013],-1) AS FLOAT) AS [Year ending Sep 2013]
      ,CAST(ISNULL([Year ending Dec 2013],-1) AS FLOAT) AS [Year ending Dec 2013]
      ,CAST(ISNULL([Year ending Mar 2014],-1) AS FLOAT) AS [Year ending Mar 2014]
      ,CAST(ISNULL([Year ending Jun 2014],-1) AS FLOAT) AS [Year ending Jun 2014]
      ,CAST(ISNULL([Year ending Sep 2014],-1) AS FLOAT) AS [Year ending Sep 2014]
      ,CAST(ISNULL([Year ending Dec 2014],-1) AS FLOAT) AS [Year ending Dec 2014]
      ,CAST(ISNULL([Year ending Mar 2015],-1) AS FLOAT) AS [Year ending Mar 2015]
      ,CAST(ISNULL([Year ending Jun 2015],-1) AS FLOAT) AS [Year ending Jun 2015]
      ,CAST(ISNULL([Year ending Sep 2015],-1) AS FLOAT) AS [Year ending Sep 2015]
      ,CAST(ISNULL([Year ending Dec 2015],-1) AS FLOAT) AS [Year ending Dec 2015]
      ,CAST(ISNULL([Year ending Mar 2016],-1) AS FLOAT) AS [Year ending Mar 2016]
      ,CAST(ISNULL([Year ending Jun 2016],-1) AS FLOAT) AS [Year ending Jun 2016]
      ,CAST(ISNULL([Year ending Sep 2016],-1) AS FLOAT) AS [Year ending Sep 2016]
      ,CAST(ISNULL([Year ending Dec 2016],-1) AS FLOAT) AS [Year ending Dec 2016]
      ,CAST(ISNULL([Year ending Mar 2017],-1) AS FLOAT) AS [Year ending Mar 2017]
      ,CAST(ISNULL([Year ending Jun 2017],-1) AS FLOAT) AS [Year ending Jun 2017]
      ,CAST(ISNULL([Year ending Sep 2017],-1) AS FLOAT) AS [Year ending Sep 2017]
      ,CAST(ISNULL([Year ending Dec 2017],-1) AS FLOAT) AS [Year ending Dec 2017]
      ,CAST(ISNULL([Year ending Mar 2018],-1) AS FLOAT) AS [Year ending Mar 2018]
      ,CAST(ISNULL([Year ending Jun 2018],-1) AS FLOAT) AS [Year ending Jun 2018]
  FROM [Stage].[Mean House Price]
GO

