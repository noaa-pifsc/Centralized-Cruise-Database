# Centralized Cruise Database - Data Integration SOP

## Overview:
The Centralized Cruise Database (CCD) was developed to manage all operational cruise-level information in the PIFSC enterprise database that other scientific data schemas can reference directly. The CCD Data Integration SOP was developed to define the process of integrating the CCD data into any scientific enterprise database schema with cruise-based data collection using Cruise Legs as the integration point. Integrating data across database schemas has some additional considerations that should be handled with a standard approach to ensure maintainability and security. In this SOP the CCD will be referred to as the Source Schema and the scientific data schema that will reference the CCD will be referred to as the Referring Schema. The Centralized CTD Data System was integrated with the CCD and is provided as an example of a Referring Schema in the SOP.

## Resources:
-   Version Control Information:
    -   Git Repository URL: git@picgitlab.nmfs.local:centralized-data-tools/centralized-cruise-database.git
    -   Version: 1.1 (Git tag: CCD_data_integration_SOP_v1.1)
-   [Centralized Cruise Database - Technical Documentation](./Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)

## Procedure:
1.  ### Grant the Referring Schema permissions
    -   Grant the minimum required permissions to access the appropriate CCD Source Schema objects
        -   Open [grant_external_schema_privs.sql](../SQL/queries/grant_external_schema_privs.sql)
        -   Replace the [EXTERNAL SCHEMA] placeholders with the Referring Schema name (e.g. CEN_CTD).
        -   Execute the generated permissions script on the CCD Source Schema (CEN_CRUISE).
2.  ### Update the Referring Schema object(s)
    -   Update the appropriate Referring Schema object(s) to reference the CCD Cruise Leg (CEN_CRUISE.CCD_CRUISE_LEGS) table.
        -   Open [integrate_external_data_set.sql](../SQL/queries/integrate_external_data_set.sql)
        -   Replace the defined placeholders based on the comments in the SQL file for as many objects in the Referring Schema that must directly reference the CCD Cruise Leg table.
        -   Execute the generated DDL script on the Referring Schema (e.g. CEN_CTD) to define the foreign key relationship for each object. Referential integrity will be enforced for all foreign key references to CCD Cruise Legs.
3.  ### Develop methods to associate the CCD Cruise Leg data
    -   Develop methods to associate the Referring Schema data with the appropriate CCD Cruise Leg data by setting the foreign key value (CRUISE_LEG_ID) of the Referring Schema data records. For this particular data integration it is recommended to utilize the CCD CCD_CRUISE_PKG.LEG_ALIAS_TO_CRUISE_LEG_ID_FN external package function to determine the foreign key value of the given cruise leg/cruise leg alias so that developers are not required to know about the implementation details of the CCD Cruise Leg business rules. This approach allows the foreign key value to be set in an application, script, or query. There are multiple options for associating the Referring Schema data with the corresponding Cruise Leg data, the exact implementation will depend on the use case:
        -   Insert/Update queries can be used to associate the Referring Schema data with the CCD data. These queries can be implemented directly in PL/SQL scripts, packages, functions, and procedures, or in applications, or by executing them directly on the Referring Schema if there is a readily available cruise leg alias that can be translated using the CCD CCD_CRUISE_PKG.LEG_ALIAS_TO_CRUISE_LEG_ID_FN package function.
        -   In simple examples an end-user application can implement the Cruise Leg as a drop down field by directly querying from the appropriate CCD views.
            -   For example a web interface can implement the CCD CCD_CRUISE_LEGS_V view from the CCD to populate a drop down list with Cruise Leg information and use the selected Cruise Leg's associated primary key value to create the association. This approach does not require the use of the CCD CCD_CRUISE_PKG.LEG_ALIAS_TO_CRUISE_LEG_ID_FN package function.
        -   The CCD external package function can be implemented within PL/SQL package(s)/function(s) defined within the Referring Schema so the schema-specific logic can reside there.
            -   For example the CTD Data System's CTD_PKG.PARSE_CRUISE_LEG_FROM_PATH package function extracts the Cruise Leg alias from a CTD file's directory path using specific business rules and then utilizes the CCD CCD_CRUISE_PKG.LEG_ALIAS_TO_CRUISE_LEG_ID_FN external package function to translate the parsed value to the CRUISE_LEG_ID so the Referring Schema data objects can be associated with the corresponding CCD Cruise Legs.
        -   The Referring Schema package function(s) or the CCD package function can be implemented in PL/SQL package(s)/procedure(s) to associate the Referring Schema data with the corresponding CCD Cruise Legs.
            -   For example the CTD Data System's CTD_PKG.REFRESH_CAST_CRUISE_LEG package procedure utilizes the CTD Data System's CTD_PKG.PARSE_CRUISE_LEG_FROM_PATH package function to resolve the CRUISE_LEG_ID value and use it to update the existing CTD cast's associated Cruise Leg.
            -   Best practice: develop an automated method to detect the missing/mismatched Cruise Leg associations in the Referring Schema objects and refresh the associations with the appropriate CCD Cruise Legs.
                -   For example the CTD Data System's CTD_PKG.REFRESH_BLANK_MIS_CASTS package procedure queries for all CTD casts that have blank/mismatched Cruise Legs and executes the CTD Data System's CTD_PKG.REFRESH_CAST_CRUISE_LEG package procedure for those casts to update the Cruise Leg information. This package procedure is also available for execution in the CTD web application by authorized users.
        -   In more complex examples an application can implement the Referring Schema's functions/procedures to associate the Referring Schema objects with the CCD Cruise Legs
            -   For example the CTD import module utilizes the CTD data system's CTD_PKG.PARSE_CRUISE_LEG_FROM_PATH package function to determine the CRUISE_LEG_ID based on the given CTD data file path and saves that value so the module can use it when inserting the CTD cast record.
4.  ### Develop view(s) in the Referring Schema to retrieve the related CCD information
    -   Define view(s) in the given Referring Schema that relate the scientific data to the CCD data based on the foreign key relationship defined in [step 2](#update-the-referring-schema-objects) by utilizing the shared CCD views (e.g. CEN_CRUISE.CCD_CRUISE_LEGS_V).
        -   For example the CTD data system defines a CTD_CAST_CRUISES_V view that retrieves CTD cast and related Cruise Leg information using the CCD CCD_CRUISE_LEGS_V view based on the CRUISE_LEG_ID foreign key relationship. Multiple views are then based on the CTD_CAST_CRUISES_V for various purposes.
5.  ### Develop QC view(s) in the Referring Schema
    -   Develop QC view(s) in the Referring Schema to identify missing/invalid associations with the CCD Cruise Legs so these associations can be updated accordingly.
        -   Define view(s) that return records in the Referring Schema that have missing/invalid CRUISE_LEG_ID values so these record association issues can be resolved. Missing/Invalid Cruise Leg associations should be addressed before exporting the data for reporting, analysis, etc.
            -   For example the CTD data system has two QC views: CTD_QC_CAST_FILES_V that identifies missing Cruise Leg information for CTD casts and CTD_QC_CRUISE_CAST_INFO_V that identifies mismatched Cruise Leg information for CTD casts.
