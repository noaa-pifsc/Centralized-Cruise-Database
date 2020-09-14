# Centralized Cruise Database Diagram Documentation

## Overview:
The Centralized Cruise Database (CCD) contains various objects from external modules as well as objects for storing the cruise data and the associated Cruise Data Management Application (CRDMA). The color-coded [database diagram](./data_model/cruise_db_diagram.pdf) shows the various tables defined in the CCD and this document describes what each object color represents.

## Resources:
-   [Centralized Cruise Database Diagram](./data_model/cruise_db_diagram.pdf)
-   [Centralized Cruise Database Documentation](./Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
-   [CRDMA Technical Documentation](../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md)

## Color Code Definitions:
-   The yellow objects are the core cruise data objects used to store the cruise data in the Centralized Cruise Database
-   The green objects are cruise data objects used to define the presets for various reference tables in the Centralized Cruise Database
-   The blue objects are directly used by the [CRDMA](../CRDMA/docs/Cruise%20Data%20Management%20Application%20-%20Technical%20Documentation.md) to facilitate authorization in the application, these objects are from the Authorization Application Module that is listed in the [Database Documentation](./Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
-   The orange objects are used to validate the data in the CCD, these are objects from the external Data Validation Module (DVM) that is listed in the [Database Documentation](./Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
-   The gray objects are from various external modules listed in the [Database Documentation](./Centralized%20Cruise%20Database%20-%20Technical%20Documentation.md)
