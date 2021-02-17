# Cruise Data Management Application - Technical Documentation

## Overview:
The Cruise Data Management Application (CRDMA) was developed to allow all PIFSC users to view and download summary and detailed reports for PIFSC cruise operations. The CRDMA allows authorized users to manage data stored in the Centralized Cruise Database (CCD).

## Resources:
-   Version Control Information:
    -   URL: git@gitlab.pifsc.gov:centralized-data-tools/centralized-cruise-database.git in the [CRDMA](../) folder
    -   Application: 0.17 (Git tag: cen_cruise_web_app_v0.17)
-   [End User Documentation](./Cruise%20Data%20Management%20Application%20-%20End%20User%20Documentation.md)
-   [Testing Documentation](./Cruise%20Data%20Management%20Application%20-%20Testing%20Documentation.md)
    -   [Quality Assurance (QA) Testing Documentation](./test_cases/CRDMA%20QA%20Testing%20Documentation.md)
-   [Database Documentation](../../docs/Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
-   [Business Rule Documentation](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md)
    -   [Business Rule List](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx)
-   [Data Validation Module (DVM)](https://gitlab.pifsc.gov/centralized-data-tools/data-validation-module)
-   [CCD Oracle Package (CCDP) Documentation](../../docs/packages/CCDP/CCDP%20Documentation.md)
    -   [CRDMA CCDP Testing Documentation](./test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md)
-   [CCD DVM (CDVM) Documentation](../../docs/packages/CDVM/CDVM%20Documentation.md)
    -   [CDVM Testing Documentation](./test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md)

## Application URLs:
-   Development Application: http://midd.pic.gov/picd/f?p=287
-   Test Application: http://midt.pic.gov/pict/f?p=287
-   Production Application: TBD

## Requirements:
-   A connection to the PIFSC network is required to access the application
-   Google Chrome or Firefox must be used to access the application in order to avoid PIFSC SSL certificate issues
-   APEX 5.1 must be installed on the given APEX instance

## Features:
-   Installed Modules (see [Database Documentation](../../docs/Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md) for more information)

## Data Flow:
-   [Data Flow Diagram (DFD)](../../docs/DFD/Centralized%20Cruise%20DFD.pdf)
-   [DFD Documentation](../../docs/DFD/Centralized%20Cruise%20Data%20Flow%20Diagram%20Documentation.md)

## Business Rules:
-   The business rules for the CRDMA are defined in the [Business Rule Documentation](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md) and each specific business rule listed in the [Business Rule List](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a Scope of "CRDMA" apply to this module and each rule with a Scope of "CCD " apply to the underlying database

## Configuring/Installing the CRDMA Application:
-   [How to Configure the Application](./Cruise%20Data%20Management%20Application%20-%20How%20To%20Configure%20Application.md)
-   How to Install the Application:
    -   Login to the APEX application builder and click the **Import** link.
    -   Click the **Choose File** button and then navigate to the [f287.sql](../application_code/f287.sql) file and click **Open**.
    -   Click **Next**
    -   Click **Next**
    -   Choose **Change Application ID** and specify the application ID for the application
    -   Click the **Install Application** button

## DVM Issue Policies:
-   The DVM QC validation criteria is listed in the [Business Rule List](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a "Scope" of "Data QC"
-   The relevant DVM business rules (see "Rule ID" column) for the CRDMA are defined in the specific [Business Rules](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) listed below:
    -   <span id="DVM_issue_categories" class="anchor"></span>Validation Issue Categories (CR-DB-003)
    -   DVM Execution (CR-DB-005)
    -   Validation Errors (CR-DB-009)
    -   Validation Warnings (CR-DB-010)
    -   DVM Reports (CR-DB-011)
    -   QC Validation Issue Authentication (CR-DMA-001)
    -   Validation Issue Annotation Policy (CR-DMA-002)
    -   Automated Cruise Data Validation Policy (CR-DMA-007)
    -   Automated Cruise Deletion Data Validation Policy (CR-DMA-008)
    -   Validation Issue Display Policy (CR-DMA-009)
    -   Validation Issue Record Policy (CR-DMA-010)
    -   Validation Issue Application Link Policy (CR-DMA-012)
    -   Automated Cruise Leg Insertion Data Validation Policy (CR-DMA-013)
    -   Automated Cruise Leg Update Data Validation Policy (CR-DMA-014)
    -   Automated Cruise Leg Deletion Data Validation Policy (CR-DMA-015)

## Application Page Numbering Policy:
-   Public Pages: 0 - 199
-   Data Administrator Pages: 200 - 399
-   Participant Pages: 400 - 499
-   ITS Pages: 500 - 599

## Application Pages:
-   Public Pages (reporting pages - able to navigate to different cruises and view/download information):
    -   (Page ID: 1) Cruise Summary Full Summary
        -   Chart report of the number of cruises and days at sea for all fiscal years (clickable, forwards to Fiscal Year Summary page)
        -   Chart report of the number of cruises and days at sea for all survey names (clickable, forwards to Survey Name Summary page)
    -   (Page ID: 10) Fiscal Year Summary
        -   Select field to choose a given fiscal year based on the data in the database
        -   Chart report of the number of cruises and days at sea for the selected fiscal year
        -   2 Chart reports for the selected fiscal year display the number of cruises and days at sea respectively grouped by Survey Name
    -   (Page ID: 20) Survey Name Summary
        -   Select field to choose a given Survey Name based on the data in the database
        -   Chart report of the number of cruises and days at sea for the selected Survey Name
        -   2 Chart reports for the selected Survey Name display the number of cruises and days at sea respectively grouped by fiscal year
-   Data Administrator Pages (Data management pages)
    -   (Page ID: 210) Cruise List
        -   Interactive report that shows all research cruises with some aggregate information like start/end dates, days at sea, and associated cruise legs
        -   Authorized users can create a new cruise by clicking the Create button which will forward them to the View/Edit Cruise page with no cruise selected.
        -   Authorized users can view or edit a given cruise by clicking the Edit icon on a given cruise's table row which will forward them to the View/Edit Cruise page with the corresponding cruise selected.
        -   Authorized users can copy the values from an existing cruise by clicking the Copy icon on a given cruise's table row will forward them to the View/Edit Cruise page with the corresponding cruise's values in the form so they can be modified appropriately and saved. This functionality was intended to streamline data entry by allowing a similar existing cruise's values to be copied and modified instead of defining each value manually.
            -   **Note: the new cruise record is not saved until the "Create" or "Create Another" button is clicked and successfully processed.
        -   Standard interactive report tooltips are available for all columns included in the report
    -   (Page ID: 220) View/Edit Cruise
        -   Certain drop down fields (e.g. Standard Survey Name) have a corresponding "Filter List" checkbox to filter the values available; checking the box will update the select field to filter out all reference table options that are not marked as "Visible in App" and unchecking the box will display all options in the database
        -   The page accepts one parameter, a Cruise ID. If no Cruise ID is specified (click the Create button on Cruise List page) an authorized user is allowed to create a new cruise record. The data form will allow the new cruise information to be specified
            -   If the "Copy" icon was clicked on the Cruise List page the values from the corresponding Cruise will be used to populate the data form as well as the attribute forms so they can be modified by the user and saved.
                -   *Note: the Target Species - Other Species tab is populated with the other species associated with the copied Cruise. APEX does not expose unselected tab contents on the page load event so JavaScript was developed to select the other species tab and then make an Ajax request for the other species associated with the copied Cruise and uses the JavaScript API to add the rows and specify their values. The original tab is then selected again to restore the original functionality
            -   Clicking on the "Create" button will save the record and reload the page with the new cruise selected allowing the user to create records (e.g. cruise legs, target species, etc.) associated with the new cruise
            -   Clicking on the "Create Another" button will save the record and reload the page with no cruise selected to allow the user to create another cruise record.
        -   If a Cruise ID is specified (click the Edit icon on Cruise List page) an authorized user can edit the selected cruise record and all associated records.
            -   Clicking on the "Delete" button will prompt the user to confirm if they want to delete the selected cruise record. Clicking the "OK" button will attempt to delete the record but it will fail unless there are no records that reference the specified Cruise record, if it is successful the user is forwarded to the Cruise List page. Clicking the "Cancel" button will cancel the delete action.
            -   Clicking on the "Apply Changes" button will attempt to save the record and reload the page.
            -   Clicking on the "Deep Copy" button will attempt to copy the selected Cruise and all of the associated Legs as well, unsaved changes made on the Cruise data form will not be included in the copied Cruise. Following successful processing the user will be redirected to the View/Edit Cruise page for the copied Cruise so it can be modified accordingly
        -   Cruise Attributes Region Tabs:
            -   When the mouse pointer hovers over any of the Region Tabs the associated tooltip will be displayed
            -   Cruise Summary:
                -   **Note: this region is only visible if the Edit icon was clicked on the Cruise List page or if the record was just created using the "Create" button
                -   This read-only region shows aggregate information for the given cruise
            -   Cruise Legs:
                -   **Note: this region is only visible if the Edit icon was clicked on the Cruise List page or if the record was just created using the "Create" button
                -   The user can create a new cruise leg associated with the selected Cruise record by clicking the "Create" button on the Cruise Legs section
                -   The user can view or edit a given cruise leg by clicking the Edit icon on a given cruise leg's table row which will forward them to the View/Edit Cruise Leg page with the corresponding cruise leg selected
                -   Authorized users can copy the values from an existing cruise leg by clicking the Copy icon on a given leg's table row will forward them to the View/Edit Cruise Leg page with the corresponding cruise leg's values in the form so they can be modified appropriately and saved. This functionality was intended to streamline data entry by allowing a similar existing cruise leg's values to be copied and modified instead of defining each value manually.
                    -   **Note: the new cruise leg record is not saved until the "Create" or "Create Another" button is clicked and successfully processed.
            -   QC Validation Issues:
                -   **Note: this region is only visible if the Edit icon was clicked on the Cruise List page or if the record was just created using the "Create" button
                -   This region contains an interactive grid report that displays all QC validation issues identified by the DVM that are associated with the given Cruise so they can be reviewed and/or annotated.
                    -   [DVM Issue Policies](#dvm-issue-policies)
                -   Clicking on the "Apply Changes" button will attempt to save the associated records.
            -   Shuttle Fields and Preset Options:
                -   This setup is implemented for all many-to-many cruise table relationships with the following reference tables:
                    -   Primary Survey Category, Secondary Survey Category, Target Species - ESA, Target Species - MMPA, Target Species - FSSI, Expected Species Categories
                -   A shuttle field is available showing all of the options for a given reference table (e.g. Expected Species Categories). Users select records to associate with the given cruise by moving options to the right side of the field.
                -   Preset Region:
                    -   The preset region contains a select field that lists all defined presets for the given reference table.
                    -   A classic report containing the reference table options defined for the given preset is displayed below the select field.
                    -   Changing the select field value will reload the report with the corresponding reference table options defined for the chosen preset
                    -   Clicking the Select Preset button will update the shuttle field to select the options defined for the chosen preset
                -   Filtering:
                    -   Certain shuttle fields have a corresponding "Filter List?" checkbox field. Checking the box will update the shuttle field to filter out all reference table options that are not marked as "Visible in App" and unchecking the box will display all options in the database
                -   Clicking on the "Create", "Create Another", or "Apply Changes" button will also attempt to save the associated records.
            -   Target Species - Other Species
                -   This tabular form can be used to associate new target other species or edit associated target other species for the selected cruise
                -   Clicking on the "Create", "Create Another", or "Apply Changes" button will also attempt to save the associated records.
        -   Data Validation:
            -   Specific QA criteria are documented in the [Business Rules](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx), with a scope of "Data QA"
            -   Create/Create Another/Apply Changes:
                -   The following [Business Rules](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) are implemented when a Cruise record is created or saved:
                    -   Automated Cruise Data Validation Policy (CR-DMA-007)
            -   Delete:
                -   The following [Business Rules](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) are implemented for the delete Cruise functionality:
                    -   Automated Cruise Deletion Data Validation Policy (CR-DMA-008)
    -   (Page ID: 230) View/Edit Cruise Leg
        -   Certain drop down fields (e.g. Vessel) have a corresponding "Filter List" checkbox to filter the values available; checking the box will update the select field to filter out all reference table options that are not marked as "Visible in App" and unchecking the box will display all options in the database
        -   This page accepts two parameters; a Cruise ID and a Cruise Leg ID. If both parameters are blank the page displays an error message.
        -   When a Cruise ID is specified the page will display all Cruise information and specific associated record values (e.g. cruise start/end dates, number of associated legs, fiscal year, URL, etc.) for the specified Cruise.
            -   The Cruise Legs section of the page will display all associated Cruise Legs for the specified Cruise.
                -   Clicking the Edit icon next to a given Cruise Leg will reload the page with the given Cruise Leg specified.
                -   Clicking the Copy icon next to a given Cruise Leg will reload the page with the corresponding cruise leg's values in the form so they can be modified appropriately and saved. This functionality was intended to streamline data entry by allowing a similar existing cruise leg's values to be copied and modified instead of defining each value manually.
                    -   **Note: the new cruise leg record is not saved until the "Create" or "Create Another" button is clicked and successfully processed.
                -   When the mouse pointer hovers over any column heading the associated tooltip will be displayed.
        -   If only a Cruise ID is specified (click the Create button on Cruise Legs section of the View/Edit Cruise page) an authorized user is allowed to create a new cruise leg record associated with the specified cruise. The data form will allow the new cruise leg information to be specified
            -   If the "Copy" icon was clicked on the View/Edit Cruise or View/Edit Cruise Leg page the values from the corresponding Cruise Leg will be used to populate the data form as well as the attribute forms so they can be modified by the user and saved.
                -   *Note: the Leg Aliases tab is populated with the leg aliases associated with the copied Cruise Leg. APEX does not expose unselected tab contents on the page load event so JavaScript was developed to select the leg aliases tab and then make an Ajax request for the leg aliases associated with the copied Cruise Leg and uses the JavaScript API to add the rows and specify their values. The original tab is then selected again to restore the original functionality
            -   Clicking on the "Create" button will save the record and reload the page with the new cruise leg selected allowing the user to create records (e.g. regions, gear, regional ecosystems, etc.) associated with the new cruise leg
            -   Clicking on the "Create Another" button will save the record and reload the page with no cruise leg selected to allow the user to create another cruise leg record for the specified cruise.
        -   If a Cruise Leg ID is specified (click the Edit icon on Cruise Legs section of the View/Edit Cruise or View/Edit Cruise Leg pages) an authorized user can edit the selected cruise leg record and all associated records.
            -   Clicking on the "Delete" button will prompt the user to confirm if they want to delete the selected cruise leg record. Clicking the "OK" button will attempt to delete the record but it will fail unless there are no records that reference with the specified Cruise Leg record, if it is successful the user is forwarded to the Cruise List page. Clicking the "Cancel" button will cancel the delete action.
            -   Clicking on the "Apply Changes" button will attempt to save the record and reload the page
        -   Leg Attributes Region Tabs:
            -   When the mouse pointer hovers over any of the Region Tabs the associated tooltip will be displayed.
            -   Leg Summary:
                -   **Note: this region is only visible if the Edit icon was clicked on the Cruise Legs report or if the record was just created using the "Create" button
                -   This read-only region shows aggregate information for the given cruise leg
            -   QC Validation Issues:
                -   **Note: this region is only visible if the Edit icon was clicked on the View/Edit Cruise page or if the record was just created using the "Create" button
                -   This region contains an interactive grid report that displays all QC validation issues identified by the DVM that are associated with the given Leg's Cruise so they can be reviewed and/or annotated.
                    -   [DVM Issue Policies](#dvm-issue-policies)
                -   Clicking on the "Apply Changes" button will attempt to save the associated records.
            -   Shuttle Fields and Preset Options:
                -   This setup is implemented for all many-to-many cruise leg table relationships with the following reference tables:
                    -   Regional Ecosystems, Gear, Regions
                -   A shuttle field is available showing all of the options for a given reference table (e.g. Gear). Users select records to associate with the given cruise leg by moving options to the right side of the field.
                -   Preset Region:
                    -   The preset region contains a select field that lists all defined presets for the given reference table.
                    -   A classic report containing the reference table options defined for the given preset is displayed below the select field.
                    -   Changing the select field value will reload the report with the corresponding reference table options defined for the chosen preset
                    -   Clicking the Select Preset button will update the shuttle field to select the options defined for the chosen preset
                -   Filtering:
                    -   Certain shuttle fields have a corresponding "Filter List?" checkbox field. Checking the box will update the shuttle field to filter out all reference table options that are not marked as "Visible in App" and unchecking the box will display all options in the database
                -   Clicking on the "Create", "Create Another", or "Apply Changes" button will also attempt to save the associated records.
            -   Leg Aliases
                -   This tabular form can be used to create new Leg Aliases or edit existing Leg Aliases for the selected cruise leg
                -   Clicking on the "Create", "Create Another", or "Apply Changes" button will also attempt to save the associated records.
        -   Data Validation:
            -   Specific QA criteria are documented in the [Business Rules](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a "Scope" of "Data QA"
            -   Create/Create Another/Apply Changes:
                -   The following [Business Rules](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) are implemented for the corresponding Cruise Leg functionality:
                    -   Create/Create Another:
                        -   Automated Cruise Leg Insertion Data Validation Policy (CR-DMA-013)
                    -   Apply Changes:
                        -   Automated Cruise Leg Update Data Validation Policy (CR-DMA-014)
            -   Delete:
                -   The following [Business Rules](../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) are implemented for the delete Cruise Leg functionality:
                    -   Automated Cruise Leg Deletion Data Validation Policy (CR-DMA-015)
    -   (Page ID: 250) Data QC Validation Issues
        -   This page contains an interactive grid report that displays all QC validation issues identified by the DVM so they can be reviewed and/or annotated. The validation issues can be filtered by selecting values from the "Fiscal Year" and "[Issue Category](#issue_categories)" select fields, changing these values will reload the page with the filtered validation issues.
            -   [DVM Issue Policies](#dvm-issue-policies)
        -   Clicking on the "Save" button will attempt to save the modified records.
    -   Reference List Management Pages
        -   The "View" pages (e.g. View Vessels) are listed under the "Reference Lists" navigation menu item
        -   All Reference List Management pages have the same functionality for the given type of reference list:
            -   View Reference Record Page List:
                -   Page ID: 300 - 399 (e.g. Page ID: 320 - View Platform Types)
            -   View Reference Record Page:
                -   This page lists all of the records in the database for the reference record type using an interactive report with an edit icon next to each row. Clicking on the edit icon will open a modular window containing the View/Edit form with the corresponding record's information.
                    -   Clicking the "Cancel" button will close the modular window
                    -   Clicking the "Delete" button will prompt the user to confirm if they want to delete the selected record. Clicking the "OK" button will attempt to delete the record but it will fail unless there are no records that reference the specified record, if it is successful the modular window is closed and the list is updated.
                    -   Clicking the "Apply Changes" button will attempt to save the updated record values. If the values are valid the modular window will be closed.
                -   Clicking the "Create" button at the top of the report will open the modular window with a form to create the new reference record.
                    -   Clicking the "Cancel" button will close the modular window
                    -   Clicking the "Apply Changes" button will attempt to save the new record values. If the values are valid the modular window will be closed.
                -   For the Divisions page clicking a Science Center name will open the View/Edit Science Center form as a modular window
    -   Reference List Preset Management Pages
        -   The "View" pages (e.g. View Regional Ecosystems) are listed under the "Presets" navigation menu item
        -   All Preset Management pages have the same functionality for the given type of reference list:
            -   View Reference Preset Record Page List:
                -   Page ID: 400 - 499 (e.g. Page ID: 400 - View Regional Ecosystem Presets)
            -   View Reference Preset Record Page:
                -   This page lists all of the preset records in the database for the reference record type using an interactive report with an edit icon next to each row. Clicking on the edit icon will redirect the user to a View/Edit Preset Page with a form displaying the corresponding record's information.
                -   Clicking the "Create" button at the top of the report will redirect the user to a View/Edit Preset page with a blank form to create the new reference record.
            -   View/Edit Reference Preset Record Page:
                -   This page contains a form to define the given reference preset record's information (e.g. name, description). The form also contains a shuttle field that allows the user to define the corresponding reference records for the given preset record.
                    -   Certain reference tables have a "Filter List" checkbox that allows the user to toggle the filtered/full list of options in the shuttle field (e.g. ESA Target Species)
                -   Clicking the "Cancel" button will redirect the user back to the corresponding View Reference Preset Record page
                -   If the "Edit" button on the View Reference Preset Record page was clicked the user will see a "Delete" button. Clicking the "Delete" button will prompt the user to confirm if they want to delete the selected record. Clicking the "OK" button will attempt to delete the record but it will fail unless there are no records that reference the specified record, if it is successful the user is redirected to the View Reference Preset Record Page.
                    -   The "Delete" button has a tooltip to warn the user that any associated preset options will cause the given preset record deletion to fail
                -   Clicking the "Apply Changes" button will attempt to save the updated record values if the record already exists and it will attempt to save the new record values if the record does not already exist. If the values are valid the user is redirected to the View Reference Preset Record Page.
-   Login Page (Page ID: 101):
    -   Description: this is the default login page that APEX generates when a new application is created that requires authentication. No custom coding/customization has been applied to this page.

## Security:
-   Application Security:
    -   [Standard APEX Security Documentation](./security/APEX%20Security%20Documentation.md)
        -   This project utilizes the security documentation from version 0.3 (Git tag: APX_sec_v0.3) of the [APEX security project](https://gitlab.pifsc.gov/centralized-data-tools/apex_tools/-/blob/master/Security/APEX%20Security%20Documentation.md)
        -   \*\*Note: The [Application Pages](#application-pages) section outlines any exceptions to the security controls defined in the [Standard APEX Security Documentation](./security/APEX%20Security%20Documentation.md)
    -   Authentication and Authorization Policy is implemented using the Authorization Application Module and is referenced in the [Database Documentation](../../docs/Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
    -   [Principle of least privilege](https://docs.google.com/document/d/15qW2pDHM8bebmNJ76AfC-SgICKQPGmKSiUkXbrZ7OVQ/edit?usp=sharing): All of the data tables and support objects are defined in the CEN_CRUISE data schema, the APEX application's parsing schema (shadow schema) which is used to actually interact with the underlying database is CEN_CRUISE_APP. CEN_CRUISE_APP has very limited permissions on the CEN_CRUISE schema based on the required functionality of the application (see [CEN_CRUISE_APP_permissions](./CEN_CRUISE_APP_permissions.xlsx)) to implement the principle of least privilege. Both schemas have not been granted any roles in the database instance.