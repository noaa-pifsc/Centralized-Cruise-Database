@@"./cen_cruise_app_grant_privs.sql"

--remove the auth_app records:
delete from auth_app_user_groups;
delete from auth_app_users;
delete from auth_app_groups;

@@"./load_user_groups.sql"

--delete the custom error messages
delete from CUST_ERR_CONSTR_MSG;

@@"./Generate Error Message DML.sql"