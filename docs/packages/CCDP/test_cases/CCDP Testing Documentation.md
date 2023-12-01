# Centralized Cruise Database Oracle Package Testing Documentation

## Overview:
The Centralized Cruise Database (CCD) is used to track information about each PIFSC research cruise including activities, regions, etc. to remove the need for each division/program to manage this information. The CCD Oracle Package (CCDP) was developed to provide functions and stored procedures for the CCD. The stored procedures perform record operations on the database and the functions translate primary key values and return calculated values for the [Cruise Data Management Application (CRDMA)](../../../../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md). There are two different methods for test case verification: SQL and PL/SQL. The standard method for defining formal, repeatable test cases for the CCDP and verifying them are defined in this document.

## Resources:
-   [CCDP Documentation](../CCDP%20Documentation.md)
-   [CCD Documentation](../../../Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
-   [PL/SQL Coding Conventions](../../../Centralized%20Cruise%20Database%20-%20PLSQL%20Coding%20Conventions.md)
-   [CCDP Automated Test Cases](./CCDP%20Test%20Cases.xlsx)
-   [CRDMA Documentation](../../../../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md)
    -   [CRDMA CCDP Tests](../../../../CRDMA/docs/test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md)

## Requirements:
-   All SQL queries should be executed on the CEN_CRUISE schema.
-   \*\*Note: The automated test cases require these scripts to be executed on a development/test instance. Data Validation Module (DVM) rules and data will be purged from the database, to avoid data loss do not execute this on a production database.
-   The MOUSS DB must be deployed to the MOUSS schema on the same development or test database instance as the other two schemas
    -   Clone the [CCD repository](https://picgitlab.nmfs.local/centralized-data-tools/centralized-cruise-database.git) to a working directory
    -   Deploy the CCD to the CEN_CRUISE schema using the [automated installation instructions](https://picgitlab.nmfs.local/centralized-data-tools/centralized-cruise-database/-/blob/master/docs/Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md?ref_type=heads#automated-installation)

## Definitions:
-   Test Case Definitions: This [excel file](./CCDP%20Test%20Cases.xlsx) is used to define all formal test cases
-   (SQL verification only) Verification Templates: These excel files ([verification_templates](./verification_templates)) are used to list the individual test cases in a given category that are defined in the Test Case Definitions. The templates use excel formulas to verify that the results of a given script execution match the verified results.
-   Verification Exports: These files ([verification_templates\automated](./verification_templates/automated)) are used to verify the results of a given test script match the verified results using a file comparison tool to streamline the process.

## Definitions:
-   Test Case Definitions: This [excel file](./CCDP%20Test%20Cases.xlsx) is used to define all formal test cases
-   (SQL verification only) Verification Templates: These excel files ([verification_templates](./verification_templates)) are used to list the individual test cases in a given category that are defined in the Test Case Definitions. The templates use excel formulas to verify that the results of a given script execution match the verified results.
-   Verification Exports: These files ([verification_templates\automated](./verification_templates/automated)) are used to verify the results of a given test script match the verified results using a file comparison tool to streamline the process.

## Semi-Automated Test Case Verification SOP
-   \*Note: a fully automated test case verification method can be found [below](#automated-test-case-verification-sop)
-   \*Note: the semi-automated test cases are intended to be executed using Oracle SQL Developer
-   Setup Test Cases:
    -   Purge MOUSS DB and DVM records from the database
        -   Execute [delete_all_DVM_recs.sql](../../../../SQL/queries/delete_all_DVM_recs.sql)
        -   Execute [delete_ref_data.sql](../../../../SQL/queries/delete_ref_data.sql)
    -   Load test data
        -   Execute the corresponding test CCD data and DVM rule loading scripts
-   Automated Verification:
    -   (SQL verification only) Export the data from the database after the CCDP and DVM scripts have been executed on the test data and compare it to the Verification Exports.
        -   SOP:
            -   Execute the corresponding CCD DVM (CDVM) and CCDP test script(s)
            -   Generate the data reports (execute the [validation issue verification query](#validation-issue-verification-query) for the given test case category and export the results in a .csv file with the specified naming convention)
            -   Open a diff tool (e.g. WinMerge) and compare the exported query results (e.g. category_2_CCDP_verification_20200423.csv for a report generated on 4/23/2020) with the corresponding Verification Export (e.g. [category_2_CCDP_verification.csv](./verification_templates/automated/category_2_CCDP_verification.csv)) in the [verification_templates\automated](./verification_templates/automated) folder
                -   If the two files' content matches exactly then the test cases have been verified successfully
    -   (PL/SQL verification only)
        -   SOP:
            -   Execute the corresponding Test Cases Setup scripts
            -   Clear the "script output" window
            -   Execute the corresponding DVM test script
            -   Copy the content in "script output" and save as a temporary text file (e.g. category_1_script_output_20200716.txt)
            -   Open a diff tool (e.g. WinMerge) and compare the saved script output with the corresponding Verification Export (e.g. [category_1_script_output_verification.txt](./verification_templates/automated/category_1_script_output_verification.txt)) in the [verification_templates\automated](./verification_templates/automated) folder
                -   If the two files' content matches exactly then the test cases have been verified successfully

## Fully Automated Test Case Verification SOP
-   All tests cases defined in [Test Case Types](#test-case-types) have been completely automated using [Oracle SQL*Plus](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqpug/index.html) and the verification of the results of the automated test cases has been automated using [fc](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/fc) on Windows using the following procedure:
    -   Open a command line window
    -   cd into the [docs\packages\CCDP\test_cases\SQL](./SQL) directory
    -   Start SQL*Plus with the "nolog" option:

        ```
        sqlplus /nolog
        ```

    -   Execute the [verification_data_export.sql](./SQL/verification_data_export.sql) with the following command:

        ```
        @verification_data_export.sql
        ```

    -   Specify the credentials for the database instance and schema in the following format:

        ```
        USER/PASSWORD@HOSTNAME/SID
        ```

    -   When the scripts have finished executing the .csv and .txt test case output files are located in [verification_templates/automated](./verification_templates/automated) with a "-2" suffix before the file extension (e.g. category_2_CCDP_verification-2.csv)
    -   Execute the [verification_script.bat](./verification_templates/automated/verification_script.bat)
        -   This script uses fc to confirm the expected results of each test case category (e.g. [category_2_CCDP_verification.csv](./verification_templates/automated/category_2_CCDP_verification.csv)) matches the actual results of the corresponding test case category (e.g. category_2_CCDP_verification-2.csv) and saves the results in file_compare_script_output_verification-2.txt
        -   The script will then compare the expected output for all test case categories [file_compare_script_output_verification.txt](./verification_templates/automated/file_compare_script_output_verification.txt) with the actual results of all test case categories (file_compare_script_output_verification-2.txt)
    -   Verify that the output of the script indicates that file_compare_script_output_verification.txt and file_compare_script_output_verification-2.txt are identical:

        ```
        Comparing files file_compare_script_output_verification.txt and FILE_COMPARE_SCRIPT_OUTPUT_VERIFICATION-2.TXT
        FC: no differences encountered
        ```

## Test Case Definition SOP:
-   Update the Test Case Definitions in the [CCDP Test Cases](./CCDP%20Test%20Cases.xlsx) workbook to add the expected results for the new test cases in the corresponding section based on the type of test case
-   SQL Verification:
    -   Update the corresponding [verification_templates](./verification_templates) file(s) to add the expected result for the new test cases
        -   Description: These Verification Templates translate the individual test cases in a given category defined in the [Test Case Definitions](./CCDP%20Test%20Cases.xlsx) into their corresponding query results so they can be compared with the query results from subsequent script executions. These template files contain excel formulas to compare the expected verified results with the actual results of a given script execution.
        -   SOP:
            -   Update the corresponding test data loading script (e.g. [category_1_load_test_data.sql](./SQL/category_1_load_test_data.sql)) and DVM rule script (e.g. [category_1_load_DVM_rules.sql](../../CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)) to load database records necessary to setup the test case conditions that can be used to verify that the expected outcome was produced.
                -   [Cruise_Leg_DDL_DML_generator](../../../Cruise_Leg_DDL_DML_generator.xlsx) can be used to generate the DML to load the DVM test data records in to the corresponding data loading script
                -   **Note: do not include any database fields in the verification queries that have a random element like primary key values or date/time values that depend on when the script was executed otherwise the automated test case verification approach will not work properly.
            -   Update the corresponding CCDP test script(s) (e.g. [category_2_exec_test_cases.sql](./SQL/category_2_exec_test_cases.sql)) to execute the new test cases and update the database accordingly.
            -   (For new test case categories only) Define a naming convention for the Verification Template and Verification Export
            -   Execute the SQL query for the given test case category and export the results in a .csv file with the specified naming convention for the Verification Export
            -   Copy the exported data from the .csv file into the "Database Export" worksheet of the corresponding verification template.
            -   Open the "verification" worksheet and search for the "false" value specifying "values" in the "Look in" option, update the excel formulas as necessary. Confirm there are no matches found, if so then the test cases have been successfully verified
    -   Replace the corresponding Verification Export .csv file in the [verification_templates\automated](./verification_templates/automated) folder and include it in the version control commit.
-   PL/SQL Verification:
    -   Update the corresponding script [Verification Export](./verification_templates/automated) file to add the expected result for the new test cases
        -   Description: These Verification Export files contain the script output for the PL/SQL verification test cases.
        -   SOP:
            -   Update the corresponding test data loading script (e.g. [category_1_load_test_data.sql](./SQL/category_1_load_test_data.sql)) and DVM rule script (e.g. [category_1_load_DVM_rules.sql](../../CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)) to load database records necessary to setup the test case conditions that can be used to verify that the expected outcome was produced.
                -   [Cruise_Leg_DDL_DML_generator](../../../Cruise_Leg_DDL_DML_generator.xlsx) can be used to generate the DML to load the test data records in to the corresponding data loading script
                -   **Note: do not include any database fields in the verification queries that has a random element like primary key values or date/time values that depend on when the script was executed otherwise the automated test case verification approach will not work properly.
            -   Update the corresponding DVM test script(s) (e.g. [category_1_exec_test_cases.sql](./SQL/category_1_exec_test_cases.sql)) to include the PL/SQL code to execute the new test cases and produce the desired script output
            -   (For new test case categories only) Define a naming convention for the Verification Export
            -   Copy the "script output" produced by the test script and save it as a text file with the specified naming convention for the Verification Export
                -   Use a diff tool to verify that the script output matches the expected results defined in the corresponding script [verification export](./verification_templates/automated) file
    -   Include the new/modified Verification Export file in the version control commit to replace the previous version (if any).
-   When adding new test case categories:
    -   Update [verification_data_export.sql](./SQL/verification_data_export.sql) to add the commands necessary to execute the test case using the corresponding scripts and output the corresponding verification file(s) in the [verification_templates/automated](./verification_templates/automated) folder
    -   Update [verification_script.bat](./verification_templates/automated/verification_script.bat) to add fc commands for each new verification file to confirm the expected and actual results match
    -   Update the expected file verification output file ([file_compare_script_output_verification.txt](./verification_templates/automated/file_compare_script_output_verification.txt)) to include the successful comparison results for the new verification file(s)
-   Update documentation (if necessary) and commit changes to the version control system.

## Test Case Types:
-   CCDP Tests
    -   Description: The [test cases workbook](./CCDP%20Test%20Cases.xlsx) lists instances of each CCDP test case for each test case category that is implemented in the CCD.
        -   The columns in each test case category worksheet are based on the information that is necessary to verify the test cases
    -   ### Category 1 Cases (PL/SQL verification)
        -   These test cases verify the different error conditions for the CCDP that can be feasibly tested are handled correctly
            -   A list of error codes that are tested in this category for the CCDP can be found in the CCDP [Business Rules](../../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) where the "Scope" column values are "CCD PKG Errors" and "Test Case Exists?" column values are "yes"
        -   Test cases setup
            -   To streamline the test case verification process a single script was compiled to purge the CCD and DVM data as well as execute all individual scripts listed below to setup the test cases for this test case category: [category_1_exec_all_scripts.sql](./SQL/category_1_exec_all_scripts.sql)
                -   Load test data:
                    -   Test data: [category_1_load_test_data.sql](./SQL/category_1_load_test_data.sql)
                    -   DVM rules: [category_1_load_DVM_rules.sql](../../CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)
        -   Test case script: [category_1_exec_test_cases.sql](./SQL/category_1_exec_test_cases.sql)
        -   Validation Issues:
            -   Worksheet name: "Category 1 Test Cases" of the [test cases workbook](./CCDP%20Test%20Cases.xlsx)
            -   Verification Export: [category_1_script_output_verification.txt](./verification_templates/automated/category_1_script_output_verification.txt)
    -   ### Category 2 Cases (SQL verification):
        -   Description: These test cases verify that the CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure is processed successfully based on the CCDP [Business Rules](../../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) where the "Scope" column values are "CCD Oracle PKG"
        -   To streamline the test case verification process a single script was compiled to purge the CCD and DVM data as well as execute the individual scripts listed below for this test case category: [category_2_exec_all_scripts.sql](./SQL/category_2_exec_all_scripts.sql)
            -   Load test data:
                -   Test data: [category_1_load_test_data.sql](./SQL/category_1_load_test_data.sql)
                -   DVM rules: [category_1_load_DVM_rules.sql](../../CDVM/test_cases/SQL/category_1_load_DVM_rules.sql)
            -   Test case script: [category_2_exec_test_cases.sql](./SQL/category_2_exec_test_cases.sql)
        -   Cruise and Associated Data:
            -   Worksheet name: "Category 2 Cruise Tests" of the [test cases workbook](./CCDP%20Test%20Cases.xlsx)
            -   Execute the [CCDP Verification Query](#CCDP_verification_query)
            -   Verification Files:
                -   Template: [category_2_CCDP_verification.xlsx](./verification_templates/category_2_CCDP_verification.xlsx)
                -   Export: [category_2_CCDP_verification.csv](./verification_templates/automated/category_2_CCDP_verification.csv)
        -   Validation Issues:
            -   Worksheet name: "Category 2 DVM Tests" of the [test cases workbook](./CCDP%20Test%20Cases.xlsx)
            -   Execute the [DVM Verification Query](#DVM_verification_query)
            -   Verification Files:
                -   Template: [category_2_DVM_verification.xlsx](./verification_templates/category_2_DVM_verification.xlsx)
                -   Export: [category_2_DVM_verification.csv](./verification_templates/automated/category_2_DVM_verification.csv)

## Functions:
-   Defining Test Cases
    -   TBD
-   Verifying Test Cases
    -   TBD

## Appendix:
-   <span id="CCDP_verification_query" class="anchor"></span>CCDP Verification Query:
> Select * from CCD_CCDP_DEEP_COPY_CMP_V order by 1, 3;
-   <span id="DVM_verification_query" class="anchor"></span>DVM Verification Query:
> select cruise_name, LEG_NAME_CD_LIST, iss_severity_code, iss_type_name, iss_type_desc, ISS_DESC, IND_FIELD_NAME from CCD_CRUISE_SUMM_ISS_V order by cruise_name, iss_severity_code, iss_type_name, TO_CHAR(iss_desc);
