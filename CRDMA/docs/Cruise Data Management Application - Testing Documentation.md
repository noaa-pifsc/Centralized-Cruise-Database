# Cruise Data Management Application Testing Documentation

## Overview:
The Cruise Data Management Application (CRDMA) has a series of tests on each of the application pages to confirm that they all function as expected before deploying the application for formal testing/production use. These test cases are intended to be executed in addition to module test cases provided in the [Resources](#resources) section.

## Resources:
-   [CRDMA Documentation](./Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md)
-   [CRDMA CCD Oracle Package (CCDP) Testing](./test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md)
-   [CRDMA CCD DVM (CDVM) Testing](./test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md)
-   [CRDMA QA Testing](./test_cases/CRDMA%20QA%20Testing%20Documentation.md)

## Test Cases:
-   Page 1
    -   Confirmed that the charts and report table contents are rendered correctly
    -   Confirmed that the chart functionality is working properly
        -   Clicking on a given Fiscal Year Summary's fiscal year will forward the user page to Page 10 with the selected fiscal year selected
        -   Clicking on a given Survey Name Summary's Survey Name will forward the user page to Page 20 with the selected Survey Name selected
-   Page 10
    -   Confirmed that the charts and report table contents are rendered correctly
    -   Confirmed that the select field filtering is working properly
        -   Confirmed that select field help text is working properly
-   Page 20
    -   Confirmed that the charts and report table contents are rendered correctly
    -   Confirmed that the select field filtering is working properly
        -   Confirmed that select field help text is working properly
-   Page 210
    -   Confirmed that only authorized users can access this page
        -   Logout in new browser tab and reload page
        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and reload page
    -   Confirmed that the report functionality is working properly
        -   Confirm that the report table contents are rendered correctly
        -   Confirm help text on report table column headings work properly
        -   Confirm the Create Button opens the View/Edit Cruise Form to allow a new Cruise record to be created
        -   Confirm that the Edit link opens the View/Edit Cruise Form with the selected Cruise
        -   Confirm that the Copy link opens the View/Edit Cruise Form with the copied cruise information and cruise attributes pre-populated with the copied Cruise's information
-   Page 220
    -   Confirmed that only authorized users can access this page
        -   Logout in new browser tab and reload page
        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and reload page
    -   Confirmed that unauthorized users cannot save changes to the database
        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Create/Create Another/Apply Changes buttons
        -   Logout in new browser tab and click the Create/Create Another/Apply Changes buttons (session has expired error)
    -   Invalid Page Arguments:
        -   Confirm the page displays a "You have reached this page incorrectly" when the P220_CRUISE_ID, or P220_CRUISE_ID_COPY parameters are invalid (not a cruise_ID for an existing cruise record)
    -   View/Edit Cruise Form
        -   Confirm the tab tooltips are working properly
        -   Data Form
            -   Confirm form field tooltips are working properly
            -   Confirm the select field filtering checkbox works properly
            -   Data Model QA:
                -   Confirm required fields
                -   Confirm unique keys
        -   Confirm the different attribute presets (e.g. ESA Target Species) work properly
            -   Confirm the attribute filtering checkboxes work properly
        -   Confirm the Target Species - Other Species interactive grid works properly
            -   Confirm the tooltips are working properly
        -   New Cruise
            -   Confirm "Cruise Summary", and "QC Validation Issues", and "Cruise Legs" tabs are not visible
            -   Copy Cruise Functionality:
                -   Confirm the copied cruise information is displayed in the form and the cruise attribute information is also populated
            -   New Cruise Functionality:
                -   Confirm the cruise form has no values are pre-populated except for "Survey Type" (NMFS Survey)
            -   Confirm "Create Another" button will clear the form and allow another cruise to be created
                -   Confirm the cruise and attributes were saved successfully
                -   Confirm QC Validation Issues are added (if any warnings)
            -   Confirm "Create" button will reload the page with the new cruise selected
                -   Confirm the cruise and attributes were saved successfully
                -   Confirm QC Validation Issues are added (if any warnings)
            -   Consult [CRDMA CDVM Testing Documentation](./test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md) for a testing SOP for the "Insert Cruise" functionality
        -   Selected Cruise:
            -   Confirm "Cruise Summary", and "QC Validation Issues", and "Cruise Legs" tabs are visible
            -   Cruise Summary
                -   Confirm the cruise summary information is displayed
            -   QC Validation Issues
                -   Confirm the QC validation issues are displayed properly
                -   Confirm the tooltips work properly
                -   Confirm the "Inspect" link forwards the user to the appropriate View/Edit Cruise or Cruise Leg page for the given validation issue
                -   Confirm the issues can be annotated (Issue Resolution and Error Notes only) and saved when the "Apply Changes" button is clicked
            -   Cruise Legs
                -   Confirm the report contents are rendered correctly
                -   Confirm the tooltips work properly
                -   Create Button
                    -   Confirm the user is forwarded to the View/Edit Cruise Leg form for the selected cruise and no values are pre-populated
                -   Edit Leg
                    -   Confirm that the Edit link opens the View/Edit Cruise Leg Form with the selected Leg
                -   Copy Leg
                    -   Confirm that the Copy link opens the View/Edit Cruise Leg Form with the copied leg information and leg attributes pre-populated with the copied leg's information
            -   Update Cruise
                -   Confirm the cruise and attributes can be saved successfully
                    -   Confirm QC Validation Issues are updated
                -   Consult [CRDMA CDVM Testing Documentation](./test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md) for a testing SOP for the "Update Cruise" functionality
            -   Delete Cruise
                -   Confirm the deletion works properly if there are no related record (cruise record only)
                    -   Confirm the deletion works properly if there are attributes associated with the cruise leg and the field options are de-selected and the delete button is clicked
                -   Confirm the deletion fails if there are related records (leg or cruise attributes)
                -   Confirmed that unauthorized users cannot commit changes to the database
                    -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Delete button
                    -   Logout in new browser tab and click Delete button (session has expired error)
                -   Consult [CRDMA CDVM Testing Documentation](./test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md) for a testing SOP for the "Delete Cruise" functionality
            -   Deep Copy
                -   Confirm the tooltip is working properly
                -   Consult [CCD Oracle Package (CCDP) Testing Documentation](./test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md) for a testing SOP for the "Deep Copy" functionality
-   Page 230
    -   Confirmed that if there is no CRUISE_ID argument then the page shows a warning
    -   Confirmed that only authorized users can access this page
        -   Logout in new browser tab and reload page
        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and reload page
    -   Confirmed that unauthorized users cannot save changes to the database
        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Create/Create Another/Apply Changes buttons
        -   Logout in new browser tab and click the Create/Create Another/Apply Changes buttons (session has expired error)
    -   Invalid Page Arguments:
        -   Confirm the page displays a "You have reached this page incorrectly" when the P230_CRUISE_LEG_ID, or P230_CRUISE_LEG_ID_COPY parameters are invalid (not a cruise_leg_ID for an existing cruise leg record)
            -   This can be accomplished by opening the View/Edit Cruise Leg page with the Create Leg, Update Cruise Leg, and Copy Cruise Leg buttons and then deleting/reloading cruise/cruise leg data (e.g. execute [execute_all_CRDMA_test_scripts.sql](./test_cases/SQL/execute_all_CRDMA_test_scripts.sql))
                -   **\*\*Note**: The test data script need to be executed on a development/test instance. DVM rules and data will be purged from the database, to avoid data loss do not execute this on a production database.
    -   View/Edit Cruise Leg Form
        -   Cruise Legs
            -   Confirm that the report is rendered successfully
            -   Confirm that the tooltips are working
            -   Confirm Copy link is working
            -   Confirm Edit link is working
        -   Confirm the tab tooltips are working properly
        -   Data Form
            -   Confirm form field tooltips are working properly
            -   Confirm the select field filtering checkbox works properly
            -   Data Model QA:
                -   Confirm required fields
                -   Confirm unique keys
        -   Confirm the different attribute presets (e.g. Gear) work properly
            -   Confirm the attribute filtering checkboxes work properly
        -   Confirm the Leg Alias interactive grid works properly
            -   Confirm the tooltips are working properly
        -   New Cruise Leg
            -   Copy Cruise Leg Functionality:
                -   Confirm the copied cruise leg information is displayed in the form and the leg attribute information is also populated
            -   New Cruise Leg Functionality:
                -   Confirm the cruise leg form has no values are pre-populated
            -   Confirm "Leg Summary" tab is not visible
            -   Confirm "Create Another" button will clear the form and allow another cruise to be created
                -   Confirm the cruise leg and attributes were saved successfully
                -   Confirm QC Validation Issues are added (if any warnings)
            -   Confirm "Create" button will reload the page with the new cruise selected
                -   Confirm the cruise leg and attributes were saved successfully
                -   Confirm QC Validation Issues are added (if any warnings)
            -   Consult [CRDMA CDVM Testing Documentation](./test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md) for a testing SOP for the "Insert Cruise Leg" functionality
        -   Selected Cruise Leg:
            -   Cruise Leg Summary
                -   Confirm the cruise leg summary information is displayed
            -   QC Validation Issues
                -   Confirm the QC validation issues are displayed properly
                -   Confirm the tooltips work properly
                -   Confirm the "Inspect" link forwards the user to the appropriate View/Edit Cruise or Cruise Leg page for the given validation issue
                -   Confirm the issues can be annotated (Issue Resolution and Error Notes only) and saved when the "Apply Changes" button is clicked
            -   Update Cruise Leg
                -   Confirm the cruise leg and attributes can be saved successfully
                    -   Confirm QC Validation Issues are updated (if any)
                -   Consult [CRDMA CDVM Testing Documentation](./test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md) for a testing SOP for the "Update Cruise Leg" functionality
            -   Delete Cruise Leg
                -   Confirm the deletion works properly if there are no related record (cruise leg record only)
                    -   Confirm that the related warnings/errors are removed from cruise after deletion (if any)
                -   Confirm the deletion works properly if there are attributes associated with the cruise leg and the field options are de-selected and the delete button is clicked
                    -   Confirm that the related warnings/errors are removed from cruise after deletion (if any)
                -   Confirm the deletion fails if there are related records (leg attributes)
                -   Confirmed that unauthorized users cannot commit changes to the database
                    -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Delete button
                    -   Logout in new browser tab and click Delete button (session has expired error)
                -   Consult [CRDMA CDVM Testing Documentation](./test_cases/packages/CDVM/CRDMA%20CDVM%20Testing%20Documentation.md) for a testing SOP for the "Delete Cruise Leg" functionality

-   Page 250
    -   Confirmed that only authorized users can access this page
        -   Logout in new browser tab and reload page
        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and reload page
    -   Confirmed that unauthorized users cannot commit changes to the database
        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Save button
        -   Logout in new browser tab and click Save button (session has expired error)
    -   Confirmed that the report table contents are rendered correctly
        -   Confirmed column heading help text is working properly
        -   Confirmed that the Cruise column links redirect the user to the View/Edit Cruise page for the selected Cruise
        -   Confirm the "Inspect" link forwards the user to the appropriate View/Edit Cruise or Cruise Leg page for the given validation issue
    -   Confirmed that the select field filtering is working properly
        -   Confirmed that select field help text is working properly
    -   Apply changes for authorized user
        -   Confirmed that the record(s) are updated successfully
-   Pages 300 - 399 (Reference List Management Pages)
    -   An [inventory](./Cruise%20Data%20Management%20Application%20-%20Reference%20Preset%20Page%20Inventory.xlsx) of each page can be found on the "Reference Lists" worksheet and can be used to ensure that the test cases are confirmed on each of the CRDMA Reference List page
    -   View Reference Records Report
        -   Confirmed that only authorized users can access this page
            -   Logout in new browser tab and reload page
            -   Update user group to [remove the DATA_ADMIN role](#data_admin) and reload page
        -   Confirmed that the report table contents are rendered correctly
        -   Confirmed column heading help text is working properly
        -   Confirm Create button opens View/Edit Reference Record Form with no values except for default values (e.g. Divisions defaults Science Center to PIFSC)
        -   Update icon opens View/Edit Reference Record Form with the values loaded
        -   (When applicable) Confirm other links work properly (e.g. View Divisions page allows Science Center records to be edited by clicking on the Science Center link)
    -   View/Edit Reference Record Page
        -   Confirmed that only authorized users can access this page
            -   Logout in new browser tab and reload page
            -   Update user group to [remove the DATA_ADMIN role](#data_admin) and reload page
        -   Confirmed that unauthorized users cannot save changes to the database
            -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Create/Apply Changes button
            -   Logout in new browser tab and click Create/Apply Changes button (session has expired error)
        -   Data Form
            -   Confirm tooltips are working properly
            -   Data Model QA:
                -   Confirm required fields are enforced
                -   Confirm unique name/code value constraints are enforced
            -   New Reference Record
                -   Form is loaded with no values
                -   Create Button
                    -   Confirm the record is saved successfully
            -   Edit Reference Record
                -   Form is loaded with selected record's values
                -   Apply Changes Button
                    -   Confirm the record is updated successfully
                -   Delete Button
                    -   Confirm the deletion works properly if there are no related records (reference record only)
                    -   Confirm the deletion fails if there are related records (one or more related cruise/leg records)
                    -   Confirmed that unauthorized users cannot delete records from the database
                        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Delete button
                        -   Logout in new browser tab and click Delete button (session has expired error)
-   Pages 300 - 399 (Reference List Preset Management Pages)
    -   An [inventory](./Cruise%20Data%20Management%20Application%20-%20Reference%20Preset%20Page%20Inventory.xlsx) of each page can be found on the "Presets" worksheet and can be used to ensure that the test cases are confirmed on each of the CRDMA Reference List Preset page
    -   View Reference Preset Records Report
        -   Confirmed that only authorized users can access this page
            -   Logout in new browser tab and reload page
            -   Update user group to [remove the DATA_ADMIN role](#data_admin) and reload page
        -   Confirmed that the report table contents are rendered correctly
        -   Confirmed column heading help text is working properly
        -   Confirm Create button opens View/Edit Reference Preset Record Form with no values
        -   Update icon opens View/Edit Reference Preset Record Form with the values loaded
    -   View/Edit Reference Preset Record Page
        -   Confirmed that only authorized users can access this page
            -   Logout in new browser tab and reload page
            -   Update user group to [remove the DATA_ADMIN role](#data_admin) and reload page
        -   Confirmed that unauthorized users cannot save changes to the database
            -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Create/Apply Changes button
            -   Logout in new browser tab and click Create/Apply Changes button (session has expired error)
        -   Data Form
            -   Confirm field tooltips are working
            -   (When applicable) Confirm the Filter List functionality is working
            -   Data Model QA:
                -   Confirm required fields are enforced
                -   Confirm unique name value constraints are enforced
            -   New Preset Record
                -   Form is loaded with no values
                -   Create Button
                    -   Confirm the preset record and associated options are saved successfully
            -   Edit Preset Record
                -   Confirm delete button tooltip is working
                -   Form is loaded with selected record's values
                -   Apply Changes Button
                    -   Confirm the preset record and associated options were updated successfully
                -   Delete Button
                    -   Confirm the deletion works properly if there are no related records (preset record only)
                        -   Confirm the deletion works properly if there are options associated with the preset and the field options are de-selected and the delete button is clicked
                    -   Confirm the deletion fails if there are related records (one or more related preset options)
                    -   Confirmed that unauthorized users cannot delete records from the database
                        -   Update user group to [remove the DATA_ADMIN role](#data_admin) and then click the Delete button
                        -   Logout in new browser tab and click Delete button (session has expired error)

## Appendix:
-   <span id="data_admin" class="anchor"></span>Remove/Restore DATA_ADMIN role:

```
--to setup test
DELETE FROM AUTH_APP_USER_GROUPS where app_user_id IN (SELECT APP_USER_ID FROM AUTH_APP_USERS WHERE APP_USER_NAME = :username) AND APP_GROUP_ID IN (SELECT APP_GROUP_ID FROM AUTH_APP_GROUPS WHERE APP_GROUP_CODE = 'DATA_ADMIN');

--to restore after test
INSERT INTO AUTH_APP_USER_GROUPS (APP_USER_ID, APP_GROUP_ID) VALUES ((SELECT APP_USER_ID FROM AUTH_APP_USERS WHERE APP_USER_NAME = :username), (SELECT APP_GROUP_ID FROM AUTH_APP_GROUPS WHERE APP_GROUP_CODE = 'DATA_ADMIN'));
```