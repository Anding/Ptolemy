\ Experimental code for controlling the 10Micron mount

include e:/coding/ptolemy/ip.f
include e:/coding/ptolemy/10Micron.f
include e:/coding/ptolemy/celestial.f

mount.connect

CR ." Ask status"
mount.status?

CR ." Set high precision mode"
mount.highPrecision

CR ." Set target right ascension "
12 45 15 $RA
2dup type
mount.RA

CR ." Set target declination "
-80 30 10 $DEC
2dup type
mount.DEC

CR ." Ask telescope right ascension"
mount.RA?

CR ." Ask telescope declination"
mount.dec?

CR ." Ask status"
mount.status?

	
		

