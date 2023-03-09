# Cruise Data Management Application - How to Configure the Application

## Overview:
In order for the Cruise Data Management Application (CRDMA) to work properly the APEX parsing schema must be granted certain permissions and data must be loaded into various database tables.

## Requirements:
This application requires version 0.6 of the Cruise Database to be installed (Git tag: cen_cruise_db_v0.6)

## SOP:
-   Grant the necessary permissions to the APEX application parsing schema (CEN_CRUISE_APP)
    -   Execute the statements in the [cen_cruise_app_grant_privs.sql](../SQL/cen_cruise_app_grant_privs.sql) file using the corresponding schemas indicated in the comments.
    -   Execute the statements in the [grant_info.sql](https://picgitlab.nmfs.local/centralized-data-tools/centralized-utilities/-/blob/master/SQL/queries/grant_info.sql) file in the Centralized Utilities project using the CEN_UTILS schema
-   Load the Authorization Application Module groups/users
    -   Execute the [load_users_groups.sql](../SQL/load_user_groups.sql) script in the Cruise Database schema (CEN_CRUISE) to define the groups, users, and corresponding associations
    -   *Note: More information can be found the Authorization Application Module documentation in the Git repository (URL: git@picgitlab.nmfs.local:centralized-data-tools/authorization-application-module.git)
-   Load the APEX Custom Error Handler module records
    -   Execute the [Generate Error Message DML.sql](../SQL/Generate%20Error%20Message%20DML.sql) script in the APEX Custom Error Handler Git repository (URL: <git@picgitlab.nmfs.local:centralized-data-tools/apex_tools.git> in the "Error Handling" folder) using the Cruise Database schema (CEN_CRUISE) to load the custom error information for the application to comply with the SI-11 security requirement.
    -   *Note: More information can be found in the APEX Custom Error Handler module documentation in the Git repository
-   **Note: you can optionally execute the [grant_reload_CRDMA_data.sql](../SQL/grant_reload_CRDMA_data.sql) script to grant the necessary privileges and then purge and reload the application data from the scripts referenced above.
