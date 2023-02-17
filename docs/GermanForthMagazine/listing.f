\ 
\ 10Micron.f - code for controlling the 10Micron mount

0 value MNTSOC
\ value type holding the socket number of the 10Micron mount
256 buffer: MNTBUF
\ buffer to hold strings communicated with the 10Micron mount

: 10u.tell ( c-addr u --)
\ pass a command string to the mount	
	10u.checksocket if drop drop exit then
	dup -rot 						( u c-addr u)
	MNTSOC writesock				( u len 0 | u error SOCKET_ERROR)
	SOCKET_ERROR = if ." Failed to write to the socket with error " . CR exit then
	<> if ." Failed to write the full string to the socket" CR exit then
;

: 10u.ask ( -- c-addr u)
\ get a response from the mount
	10u.checksocket if MNTBUF 0 exit then
	0 >R 5													( tries R:bytes)
	begin
		1- dup 0 >=
	while
		200 ms
		MNTSOC pollsock									( tries len | tries SOCKET_ERROR)
		dup SOCKET_ERROR = if 
			drop ." Failed to poll the socket " CR
		else
			0= if
				." 0 bytes available at the socket" CR
			else
				MNTBUF 256 MNTSOC readsock 			( tries len 0 | tries error SOCKET_ERROR)
				SOCKET_ERROR = if							( tries ior)
					." Failed to read the socket with error " . CR
				else											( tries len)
					R> drop >R drop 0						( 0 R:bytes)
				then											( tries R:bytes)
			then
		then
	repeat
	drop MNTBUF R>
	dup 0= if ." No response from the mount" CR then	
;

: MAKE-COMMAND
\ defining word for a 10Micron command
\ s" raw-command-string" MAKE-COMMAND <name>
	CREATE	( caddr u --)
		$,					\ compile the caddr u string to the parameter field as a counted string
	DOES>	( -- caddr u)
		count				\ copy the counted string at the PFA to the stack in caddr u format
		CR 10u.tell 
		10u.ask 2dup type
;

s" :GR#"  MAKE-COMMAND 		10u.RA? ( --)
\ get the 10Micron telescope right ascension in the raw format
s" :GD#"  MAKE-COMMAND		10u.DEC? ( --)
\ get the 10Micron telescope declination in the raw format
s" :Gstat#" MAKE-COMMAND 	10u.status?
\ get the status of the mount

\ 
\ celestial.f - handle and convert between various celestial data formats

: $DEC ( deg min sec -- caddr u)
\ obtain a declination string in the format sDD*MM:SS from 3 integers
	<# 			\ proceeds from the rightmost character in the string
	0 # # 2drop	\ numeric output works with double numbers
	':' HOLD
	0 # # 2drop
	'*' HOLD
	dup >R 
	abs 0 # # 
	R> 0 < if '-' else '+' then HOLD
	#>
;

\ 
\ mount.f - develop a Forth language to control the mount

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

: GOTO ( hh mm ss deg mm ss -- caddr u)
\ slew the mount to a target and return the signal from the mount
\ <target> GOTO
	$DEC 10u.DEC 2drop
	$RA 10u.RA 2drop
	10u.slew					\ return only the final signal from the mount
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