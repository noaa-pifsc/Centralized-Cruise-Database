# Cruise Data Management Application Quality Assurance Testing Documentation

## Overview:
The Cruise Data Management Application (CRDMA) was developed to allow all PIFSC users to view and download summary and detailed reports for PIFSC cruise operations. The CRDMA allows authorized users to manage data stored in the Centralized Cruise Database (CCD). This document defines the test cases for the data quality assurance (QA) criteria implemented in the CRDMA.

## Resources:
-   [CRDMA Documentation](../Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md)
-   [CCD Documentation](../../../docs/Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
-   [CCD Business Rules](../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md)

## Requirements:
-   All SQL queries should be executed on the CEN_CRUISE schema.
-   The SOPs require the processes to be completed using Oracle SQL Developer.
-   **\*\*Note**: The test cases require these scripts to be executed on a development/test instance. DVM rules and data will be purged from the database, to avoid data loss do not execute this on a production database.

## Definitions:
-   The QA criteria for the CRDMA is defined in the [CCD Business Rules](../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md) where "Scope" is "Data QA"
-   Test Case Definitions: This excel file is used to define all formal CRDMA QA test cases ([CRDMA_QA_test_cases.xlsx](./CRDMA_QA_test_cases.xlsx))

## Test Case Verification SOP:
-   Setup Test Cases:
    -   For convenience the [execute_all_CRDMA_test_scripts.sql](./SQL/execute_all_CRDMA_test_scripts.sql) is provided to execute all of the test case setup scripts:
        -   Delete the DVM data (for any existing Cruises being purged)
            -   Execute [delete_DVM_data.sql](../../../SQL/queries/delete_DVM_data.sql)
        -   Purge CCD data from the database
            -   Execute [delete_ref_data.sql](../../../SQL/queries/delete_ref_data.sql)
        -   Load test data
            -   Execute [load_CRDMA_test_data.sql](./SQL/load_CRDMA_test_data.sql)
-   Verification:
    -   Execute all test cases defined in the [CRDMA_QA_test_cases](./CRDMA_QA_test_cases.xlsx) document using the CRDMA
    -   Column Descriptions:
        -   CRDMA Page: contains the CRDMA page name that is being tested
        -   QA Validation Rule: the name of the QA Validation Rule, this is also listed on the [Business Rule List](../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) where "Scope" is "CRDMA" and the "Rule Name" begins with "Data QA"
        -   Description: contains the sequence of actions to evaluate the given test case
        -   Defined Value(s): contains the values that should be used when evaluating the test case to ensure the defined test case conditions are fulfilled
        -   Expected Result: contains the expected result of the test case that will be confirmed after the taking the actions defined in "Description"

## Test Case Definition SOP:
-   Update the Test Case Definitions in the [CRDMA_QA_Test_Cases](./CRDMA_QA_test_cases.xlsx) spreadsheet to add the necessary information for all new test cases so they can be verified
    -   Consult the [Business Rule List](../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) to ensure that all CRDMA business rules with a "Scope" value of "Data QA" are included in the [CRDMA_QA_Test_Cases](./CRDMA_QA_test_cases.xlsx) spreadsheet and vice versa
-   Update the [load_CRDMA_test_data.sql](./SQL/load_CRDMA_test_data.sql) test data loading script to load database records necessary to setup the test case conditions that can be used to verify that the expected result was produced.
    -   [Cruise_Leg_DDL_DML_generator](../../../docs/Cruise_Leg_DDL_DML_generator.xlsx) can be used to generate the DML to load the CRDMA test data records [load_CRDMA_test_data.sql](./SQL/load_CRDMA_test_data.sql) script
-   Update documentation (if necessary) and commit changes to the version control system.
