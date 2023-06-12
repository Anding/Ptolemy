# Ptolemy
Automated telescope control in Forth

This project aims to develop a Forth language system for controlling an astroimaging telescope and associated equipment 

## next steps
12 June 2023

### 1. Extend mount control language
1. user friendly control (e.g. ENUMS for setting, error code interpretation)
2. consider options for error handling during remote operation
3. implement commands for time and date enquiry from the mount
4. implement commands for model building (or at least not to interfere with existing models)

### 2. Develop a camera control language
1. develop the domain specific language on top of ASI_SDF.f (belongs in the Ptolemy respoitory)
2. consider how to prepare suitable filenames for saving files with time and date specification

### 3. Develop the domain language for scripting
1. consider formats and definitions for times and dates, periods, differences, celestial events
2. consider split of implementation between Forth and C (via EXTERN )
3. consider tradeoff in obtaining times and dates from the mount or from the system
4. develop a first level implementation with tests

### 4. XISF file format
1. build out the core FITS keyword set

### 5. ZWO EAF and EFW
1. download and test the relevant SDK's in C
2. develop the Forth language wrapper

### 6. Serial communication over COM / USB
1. develop the domain language for operating the SQM
2. reverse-engineer the CCA-250 focuser protocol
3. investgate native USB device control with C (to Forth via EXTERN)