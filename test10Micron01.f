\ Testing code with the 10Micron mount

include e:/coding/ptolemy/ip.f
include e:/coding/ptolemy/10Micron.f
include e:/coding/ptolemy/celestial.f

10u.connect

CR ." Ask status"
10u.status? 2drop

CR ." Set high precision mode"
10u.highPrecision

CR ." Set target right ascension "
12 45 15 $RA
2dup type
10u.RA 2drop

CR ." Set target declination "
-80 30 10 $DEC
2dup type
10u.DEC 2drop

CR ." Ask telescope right ascension"
10u.RA? 2drop

CR ." Ask telescope declination"
10u.DEC? 2drop

CR ." Ask status"
10u.status? 2drop

	
		

