# Centralized Cruise Database Phase 1 Documentation

## Overview
This document defines the work items required to finish development and deployment of phase 1 of the Centralized Cruise Database.  All work items have an effort estimate associated with it, items marked with an "X" are completed and items marked with a "_" have not been completed.  Some items have been grouped because they were related or easier to implement concurrently.  The time estimate is listed in parentheses at the defined level, for example if an item has a time estimate defined it applies to all items indented directly below it.  If an item does not have any items indented directly below it then the time estimate applies to that item only.  The time estimate in days are based on 8-9 hours of focused processing time, lead time is not included in the estimates.  The document will be updated as work is completed so the estimate will change as the project is worked on.

## Work Items
-   ### Application Updates
    -   Implement APEX modules (2 days)
        -   X Implement APEX Feedback Form
        -   X Implement the AAM user interface for managing user permissions
        -   X implement template app updated code
        -   X implement synonyms and automated application deployment
    -   X (1 day) implement data write and data admin roles
    -   X (1-2 days) Implement centralized CAM Auth App Module
        -   X also drop all the auth_app objects and auth app APEX pages
        -   X document how the CC_CONFIG_OPTIONS values need to be defined
    -   X (0.5 days) reduce unnecessary logging
    -   X (0.5 days) Develop production version of the APEX deployment scripts
-   ### Database Updates
    -   DB Module Upgrades (1 day)
        -   X DVM
        -   X DLM
        -   X DPM (APEX use case)
    -   X (0.5 days) Remove Auth App Module
    -   _ (1 day) Develop Database Upgrade and Rollback SOP for phase 1
    -   X (3 days) Update DVM automated test cases: update the automated verification method to spool the output to a given directory (SQLPlus script to produce the same output and Winmerge or other diff program to confirm the outputs are equivalent)
    -   X (2 days) implement CCD_PKG automated tests
        -   X update documentation 
    -   X implement history tracking package on appropriate tables
-   ### Documentation Updates
    -   Database (2 days)
        -   X Technical Documentation
        -   X DB Diagram
        -   X PL/SQL Coding Conventions
        -   X DB naming conventions
        -   X business rules
    -   Application (1 day)
        -   X Technical Documentation
        -   X User Documentation
        -   _ Testing Documentation
-   ### Developer Testing (1 week)
    -   _ APEX Application
    -   _ DVM automated test cases
    -   _ Database Deployment
    -   _ Database Upgrade and Rollback SOP
-   ### Review/Approval
    -   X (completed in 2020, no major development has been performed since then) User Acceptance Testing
    -   _ (TBD: based on ITS availability) Security Review
    -   _ (1 day) System Change Request
-   ### System Deployment (0.25 days)
    -   _ Deploy DB using DB Upgrade and Rollback scripts
    -   _ Deploy APEX application using APEX automated deployment SOP

## Current Processing Time Estimate
-   16.75 days => ~ 3.25 weeks
-   \+ 1 week of padding for unforeseen issues
-   = 4.25 weeks as the total estimate for remaining work
