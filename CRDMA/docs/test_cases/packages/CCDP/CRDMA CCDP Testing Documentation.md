# Cruise Data Management Application Centralized Cruise Database Oracle Package Testing Documentation

## Overview:
The Cruise Data Management Application (CRDMA) has a series of tests on each of the application pages to confirm that they all function as expected before deploying the application for formal testing/production use. These Centralized Cruise Database (CCD) Oracle Package (CCDP) test cases are intended to test the CCDP error handling and successful test cases that are feasible in the CRDMA.  The standard method for defining formal, repeatable test cases and verifying them are defined in this document for the CCDP in the CRDMA.

## Resources:
-   [CRDMA Testing](../../../Cruise%20Data%20Management%20Application%20-%20Testing%20Documentation.md)
-   [CCDP Documentation](../../../../../docs/packages/CCDP/CCDP%20Documentation.md)

## Requirements:
-   All SQL queries should be executed on the CEN_CRUISE schema.
-   This SOP requires the processes to be completed using Oracle SQL Developer.
-   **\*\*Note**: The test cases require these scripts to be executed on a development/test instance. DVM rules and data will be purged from the database, to avoid data loss do not execute this on a production database.

## Definitions:
-   Test Case Definitions: This [excel file](./CRDMA%20CCDP%20Test%20Cases.xlsx) is used to define all formal test cases
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
    -   (SQL verification only) Export the data from the database after the CCDP has been executed on the test data using the CRDMA and compare it to the Verification Exports.
        -   SOP:
            -   Execute the corresponding CCDP test(s)
            -   Generate the data reports
                -   Execute the corresponding verification query (e.g. [CCDP verification query](#CCDP_verification_query)) for the given test case category and export the results in a .csv file with the specified naming convention
            -   Open a diff tool (e.g. WinMerge) and compare the exported query results (e.g. category_2_CRDMA_CCDP_verification20200423.csv for a report generated on 4/23/2020) with the corresponding Verification Export (e.g. [category_2_CRDMA_CCDP_verification.csv](./verification_templates/automated/category_2_CRDMA_CCDP_verification.csv)) in the [verification_templates\automated](./verification_templates/automated) folder
                -   If the two files' content matches exactly then the test cases have been verified successfully
-   Manual Verification:
    -   SOP:
        -   Perform the defined actions in the CRDMA for the corresponding worksheet of the [test cases workbook](./CRDMA%20CCDP%20Test%20Cases.xlsx):
        -   Confirm the message displayed in the CRDMA matches the "Expected Result" column value for each Cruise

## Test Case Definition SOP:
-   Update the Test Case Definitions in the [CCDP Test Cases](./CRDMA%20CCDP%20Test%20Cases.xlsx) workbook to add the expected results for the new test cases in the corresponding worksheet based on the type of test case
-   SQL Verification:
    -   Update the corresponding [verification_templates](./verification_templates) file(s) to add the expected result for the new test cases
        -   Description: These Verification Templates translate the individual test cases in a given category defined in the [Test Case Definitions](./CRDMA%20CCDP%20Test%20Cases.xlsx) into their corresponding query results so they can be compared with the query results from subsequent script executions. These template files contain excel formulas to compare the expected verified results with the actual results of a given script execution.
        -   SOP:
            -   Update the corresponding test data loading script (e.g. [category_1_load_test_data.sql](../../../../../docs/packages/CCDP/test_cases/SQL/category_1_load_test_data.sql)) and DVM rule script (e.g. [category_1_load_DVM_rules.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)) to load database records necessary to setup the test case conditions that can be used to verify that the expected outcome was produced.
                -   [Cruise_Leg_DDL_DML_generator](../../../../../docs/Cruise_Leg_DDL_DML_generator.xlsx) can be used to generate the DML to load the DVM test data records in to the corresponding data loading script
                -   **Note: do not include any database fields in the verification queries that have a random element like primary key values or date/time values that depend on when the script was executed otherwise the automated test case verification approach will not work properly.
            -   Execute the actions in the CRDMA that are defined in the corresponding test case Category listed in the [Test Case Types](#test-case-types)
            -   Execute the SQL query for the given test case category and export the results in a .csv file with the specified naming convention for the Verification Export
            -   Copy the exported data from the .csv file into the "Database Export" worksheet of the corresponding verification template.
            -   Open the "verification" worksheet and search for the "false" value specifying "values" in the "Look in" option, update the excel formulas as necessary. Confirm there are no matches found, if so then the test cases have been successfully verified
    -   Replace the corresponding Verification Export .csv file in the [verification_templates\automated](./verification_templates/automated) folder and include it in the version control commit.
-   Manual Verification:
    -   Description: The entries in the [CCDP Test Cases](./CRDMA%20CCDP%20Test%20Cases.xlsx) workbook define the expected results of a given test case defined in the corresponding worksheet based on the type of test case
    -   SOP:
        -   Update the corresponding test data loading script (e.g. [category_1_load_test_data.sql](../../../../../docs/packages/CCDP/test_cases/SQL/category_1_load_test_data.sql)) and DVM rule script (e.g. [category_1_load_DVM_rules.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)) to load database records necessary to setup the test case conditions that can be used to verify that the expected outcome was produced.
            -   [Cruise_Leg_DDL_DML_generator](../../../../../docs/Cruise_Leg_DDL_DML_generator.xlsx) can be used to generate the DML to load the DVM test data records in to the corresponding data loading script
        -   Execute the actions in the CRDMA that are defined in the corresponding test case category listed in the [Test Case Types](#test-case-types)
        -   Manually verify that the results in the CRDMA match the "Expected Result" column value for each test case
-   Update documentation (if necessary) and commit changes to the version control system.

## Test Case Types:
-   The [test cases workbook](./CRDMA%20CCDP%20Test%20Cases.xlsx) lists instances of each CRDMA CCDP test case for each test case category that is implemented in the CCD.
    -   The columns in each test case category worksheet are based on the information that is necessary to verify the test cases
-   Category 1 Cases (Manual verification)
    -   Description: These test cases verify that the CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure error handling test cases that are feasible to test in the CRDMA based on the [CCDP Business Rules](../../../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) where the "Scope" column values are "CCD PKG Errors" and "Test Case Exists?" column values are "yes"
    -   To streamline the test case verification process a single script was compiled to purge the CCD and DVM data as well as execute the individual scripts listed below for this test case category: [category_1_exec_all_scripts.sql](./SQL/category_1_exec_all_scripts.sql)
        -   Load test data:
            -   Test data: [category_1_load_test_data.sql](../../../../../docs/packages/CCDP/test_cases/SQL/category_1_load_test_data.sql)
            -   DVM rules: [category_1_load_DVM_rules.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)
    -   Perform the following actions in the CRDMA for the corresponding worksheets of the [test cases workbook](./CRDMA%20CCDP%20Test%20Cases.xlsx):
        -   Open the "Category 1 Test Cases" worksheet and execute the following process for each of the cruises listed on the spreadsheet:
            -   Open the View/Edit Cruise page for the specified Cruise
            -   Click the "Deep Copy" button
            -   Confirm the error message displayed matches the "Expected Result" column value for each Cruise
-   Category 2 Cases (SQL verification):
    -   Description: These test cases verify that the CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure is processed successfully in the CRDMA based on the CCDP [Business Rules](../../../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) where the "Scope" column values are "CCD Oracle PKG"
    -   To streamline the test case verification process a single script was compiled to purge the CCD and DVM data as well as execute the individual scripts listed below for this test case category: [category_2_exec_all_scripts.sql](./SQL/category_2_exec_all_scripts.sql)
        -   Load test data:
            -   Test data: [category_1_load_test_data.sql](../../../../../docs/packages/CCDP/test_cases/SQL/category_1_load_test_data.sql)
            -   DVM rules: [category_1_load_DVM_rules.sql](../../../../../docs/packages/CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)
    -   Perform the actions in the CRDMA for the corresponding worksheet of the [test cases workbook](./CRDMA%20CCDP%20Test%20Cases.xlsx):
        -   Open the "Category 2 Cruise Tests" worksheet and execute the following process for each of the cruises listed on the spreadsheet:
            -   Open the View/Edit Cruise page for the specified Cruise
            -   Click the "Deep Copy" button
            -   Confirm the success message displayed matches the "Expected Result" column value for each Cruise
            -   Confirm the View/Edit Cruise page is opened to the newly copied Cruise
    -   Verify the Cruise and associated data:
        -   Worksheet name: "Category 2 Cruise Tests"
        -   Execute the [CCDP Verification Query](#CCDP_verification_query)
        -   Verification Files:
            -   Template: [category_2_CRDMA_CCDP_verification.xlsx](./verification_templates/category_2_CRDMA_CCDP_verification.xlsx)
            -   Export: [category_2_CRDMA_CCDP_verification.csv](./verification_templates/automated/category_2_CRDMA_CCDP_verification.csv)
    -   Verify the Validation Issues:
        -   Worksheet name: "Category 2 DVM Tests"
        -   Execute the [DVM Verification Query](#DVM_verification_query)
        -   Verification Files:
            -   Template: [category_2_CRDMA_DVM_verification.xlsx](./verification_templates/category_2_CRDMA_DVM_verification.xlsx)
            -   Export: [category_2_CRDMA_DVM_verification.csv](./verification_templates/automated/category_2_CRDMA_DVM_verification.csv)

## Appendix:
-   <span id="CCDP_verification_query" class="anchor"></span>CCDP Verification Query:
> Select * from CCD_CCDP_DEEP_COPY_CMP_V order by 1, 3;
-   <span id="DVM_verification_query" class="anchor"></span>DVM Verification Query:
> select cruise_name, LEG_NAME_CD_LIST, iss_severity_code, iss_type_name, iss_type_desc, ISS_DESC, IND_FIELD_NAME from CCD_CRUISE_SUMM_ISS_V order by cruise_name, iss_severity_code, iss_type_name, TO_CHAR(iss_desc);
