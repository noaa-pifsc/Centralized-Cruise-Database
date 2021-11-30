# Centralized Cruise Database Business Rule Documentation

## Overview:
There are multiple modules that utilize the Cruise database for various purposes and each module has its own set of business rules that only apply to that module. In addition there are some business rules that apply to the underlying database and therefore all associated modules. The [Business Rule List](./Centralized%20Cruise%20Database%20-%20Business%20Rule%20List.xlsx) shows each of the specific business rules that apply to the given defined scope.

## Scope Descriptions:
-   Cruise DB - these business rules apply to the underlying shared database that is used by all associated Cruise application modules
-   Data QC - these business rules are the specific quality control (QC) validation criteria implemented on the Cruise database using the [Data Validation Module (DVM)](https://github.com/PIFSC-NMFS-NOAA/PIFSC-DataValidationModule)
-   CRDMA - these business rules apply to the Cruise Data Management Application (CRDMA) and the way the application functions
-   Data QA - these business rules are the specific quality assurance (QA) validation criteria implemented on the Cruise database using the CRDMA
-   CCD Oracle PKG - these business rules apply to the [CCD Oracle Package (CCDP)](./packages/CCDP/CCDP%20Documentation.md)
-   CCD PKG Errors - these business rules apply to error conditions while executing the [CCDP](./packages/CCDP/CCDP%20Documentation.md)
-   CCD Custom DVM - these business rules apply to the [CCD Custom DVM (CDVM)](./packages/CDVM/CDVM%20Documentation.md)
-   CCD Custom DVM Errors - these business rules apply to error conditions while executing the [CDVM](./packages/CDVM/CDVM%20Documentation.md)
