\ Testing code with the 10Micron mount

include e:/coding/ptolemy/ip.f
include e:/coding/ptolemy/10Micron.f
include e:/coding/ptolemy/celestial.f
include e:/coding/ptolemy/mount.f

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

	
		

