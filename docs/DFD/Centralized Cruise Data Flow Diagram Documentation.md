# Cruise Data Flow Diagram Documentation

## Overview:
A data flow diagram (DFD) is a visual representation of a data system intended to make it easier to understand by defining the system in terms of processes, inputs, and outputs. DFDs can be used to identify improvements to existing processes and opportunities to implement new processes to enhance the overall system. This document describes the Cruise DFD that maps the current flow of data in relation to the Cruise data system.

## Resources:
-   [DFD](./Centralized%20Cruise%20DFD.pdf)
-   [DFD XML](./Centralized%20Cruise%20DFD.xml) (exported from draw.io)

## Process:
-   Data is managed by authorized users via the Cruise Web Application which manipulates data directly in the Cruise DB
-   Sensitive cruise data can be retrieved directly from the Cruise DB by connecting with an authorized user's personal DB account
-   Non-sensitive cruise data can be retrieved directly from the Cruise DB by connecting with their personal DB account
-   Non-sensitive cruise data can be retrieved by any user connected to the PIFSC network via the Cruise Web Application
-   The Cruise DB retrieves and references database objects containing non-confidential personnel information from the PEEPS DB
-   Various external databases retrieve and reference database objects in the Cruise DB containing non-confidential cruise and personnel information including the CTD and MOUSS DBs
