USE [Crime Project]
GO

/*
This Query is to create the database diagram. The fact table is the crime data table

*/


-- Create the table GeogLSOA by joining LSOA to LAD and LSOA to Constabulary
-- to create a dimension table for the geographic properties of the LSOA
SELECT 
	L.*
	,C.Constabulary
	INTO CLEAN.[GeogLSOA]
FROM CLEAN.[LSOA to LAD] L
JOIN CLEAN.[LSOA to Constabulary] C
	ON L.[LSOA Code] = C.[LSOA Code]

-- Make the LSOA Code not null to make it a primary key 
ALTER TABLE   CLEAN.[GEOGLSOA]
	ALTER COLUMN [LSOA CODE] VARCHAR(100) NOT NULL
GO

-- Set the LSOA code as the Primary key
ALTER TABLE CLEAN.[GEOGLSOA]
ADD CONSTRAINT PK_GEOG_LSOA PRIMARY KEY CLUSTERED ([LSOA CODE])
GO

-- Set LSOA code as the foreign key connecting [crime data] to [geogLSOA]
ALTER TABLE clean.[crime data] WITH NOCHECK
ADD CONSTRAINT FK_Crime_Data_LSOA FOREIGN KEY ([LSOA CODE])
REFERENCES CLEAN.[GEOGLSOA] ([LSOA CODE])

-- Set LSOA code as the foreign key connecting [LSOA NEAREST NEIGHBOUR] to [geogLSOA]
ALTER TABLE clean.[LSOA NEAREST NEIGHBOUR] WITH NOCHECK
ADD CONSTRAINT FK_NN_BaseLSOA FOREIGN KEY ([Base LSOA CODE])
REFERENCES CLEAN.[GEOGLSOA] ([LSOA CODE])


-- Set LSOA code as the foreign key connecting [LSOA NEAREST NEIGHBOUR] to [geogLSOA]
ALTER TABLE clean.[LSOA NEAREST NEIGHBOUR] WITH NOCHECK
ADD CONSTRAINT FK_NN_NeighLSOA FOREIGN KEY ([NEIGH LSOA CODE])
REFERENCES CLEAN.[GEOGLSOA] ([LSOA CODE])


-- Set LSOA code as the foreign key connecting [MEAN HOUSE PRICE] to [geogLSOA]
ALTER TABLE ANALYSIS.[MEAN HOUSE PRICE] WITH NOCHECK
ADD CONSTRAINT FK_HP_LSOA FOREIGN KEY ([LSOA CODE])
REFERENCES CLEAN.[GEOGLSOA] ([LSOA CODE])


-- Set LSOA code as the foreign key connecting [MEAN HOUSE PRICE] to [geogLSOA]
ALTER TABLE CLEAN.[POPULATION LONDON] WITH NOCHECK
ADD CONSTRAINT FK_POP_LSOA FOREIGN KEY ([LSOA CODE (2011)])
REFERENCES CLEAN.[GEOGLSOA] ([LSOA CODE])


-- Set LSOA code as the foreign key connecting [POPULATION LONDON] to [geogLSOA]
ALTER TABLE CLEAN.[POPULATION LONDON] WITH NOCHECK
ADD CONSTRAINT FK_POP_LSOA FOREIGN KEY ([LSOA CODE (2011)])
REFERENCES CLEAN.[GEOGLSOA] ([LSOA CODE])

-- Set LSOA code as the foreign key connecting [Deprivation 2015 London] TO [POPULATION LONDON]  
ALTER TABLE clean.[Deprivation 2015 London] WITH NOCHECK
ADD CONSTRAINT FK_Deprivation_LSOA FOREIGN KEY ([LSOA Code])
REFERENCES CLEAN.[POPULATION LONDON] ([LSOA CODE (2011)])

