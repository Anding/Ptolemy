\ Develop a Forth language to control the mount

: MAKE-TARGET
\ defining word to name a set of coordinates in RA and DEC
\ (RA ) hh mm ss (Dec) deg mm ss MAKE-TARGET <target-name>
	CREATE ( hh mm ss deg mm ss --)
		, , , , , ,
	DOES> ( -- hh mm ss deg mm ss)
		dup 5 CELLS + DO
			I @
		-1 CELLS +loop
;

: CONNECT-MOUNT
\ connect and prepare the mount
	10u.connect
	10u.highprecision
	10u.status?
;

: GOTO ( hh mm ss deg mm ss -- caddr u)
\ slew the mount to a target and return the signal from the mount
\ <target> GOTO
	$DEC 10u.DEC 2drop
	$RA 10u.RA 2drop
	10u.slew					\ return only the final signal from the mount
;

: UNPARK ( --)
\ unpark the mount
	10u.unpark
;

: PARK ( --)
\ park the mount
	10u.park
;

: STOP ( --)
\ stop (halt) the mount
\ HALT is a VFX multitasking word
	10u.halt
;
	
	