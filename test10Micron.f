\ Experimental code for controlling the 10Micron mount

include ip.f
include 10Micron.f
include celestial.f

mount.connect
mount.status?

12 45 15 $RA
2dup type
mount.RA

-80 30 10 $DEC
2dup type
mount.DEC

mount.RA?

mount.dec?

mount.status?

	
		

