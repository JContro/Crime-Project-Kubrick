USE [Crime Project]
GO
---------------------------
--  IMD 2015 LDN STAGING --
---------------------------

-- Transfer the data into the staging schema
ALTER SCHEMA [STAGE]
	TRANSFER [IMD 2015 LDN]
GO

-- Convert the data to float or int and save a copy of this table in CLEAN.[Deprivation 2015 London]
SELECT [LSOA code (2011)] AS [LSOA Code]
      ,[LSOA name (2011)] AS [LSOA Name]
      ,[Local Authority District code (2013)]
      ,[Local Authority District name (2013)]
      ,CAST([IMD Score]															AS FLOAT) AS [IMD Score]															
      ,CAST([IMD Rank (where 1 is most deprived)]								AS INT) AS [IMD Rank (where 1 is most deprived)]								
      ,CAST([IMD Decile (where 1 is most deprived 10% of LSOAs)]				AS INT) AS [IMD Decile (where 1 is most deprived 10% of LSOAs)]				
      ,CAST([Income Score (rate)]												AS FLOAT) AS [Income Score (rate)]												
      ,CAST([Income Rank (where 1 is most deprived)]							AS INT) AS [Income Rank (where 1 is most deprived)]							
      ,CAST([Income Decile (where 1 is most deprived 10% of LSOAs)]				AS INT) AS [Income Decile (where 1 is most deprived 10% of LSOAs)]				
      ,CAST([Employment Score (rate)]											AS FLOAT) AS [Employment Score (rate)]											
      ,CAST([Employment Rank (where 1 is most deprived)]						AS INT) AS [Employment Rank (where 1 is most deprived)]						
      ,CAST([Employment Decile (where 1 is most deprived 10% of LSOAs)]			AS INT) AS [Employment Decile (where 1 is most deprived 10% of LSOAs)]			
      ,CAST([Education, Skills and Training Score]								AS FLOAT) AS [Education, Skills and Training Score]								
      ,CAST([Education, Skills and Training Rank (where 1 is most deprived)]	AS INT) AS [Education, Skills and Training Rank (where 1 is most deprived)]	
      ,CAST([Education, Skills and Training Decile (where 1 is most deprived ]	AS INT) AS [Education, Skills and Training Decile (where 1 is most deprived ]	
      ,CAST([Health Deprivation and Disability Score]							AS FLOAT) AS [Health Deprivation and Disability Score]							
      ,CAST([Health Deprivation and Disability Rank (where 1 is most deprived]	AS INT) AS [Health Deprivation and Disability Rank (where 1 is most deprived]	
      ,CAST([Health Deprivation and Disability Decile (where 1 is most depriv]	AS INT) AS [Health Deprivation and Disability Decile (where 1 is most depriv]	
      ,CAST([Crime Score]														AS FLOAT) AS [Crime Score]														
      ,CAST([Crime Rank (where 1 is most deprived)]								AS INT) AS [Crime Rank (where 1 is most deprived)]								
      ,CAST([Crime Decile (where 1 is most deprived 10% of LSOAs)]				AS INT) AS [Crime Decile (where 1 is most deprived 10% of LSOAs)]				
      ,CAST([Barriers to Housing and Services Score]							AS FLOAT) AS [Barriers to Housing and Services Score]							
      ,CAST([Barriers to Housing and Services Rank (where 1 is most deprived)]	AS INT) AS [Barriers to Housing and Services Rank (where 1 is most deprived)]	
      ,CAST([Barriers to Housing and Services Decile (where 1 is most deprive]	AS INT) AS [Barriers to Housing and Services Decile (where 1 is most deprive]	
      ,CAST([Living Environment Score]											AS FLOAT) AS [Living Environment Score]											
      ,CAST([Living Environment Rank (where 1 is most deprived)]				AS INT) AS [Living Environment Rank (where 1 is most deprived)]				
      ,CAST([Living Environment Decile (where 1 is most deprived 10% of LSOAs]	AS INT) AS [Living Environment Decile (where 1 is most deprived 10% of LSOAs]	
	  --INTO CLEAN.[Deprivation 2015 London]
  FROM STAGE.[IMD 2015 LDN]
GO


----------------------------
-- Population LDN STAGING --
----------------------------

ALTER SCHEMA STAGE
	TRANSFER [POPULATION LDN]
GO

SELECT [LSOA code (2011)]
      ,[LSOA name (2011)]
      ,[Local Authority District code (2013)]
      ,[Local Authority District name (2013)]
      ,CAST([Total population: mid 2012 (excluding prisoners)]				   AS INT) AS [Total population: mid 2012 (excluding prisoners)]				  
      ,CAST([Dependent Children aged 0-15: mid 2012 (excluding prisoners)]	   AS INT) AS [Dependent Children aged 0-15: mid 2012 (excluding prisoners)]	  
      ,CAST([Population aged 16-59: mid 2012 (excluding prisoners)]			   AS INT) AS [Population aged 16-59: mid 2012 (excluding prisoners)]			  
      ,CAST([Older population aged 60 and over: mid 2012 (excluding prisoners] AS INT) AS [Older population aged 60 and over: mid 2012 (excluding prisoners]
      ,CAST([Working age population 18-59/64: for use with Employment Depriva] AS FLOAT) AS [Working age population 18-59/64: for use with Employment Depriva]
	  --INTO CLEAN.[Population London]
  FROM STAGE.[Population LDN]
GO

-----------------

ALTER SCHEMA STAGE
	TRANSFER [LONDON LSOA]


