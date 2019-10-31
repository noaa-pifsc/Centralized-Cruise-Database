--------------------------------------------------------
--------------------------------------------------------
--Database Name: Centralized Cruise Database
--Database Description: Centralized Cruise Database to track information about each PIFSC research cruise including activities, chief scientists, regions, etc. to remove the need for each division/program to manage this information 
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Centralized Cruise Database - version 0.5 updates:
--------------------------------------------------------


--Installed Version 0.7 of the Authorization Application Module Database (Git URL: git@pichub.pifsc.gov:application-development/centralized-tools.git in the auth_app folder)

		
		-------------------------------------------------------------------
		--version 0.7 updates:
		-------------------------------------------------------------------
		
		
		--authentication/authorization module package:
		CREATE OR REPLACE PACKAGE AUTH_APP_PKG
		AS
		
		--Custom authorization function that integrates the Application Authentication and Authorization Module
		FUNCTION APX_CUST_AUTH_USER(p_username VARCHAR2, p_password VARCHAR2) RETURN BOOLEAN;
		
		
		END AUTH_APP_PKG;
		/
		
		create or replace PACKAGE BODY AUTH_APP_PKG
		AS
		
		
		FUNCTION APX_CUST_AUTH_USER(p_username IN VARCHAR2, p_password IN VARCHAR2) RETURN BOOLEAN IS
		--Custom authorization function that integrates the Application Authorization Module:
		--this function will use the default APEX workspace authentication and the dsc.dsc_utilities_pkg.authenticate_user_ldap() function to validate the user credentials.  If either of those methods are successful the function will check the auth_app module to confirm if this user is an active user, if so the user will be considered authenticated and authorized to access the application, if not the user will not be allowed to login.
		--the function will return FALSE if the user is not authenticated and TRUE if the user was successfully authenticated
		
		
		
		--variable to store the return value of the active user query:
		temp_active_yn char(1);
		
		BEGIN
		
		    --Use the default APEX workspace authentication to authenticate the user
		    IF apex_util.is_login_password_valid(p_username=>p_username, p_password=>p_password) THEN
		    
			--the APEX workspace login was successful, query to see if there is a matching active user record:
			select app_user_active_yn into temp_active_yn from auth_app_users_v where upper(app_user_name) = upper(p_username) and app_user_active_yn = 'Y';
		    
			--if there is one row returned then the user account exists in the database so the user is authenticated:
			RETURN TRUE;
		    ELSE
		
			--Use the custom ICAM authentication function to authenticate the user:
			IF dsc.dsc_utilities_pkg.noaa_icam_auth_char(p_username, p_password) = 'TRUE' THEN
		    
			    --the user was authenticated via ICAM, query to see if there is a matching active user record:
			    select app_user_active_yn into temp_active_yn from auth_app_users_v where upper(app_user_name) = upper(p_username) and app_user_active_yn = 'Y';
		    
			    --if there is one row returned then the user account exists in the database so the user is authenticated:
			    RETURN TRUE;
		    
			ELSE
			    --the user was not authenticated via LDAP, this is not a valid application user:
			    RETURN FALSE;
			
			END IF;
		    END IF;
		  
		    EXCEPTION
			
			--Check if the active user query returned no rows
			WHEN NO_DATA_FOUND THEN
			    RETURN FALSE;
		    
			--Check if the active user query returned more than one row
			WHEN TOO_MANY_ROWS THEN
			    RETURN FALSE;
		 
		END APX_CUST_AUTH_USER;
		
		END AUTH_APP_PKG;
		/
		
		
		
		
		--define the upgrade version in the database:
		INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Authorization Application Database', '0.7', TO_DATE('30-OCT-19', 'DD-MON-YY'), 'Updated the Auth App package function to use the new ICAM/whitepages authentication method defined in DSC.DSC_UTILITIES_PKG.noaa_icam_auth_char()');


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Centralized Cruise Database', '0.5', TO_DATE('31-OCT-19', 'DD-MON-YY'), 'Upgraded the Authorization Application Module Database from 0.6 to 0.7 to implement the new ICAM/Whitepages user authentication');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;