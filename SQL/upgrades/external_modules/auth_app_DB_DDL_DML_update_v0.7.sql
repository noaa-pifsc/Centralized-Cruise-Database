--------------------------------------------------------
--------------------------------------------------------
--Database Name: Authorization Application Database
--Database Description: This database was originally designed to manage application access and permissions within the application.  This is a flexible method that allows users and permission groups to be defined that will determine if a user has enabled access to the application and what permission(s) they have in the application.
--------------------------------------------------------
--------------------------------------------------------


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
--this function will use the default APEX workspace authentication and the dsc.dsc_utilities_pkg.noaa_icam_auth_char() function to validate the user credentials.  If either of those methods are successful the function will check the auth_app module to confirm if this user is an active user, if so the user will be considered authenticated and authorized to access the application, if not the user will not be allowed to login.
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
            --the user was not authenticated via ICAM, this is not a valid application user:
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


