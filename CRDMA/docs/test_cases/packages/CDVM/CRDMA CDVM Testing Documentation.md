# Cruise Data Management Application Data Validation Module Testing Documentation

## Overview:
The Cruise Data Management Application (CRDMA) has a series of tests on each of the application pages to confirm that they all function as expected before deploying the application for formal testing/production use. These Centralized Cruise Database (CCD) Data Validation Module (CDVM) test cases are intended to test the CDVM error handling and successful test cases that are feasible in the CRDMA.  The standard method for defining formal, repeatable test cases and verifying them are defined in this document for the CDVM in the CRDMA.

## Resources:
-   [CRDMA Testing](../../../Cruise%20Data%20Management%20Application%20-%20Testing%20Documentation.md)
-   [CDVM Documentation](../../../../../docs/packages/CDVM/CDVM%20Documentation.md)

## Requirements:
-   All SQL queries should be executed on the CEN_CRUISE schema.
-   This SOP requires the processes to be completed using Oracle SQL Developer.
-   **\*\*Note**: The test cases require these scripts to be executed on a development/test instance. DVM rules and data will be purged from the database, to avoid data loss do not execute this on a production database.

## Definitions:
-   Test Case Definitions: This [excel file](./CRDMA%20CDVM%20Test%20Cases.xlsx) is used to define all formal test cases
-   (SQL verification only) Verification Templates: These excel files ([verification_templates](./verification_templates)) are used to list the individual test cases in a given category that are defined in the Test Case Definitions. The templates use excel formulas to verify that the results of a given script execution match the verified results.
-   Verification Exports: These files ([verification_templates\automated](./verification_templates/automated)) are used to verify the results of a given test script match the verified results using a file comparison tool to streamline the process.

## Test Case Verification SOP:
-   Setup Test Cases:
    -   Purge CCD and DVM records from the database
        -   Execute [delete_all_DVM_recs.sql](../../../../../SQL/queries/delete_all_DVM_recs.sql)
        -   Execute [delete_ref_data.sql](../../../../../SQL/queries/delete_ref_data.sql)
    -   Load test data
        -   Execute the corresponding test CCD data and DVM rule loading scripts
-   Automated Verification:
    -   (SQL verification only) Export the data from the database after the DVM has been executed on the test data and compare it to the Verification Exports.
        -   SOP:
            -   Execute the corresponding DVM test script(s)
            -   Generate the data reports
                -   Execute the [validation issue verification query](#validation-issue-verification-query) for the given test case category and export the results in a .csv file with the specified naming convention
            -   Open a diff tool (e.g. WinMerge) and compare the exported query results (e.g. category_1_DVM_issue_verification20200423.csv for a report generated on 4/23/2020) with the corresponding Verification Export (e.g. [category_1_CRDMA_CDVM_issue_verification.csv](./verification_templates/automated/category_1_CRDMA_CDVM_issue_verification.csv)) in the [verification_templates\automated](./verification_templates/automated) folder
                -   If the two files' content matches exactly then the test cases have been verified successfully
-   Manual Verification:
    -   SOP:
        -   Perform the defined actions in the CRDMA for the corresponding worksheet of the [test cases workbook](./CRDMA%20CDVM%20Test%20Cases.xlsx):
        -   Confirm the message displayed in the CRDMA matches the "Expected Result" column value for each Cruise

## Test Case Definition SOP:
-   Update the Test Case Definitions in the [CRDMA CDVM Test Cases](./CRDMA%20CDVM%20Test%20Cases.xlsx) workbook to add the expected results for the new test cases in the corresponding section based on the type of test case
-   SQL Verification:
    -   Update the corresponding [verification_templates](./verification_templates) file(s) to add the expected result for the new test cases
        -   Description: These Verification Templates translate the individual test cases in a given category defined in the Test Case Definitions into their corresponding query results so they can be compared with the query results from subsequent script executions. These template files contain excel formulas to compare the expected verified results with the actual results of a given script execution.
        -   SOP:
            -   Update the corresponding test data loading script (e.g. [category_5_load_test_data.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_5_load_test_data.sql)) and DVM rule script (e.g. [category_1_load_DVM_rules.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)) to load database records necessary to setup the test case conditions that can be used to verify that the expected outcome was produced.
                -   [Cruise_Leg_DDL_DML_generator](../../../../../docs/Cruise_Leg_DDL_DML_generator.xlsx) can be used to generate the DML to load the DVM test data records in to the corresponding data loading script
                -   **Note: do not include any database fields in the verification queries that have a random element like primary key values or date/time values that depend on when the script was executed otherwise the automated test case verification approach will not work properly.
            -   Update the corresponding DVM test script(s) (e.g. [category_1_exec_DVM.sql](./SQL/category_1_exec_DVM.sql)) to execute the new test cases and update the database accordingly.
            -   (For new test case categories only) Define a naming convention for the Verification Template and Verification Export
            -   Execute the SQL query for the given test case category and export the results in a .csv file with the specified naming convention for the Verification Export
            -   Copy the exported data from the .csv file into the "Database Export" worksheet of the corresponding verification template.
            -   Open the "verification" worksheet and search for the "false" value specifying "values" in the "Look in" option, update the excel formulas as necessary. Confirm there are no matches found, if so then the test cases have been successfully verified
    -   Replace the corresponding Verification Export .csv file in the [verification_templates\automated](./verification_templates/automated) folder and include it in the version control commit.
-   Manual Verification:
    -   Description: The entries in the [CRDMA CDVM Test Cases](./CRDMA%20CDVM%20Test%20Cases.xlsx) workbook define the expected results of a given test case defined in the corresponding worksheet based on the type of test case
    -   SOP:
        -   Update the corresponding test data loading script (e.g. [category_1_load_test_data.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_test_data.sql)) and DVM rule script (e.g. [category_1_load_DVM_rules.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)) to load database records necessary to setup the test case conditions that can be used to verify that the expected outcome was produced.
            -   [Cruise_Leg_DDL_DML_generator](../../../../../docs/Cruise_Leg_DDL_DML_generator.xlsx) can be used to generate the DML to load the DVM test data records in to the corresponding data loading script
        -   Execute the actions in the CRDMA that are defined in the corresponding test case category listed in the [Test Case Types](#test-case-types)
        -   Manually verify that the results in the CRDMA match the "Expected Result" column value for each test case
-   Update documentation (if necessary) and commit changes to the version control system.

## Test Case Types:
-   The [test cases workbook](./CRDMA%20CDVM%20Test%20Cases.xlsx) lists instances of each CRDMA CDVM test case for each test case category that is implemented in the CCD.
    -   The columns in each test case category worksheet are based on the information that is necessary to verify the test cases
-   Category 1 Cases (SQL verification)
    -   Description: These test cases verify the CCD [business rules](../../../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) that address the automatic DVM execution for overlapping cruises and inserted/updated cruises and cruise legs as well as deleting cruises and cruise legs to ensure the DVM data is kept up-to-date have been implemented successfully in the CDVM.   
    -   Specific CCD business rules tested in this category:
        -   DVM Cruise Insertions/Updates (CR-DB-015)
        -   DVM Cruise Deletions (CR-DB-016)
        -   DVM Cruise Leg Insertion (CR-DB-012)
        -   DVM Cruise Leg Updates (CR-DB-013)
        -   DVM Cruise Leg Deletions (CR-DB-014)
    -   Specific CDVM business rules verified in this category:
        -   CDVM Cruise Insertions/Updates (CR-DVM-006)
        -   CDVM Cruise Deletions (CR-DVM-007)
        -   CDVM Cruise Leg Insertion (CR-DVM-002)
        -   CDVM Cruise Leg Pre Update (CR-DVM-003)
        -   CDVM Cruise Leg Post Update (CR-DVM-004)
        -   CDVM Cruise Leg Deletions (CR-DVM-005)
    -   Specific CRDMA business rules tested in this category:
        -   Automated Cruise Data Validation Policy (CR-DMA-007)
        -   Automated Cruise Deletion Data Validation Policy (CR-DMA-008)
        -   Automated Cruise Leg Insertion Data Validation Policy (CR-DMA-013)
        -   Automated Cruise Leg Update Data Validation Policy (CR-DMA-014)
        -   Automated Cruise Leg Deletion Data Validation Policy (CR-DMA-015)
    -   To streamline the test case verification process a single script was compiled to purge the CCD and DVM data as well as execute the individual scripts listed below for this test case category: [category_1_exec_all_scripts.sql](./SQL/category_1_exec_all_scripts.sql)
        -   Load test data:
            -   Test data: [category_5_load_test_data.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_5_load_test_data.sql)
            -   DVM rules: [category_1_load_DVM_rules.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)
            -   Execute the DVM script: [category_1_exec_DVM.sql](./SQL/category_1_exec_DVM.sql)
    -   Perform the following actions in the CRDMA for the corresponding worksheets of the [test cases workbook](./CRDMA%20CDVM%20Test%20Cases.xlsx):
        -   Open the "Category 1 DVM Tests" worksheet and execute the indicated process for each of the cruises or cruise legs listed on the spreadsheet:
            -   Insert Cruise:
                -   Create the cruise with the indicated Cruise Name and information in the "Extra Notes" column
            -   Update Cruise:
                -   Update the cruise with the indicated Cruise Name and information in the "Extra Notes" column
            -   Delete Cruise:
                -   Delete the cruise with the indicated Cruise Name
            -   Insert Cruise Leg:
                -   Create the cruise leg for the corresponding cruise name with the values in the "Extra Notes" column
            -   Update Cruise Leg:
                -   Update the cruise leg for the corresponding leg name with the values in the "Extra Notes" column
            -   Delete Cruise Leg:
                -   Create the cruise leg with the indicated Leg name
    -   Validation Issues:
        -   Execute the [Validation Issue Verification Query](#validation-issue-verification-query)
        -   Verification Files:
            -   Template: [category_1_CRDMA_CDVM_issue_verification.xlsx](./verification_templates/category_1_CRDMA_CDVM_issue_verification.xlsx)
            -   Export: [category_1_CRDMA_CDVM_issue_verification.csv](./verification_templates/automated/category_1_CRDMA_CDVM_issue_verification.csv)
-   Category 2 Cases (Manual verification)
    -   Description: These test cases verify that the CCD_DVM_PKG package procedures' error handling test cases that are feasible to test in the CRDMA based on the [CDVM Business Rules](../../../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) where the "Scope" column values are "CCD Custom DVM Errors" and "Test Case Exists?" column values are "yes"
    -   To streamline the test case verification process a single script was compiled to purge the CCD and DVM data as well as execute the individual scripts listed below for this test case category: [category_2_exec_all_scripts.sql](./SQL/category_2_exec_all_scripts.sql)
        -   Load test data:
            -   Test data: [category_1_load_test_data.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_test_data.sql)
            -   DVM rules: [category_1_load_DVM_rules.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)
    -   Perform the following actions in the CRDMA for the corresponding worksheets of the [test cases workbook](./CRDMA%20CDVM%20Test%20Cases.xlsx):
        -   Open the "Category 2 DVM Tests" worksheet and execute the following process for each of the cruises listed on the spreadsheet:
            -   For "Delete Leg Overlap" test cases open the View/Edit Cruise Leg page for the specified Leg Name and click the "Delete" button and click the "OK" button to confirm
            -   For "Delete Cruise" test cases open the View/Edit Cruise page for the specified Cruise Name and click the "Delete" button and click the "OK" button to confirm
            -   Confirm the error message displayed matches the "Expected Result" column value for each Cruise

## Appendix:
-   ### Validation Issue Verification Query
> select cruise_name, LEG_NAME_CD_LIST, iss_severity_code, iss_type_name, iss_type_desc, ISS_DESC, IND_FIELD_NAME from CCD_CRUISE_SUMM_ISS_V order by cruise_name, iss_severity_code, iss_type_name, TO_CHAR(iss_desc);
