include %idir%\..\..\ForthBase\libraries\libraries.f
NEED Forth10Micron
NEED forth-map

192 168 1 107 toIPv4 -> 10Micron.IP

add-mount

map CONSTANT FITSmap
FITSmap add-mountFITS 
CR FITSmap .map CR
