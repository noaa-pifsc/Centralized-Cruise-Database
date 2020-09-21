# Centralized Cruise Database Oracle Package Documentation

## Overview:
The Centralized Cruise Database (CCD) is used to track information about each PIFSC research cruise including activities, regions, etc. to remove the need for each division/program to manage this information. The CCD Oracle Package (CCDP) was developed to provide functions and stored procedures for the CCD to provide functionality for the database and associated module(s).

## Resources:
-   [CCDP Testing](./test%20cases/CCDP%20Testing%20Documentation.md)
-   [Cruise Data Management Application (CRDMA) CCDP Testing](../../../CRDMA/docs/test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md)
-   [CCD Business Rules](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20Documentation.md)
    -   [CCD Business Rule List](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx)
-   [CCD Documentation](../../Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)

## Definitions:
-   The CCDP is CCD_CRUISE_PKG

## Business Rules:
-   The relevant CCDP business rules are listed in the [Business Rule List](../../Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a "Scope" value of "CCD Oracle PKG"
-   The CCDP processing errors have a "Scope" value of "CCD PKG Errors"

## Features:
-   The CCDP backend test cases are defined in the [CCDP Testing documentation](./test%20cases/CCDP%20Testing%20Documentation.md)
-   The CRDMA CCDP test cases are defined in the [CRDMA CCDP Testing documentation](../../../CRDMA/docs/test_cases/packages/CCDP/CRDMA%20CCDP%20Testing%20Documentation.md)

## Implementation:
-   The CCDP procedures and functions are documented directly in the PL/SQL package and package body definitions
-   User Defined Exceptions were implemented for error handling in the CCDP [Business Rule List](../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) where the "Scope" column is "CCD PKG Errors"
-   The CCD_CRUISE_PKG.DEEP_COPY_CRUISE_SP procedure performs the "Deep Copy" process to copy an existing cruise and all associated records so the copy can be modified to streamline the data entry process of similar cruises.  The business rules are listed in the [Business Rule List](../../../docs/Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) with a "Scope" value of "CCD Oracle PKG" and a "Rule Name" value that begins with "Deep Copy -"
-   The CCD_CRUISE_PKG.LEG_ALIAS_TO_CRUISE_LEG_ID_FN function provides a method to easily translate a Cruise Leg alias name to the corresponding Cruise Leg for data integration purposes
-   The CCD_CRUISE_PKG.APPEND_REF_PRE_OPTS_FN function is used by the [CRDMA](../../../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md) to implement the different reference table preset options
