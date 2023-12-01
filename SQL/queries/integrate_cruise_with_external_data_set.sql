--SQL to execute on a given scientific schema to integrate a given database table with the centralized cruise database:
--replace [TABLE NAME] with the table name of the database table that will be integrated with the centralized cruise database's cruise leg table
--replace [FK INDEX NAME] with a reasonable index name for the foreign key field that references the centralized cruise database's cruise leg table that conforms to the established naming conventions (e.g. CTD_CASTS_I3)
--replace [FK CONSTRAINT NAME] with a reasonable constraint name for the foreign key field that references the centralized cruise database's cruise leg table that conforms to the established naming conventions (e.g. CTD_CASTS_FK5)

ALTER TABLE [TABLE NAME] ADD (CRUISE_ID NUMBER);

CREATE INDEX [FK INDEX NAME] ON [TABLE NAME] (CRUISE_ID);

ALTER TABLE [TABLE NAME]
ADD CONSTRAINT [FK CONSTRAINT NAME] FOREIGN KEY
(
  CRUISE_ID 
)
REFERENCES CEN_CRUISE.CCD_CRUISES
(
  CRUISE_ID 
)
ENABLE;

COMMENT ON COLUMN [TABLE NAME].CRUISE_ID IS 'The associated research cruise';