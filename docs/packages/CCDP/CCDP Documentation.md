# Centralized Cruise Database Oracle Package Documentation

## Overview:
The Centralized Cruise Database (CCD) is used to track information about each PIFSC research cruise including activities, regions, etc. to remove the need for each division/program to manage this information. The CCD Oracle Package (CCDP) was developed to provide functions and stored procedures for the CCD to provide functionality for the database and associated module(s).

## Resources:
-   [CCDP Testing](./test%20cases/CCDP%20Testing%20Documentation.md)
-   [Cruise Data Management Application (CRDMA) CCDP Testing](../../../CRDMA/docs/test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md)
-   [CCD Documentation](../../Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
-   [CCD Business Rules](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md)
    -   [CCD Business Rule List](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx)

## Definitions:
-   The CCDP is CCD_CRUISE_PKG

## Business Rules:
-   The relevant CCDP business rules are listed in the [Business Rule List](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a "Scope" value of "CCD Oracle PKG"
-   The CCDP processing errors have a "Scope" value of "CCD PKG Errors"

## Features:
-   The CCDP backend test cases are defined in the [CCDP Testing documentation](./test%20cases/CCDP%20Testing%20Documentation.md)
-   The CRDMA CCDP test cases are defined in the [CRDMA CCDP Testing documentation](../../../CRDMA/docs/test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md)

## Implementation:
-   The CCDP procedures and functions are documented directly in the PL/SQL package and package body definitions including example PL/SQL to execute the procedures
-   User Defined Exceptions that were implemented for error handling in the CCDP are defined in the [Business Rule List](../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a "Scope" value of "CCD PKG Errors"
