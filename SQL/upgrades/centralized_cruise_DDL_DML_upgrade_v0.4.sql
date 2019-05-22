--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information 
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.4 updates:
--------------------------------------------------------




	--CRUISE Package Specification:
	CREATE OR REPLACE PACKAGE CRUISE_PKG
	AUTHID DEFINER
	--this package provides functions and procedures to interact with the Cruise package module
	
	AS
	
	--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME that matches the P_LEG_ALIAS value.  It returns NULL if no match is found
	FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID (P_LEG_ALIAS VARCHAR2) RETURN NUMBER;


	END CRUISE_PKG;
	/
	
	--CTD Package Body:
	create or replace PACKAGE BODY CRUISE_PKG
	--this package provides functions and procedures to interact with the CTD package module
	AS
	
	
	
	

	--function that accepts a P_LEG_ALIAS value and returns the CRUISE_LEG_ID value for the CCD_CRUISE_LEGS record that has a corresponding CCD_LEG_ALIASES record with a LEG_ALIAS_NAME that matches the P_LEG_ALIAS value.  It returns NULL if no match is found
		FUNCTION LEG_ALIAS_TO_CRUISE_LEG_ID (P_LEG_ALIAS VARCHAR2)
			RETURN NUMBER is
						v_cruise_leg_id NUMBER;
						
						v_return_code PLS_INTEGER;
		
		BEGIN
			
        select ccd_cruise_legs_v.cruise_leg_id into v_cruise_leg_id
        from ccd_cruise_legs_v inner join ccd_leg_aliases on ccd_leg_aliases.cruise_leg_id = ccd_cruise_legs_v.cruise_leg_id
        AND UPPER(ccd_leg_aliases.LEG_ALIAS_NAME) = UPPER(P_LEG_ALIAS);
      

				--return the value of CRUISE_LEG_ID from the query 			
				RETURN v_cruise_leg_id;

				EXCEPTION

					WHEN NO_DATA_FOUND THEN
					
          --no results returned by the query, return NULL

					RETURN NULL;
				
					--catch all PL/SQL database exceptions:
					WHEN OTHERS THEN

					--catch all other errors:
					
					--return NULL to indicate the error:
					RETURN NULL;

		END LEG_ALIAS_TO_CRUISE_LEG_ID;

		
	end CRUISE_PKG;
	/
	


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.4', TO_DATE('21-MAY-19', 'DD-MON-YY'), 'Created a new CRUISE_PKG package that defines a function LEG_ALIAS_TO_CRUISE_LEG_ID to resolve a cruise leg alias to the corresponding cruise leg record');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;