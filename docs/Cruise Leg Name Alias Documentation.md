# Cruise Leg Name Alias Documentation

## Overview:
Cruise Leg Name Aliases are defined to allow flexible matching for folder names and CTD cast numbers to be parsed successfully. Each cruise leg record can have multiple cruise leg name aliases defined for it that will all resolve to the associated cruise leg record.

## Business Rules:
-   Cruise Leg Name Aliases can be as simple as HA1101, HA-11-01 or as complex as HA1201_LEGII, HA-12-01_LEGII, HA_1201_LEGII, HA12-01_LEGII based on the naming conventions used. In these cases HA1201_LEGII would be the cruise leg that all of the HA1101 and HA1201 Leg II aliases resolve to respectively.
-   In order for the CTD Cast Number to be successfully parsed from the file the file must either begin with a cruise leg alias of the [LEG NAME] folder or the word "cast" followed by a number optionally with a dash or underscore before the number. The number will be used to define the CTD Cast Number. In general the [LEG NAME] folder should be the same as the data file prefix but the flexible matching algorithm will handle the above cases as well.
    -   For example if the [LEG NAME] folder is SE-15-01 and the file names are SE15-01_[###].cnv both SE-15-01 and SE15-01 would both need to be defined as cruise leg aliases for the SE-15-01 cruise leg in order for the cast number to be parsed successfully.
