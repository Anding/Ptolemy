\ Testing code with the 10Micron mount

include ../ForthBase/ip.f
include ../Forth10Micron/10Micron.f
include ../Forth10Micron/10Micron_celestial.f
include mount.f

( RA) 05 36 25 ( DEC) -05 22 33 MAKE-TARGET M42
( RA) 07 37 40 ( DEC) -14 32 05 MAKE-TARGET M47

CR
.( Check the telescope and try...) CR
.( CONNECT-MOUNT) CR
.( UNPARK) CR
.( M42 GOTO) CR
.( M47 GOTO) CR
.( HALT) CR
.( PARK) CR

	
		

