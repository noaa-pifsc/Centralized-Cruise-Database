--------------------------------------------------------
--------------------------------------------------------
--Database Name: APEX Feedback Form
--Database Description: This database is used to collect feedback form submissions
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--APEX Feedback Form - version 0.1 updates:
--------------------------------------------------------

CREATE TABLE AFF_RESP_TYPES
(
  RESP_TYPE_ID NUMBER NOT NULL
, RESP_TYPE_CODE VARCHAR2(50)
, RESP_TYPE_NAME VARCHAR2(200) NOT NULL
, RESP_TYPE_DESC VARCHAR2(500)
, CONSTRAINT AFF_RESP_TYPES_PK PRIMARY KEY
  (
    RESP_TYPE_ID
  )
  ENABLE
);

COMMENT ON COLUMN AFF_RESP_TYPES.RESP_TYPE_ID IS 'Primary key for the APEX Feedback Form Response Types table';

COMMENT ON COLUMN AFF_RESP_TYPES.RESP_TYPE_CODE IS 'Code for the given APEX Feedback Form Response Types';

COMMENT ON COLUMN AFF_RESP_TYPES.RESP_TYPE_NAME IS 'Name of the given APEX Feedback Form Response Types';

COMMENT ON COLUMN AFF_RESP_TYPES.RESP_TYPE_DESC IS 'Description for the given APEX Feedback Form Response Types';

COMMENT ON TABLE AFF_RESP_TYPES IS 'Reference Table for storing APEX Feedback Form Response Types information';

ALTER TABLE AFF_RESP_TYPES ADD CONSTRAINT AFF_RESP_TYPES_U1 UNIQUE
(
  RESP_TYPE_CODE
)
ENABLE;

ALTER TABLE AFF_RESP_TYPES ADD CONSTRAINT AFF_RESP_TYPES_U2 UNIQUE
(
  RESP_TYPE_NAME
)
ENABLE;



ALTER TABLE AFF_RESP_TYPES ADD (CREATE_DATE DATE );

ALTER TABLE AFF_RESP_TYPES ADD (CREATED_BY VARCHAR2(255) );
ALTER TABLE AFF_RESP_TYPES ADD (LAST_MOD_DATE DATE );
ALTER TABLE AFF_RESP_TYPES ADD (LAST_MOD_BY VARCHAR2(255) );

COMMENT ON COLUMN AFF_RESP_TYPES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN AFF_RESP_TYPES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN AFF_RESP_TYPES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN AFF_RESP_TYPES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


CREATE SEQUENCE AFF_RESP_TYPES_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER AFF_RESP_TYPES_AUTO_BRI
before insert on AFF_RESP_TYPES
for each row
begin
  select AFF_RESP_TYPES_SEQ.nextval into :new.RESP_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/



CREATE OR REPLACE TRIGGER AFF_RESP_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON AFF_RESP_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/










CREATE TABLE AFF_RESPONSES
(
  RESP_ID NUMBER NOT NULL
, APP_ID NUMBER NOT NULL
, PAGE_ID NUMBER NOT NULL
, RESP_CONTENT CLOB NOT NULL
, RESP_TYPE_ID NUMBER NOT NULL
, CONSTRAINT AFF_RESPONSES_PK PRIMARY KEY
  (
    RESP_ID
  )
  ENABLE
);


ALTER TABLE AFF_RESPONSES
ADD CONSTRAINT AFF_RESPONSES_FK1 FOREIGN KEY
(
  RESP_TYPE_ID
)
REFERENCES AFF_RESP_TYPES
(
  RESP_TYPE_ID
)
ENABLE;


COMMENT ON COLUMN AFF_RESPONSES.RESP_ID IS 'Primary key for the APEX Feedback Form Responses table';

COMMENT ON COLUMN AFF_RESPONSES.APP_ID IS 'The application ID for the APEX Feedback Form Response';
COMMENT ON COLUMN AFF_RESPONSES.PAGE_ID IS 'The page ID the user was visiting when they submitted their APEX Feedback Form Response';
COMMENT ON COLUMN AFF_RESPONSES.RESP_CONTENT IS 'Response content provided by the user';
COMMENT ON COLUMN AFF_RESPONSES.RESP_TYPE_ID IS 'Foreign key constraint that references the APEX Feedback Form Response Type';




COMMENT ON TABLE AFF_RESPONSES IS 'APEX Feedback Form Responses

This table contains the different APEX feedback form responses';


ALTER TABLE AFF_RESPONSES ADD (CREATE_DATE DATE );
ALTER TABLE AFF_RESPONSES ADD (CREATED_BY VARCHAR2(255) );

COMMENT ON COLUMN AFF_RESPONSES.CREATE_DATE IS 'The date/time the feedback was received';

COMMENT ON COLUMN AFF_RESPONSES.CREATED_BY IS 'The application username used to submit the feedback';


CREATE SEQUENCE AFF_RESPONSES_SEQ INCREMENT BY 1 START WITH 1;



create or replace TRIGGER AFF_RESPONSES_AUTO_BRI
before insert on AFF_RESPONSES
for each row
begin
  select AFF_RESPONSES_SEQ.nextval into :new.RESP_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/



--load the standard data for the APEX feedback form response types:
INSERT INTO AFF_RESP_TYPES (RESP_TYPE_NAME, RESP_TYPE_CODE, RESP_TYPE_DESC) VALUES ('General Comment', 'GC', 'General comment for the particular page and/or application');
INSERT INTO AFF_RESP_TYPES (RESP_TYPE_NAME, RESP_TYPE_CODE, RESP_TYPE_DESC) VALUES ('Enhancement Request', 'ER', 'Enhancement request for the particular page and/or application');
INSERT INTO AFF_RESP_TYPES (RESP_TYPE_NAME, RESP_TYPE_CODE, RESP_TYPE_DESC) VALUES ('Bug', 'BG', 'Bug report for the particular page and/or application');
INSERT INTO AFF_RESP_TYPES (RESP_TYPE_NAME, RESP_TYPE_CODE, RESP_TYPE_DESC) VALUES ('Question', 'Q', 'Question about the particular page and/or application');




CREATE OR REPLACE VIEW

AFF_RESPONSES_V
AS
SELECT
AFF_RESPONSES.RESP_ID,
AFF_RESPONSES.APP_ID,
AFF_RESPONSES.PAGE_ID,
AFF_RESPONSES.RESP_CONTENT,
AFF_RESPONSES.RESP_TYPE_ID,
AFF_RESPONSES.CREATE_DATE,
TO_CHAR(AFF_RESPONSES.CREATE_DATE, 'MM/DD/YYYY HH24:MI') FORMAT_CREATE_DATE,
AFF_RESPONSES.CREATED_BY,
AFF_RESP_TYPES.RESP_TYPE_CODE,
AFF_RESP_TYPES.RESP_TYPE_NAME,
AFF_RESP_TYPES.RESP_TYPE_DESC

FROM
AFF_RESPONSES INNER JOIN
AFF_RESP_TYPES ON AFF_RESPONSES.RESP_TYPE_ID = AFF_RESP_TYPES.RESP_TYPE_ID
order by
AFF_RESP_TYPES.RESP_TYPE_NAME,
AFF_RESPONSES.CREATE_DATE;



COMMENT ON TABLE AFF_RESPONSES_V IS 'APEX Feedback Form Responses (View)

This query returns the different APEX feedback form responses and associated feedback types';

COMMENT ON COLUMN AFF_RESPONSES_V.RESP_ID IS 'Primary key for the APEX Feedback Form Responses table';
COMMENT ON COLUMN AFF_RESPONSES_V.APP_ID IS 'The application ID for the APEX Feedback Form Response';
COMMENT ON COLUMN AFF_RESPONSES_V.PAGE_ID IS 'The page ID the user was visiting when they submitted their APEX Feedback Form Response';
COMMENT ON COLUMN AFF_RESPONSES_V.RESP_CONTENT IS 'Response content provided by the user';
COMMENT ON COLUMN AFF_RESPONSES_V.RESP_TYPE_ID IS 'Primary key for the APEX Feedback Form Response Types table';
COMMENT ON COLUMN AFF_RESPONSES_V.CREATE_DATE IS 'The date/time the feedback was received';
COMMENT ON COLUMN AFF_RESPONSES_V.FORMAT_CREATE_DATE IS 'The formatted date/time the feedback was received (MM/DD/YYYY HH24:MI format)';
COMMENT ON COLUMN AFF_RESPONSES_V.CREATED_BY IS 'The application username used to submit the feedback';
COMMENT ON COLUMN AFF_RESPONSES_V.RESP_TYPE_CODE IS 'Code for the given APEX Feedback Form Response Types';
COMMENT ON COLUMN AFF_RESPONSES_V.RESP_TYPE_NAME IS 'Name of the given APEX Feedback Form Response Types';
COMMENT ON COLUMN AFF_RESPONSES_V.RESP_TYPE_DESC IS 'Description for the given APEX Feedback Form Response Types';



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('APEX Feedback Form', '0.1', TO_DATE('23-JUL-21', 'DD-MON-YY'), 'Initial data model development for the APEX Feedback Form database.  Defined tables for the feedback form response types and responses.  Created sequences, triggers and a view to unify the two data tables.');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
