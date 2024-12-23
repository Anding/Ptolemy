include %idir%\..\..\ForthBase\libraries\libraries.f
NEED Forth10Micron
NEED forth-map

192 168 1 107 toIPv4 value 10Micron.IP

add-mount

what-mount?

map CONSTANT FITSmap
FITSmap add-mountFITS 
CR FITSmap .map CR
