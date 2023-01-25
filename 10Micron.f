\ Code for controlling the 10Micron mount

0 value MNTSOC
\ value type holding the socket number of the 10Micron mount

256 buffer: MNTBUF
\ buffer to hold strings communicated with the 10Micron mount

: compose-command {: caddr1 u1 caddr2 u2 -- MNTBUF u3 :}	\ use VFX locals
\ compose a mount command in the format PrefixData#
\ caddr1 u1 contains the prefix
\ caddr2 u2 contains the data, which will be appended to caddr1 u1
\ # is appended by the word
\ u3 = u1 + u2 + 1
	caddr1 MNTBUF u1			( from to len) 
	cmove
	caddr2 MNTBUF u1 + u2	( from to len)
	cmove
	'#' MNTBUF u1 + u2 +		( '#' caddr)
	c!
	MNTBUF	u1 u2 + 1+			( caddr3 u3)
;

: 10u.connect ( -- )
\ try to connect to the 10 Micron mount at Deep Sky Chile
	CR
	192 168 1 107 toIPv4 0 3490 TCPConnect
	?dup 0 = if 
		." Connection succeeded on socket "
		dup -> MNTSOC
	else
		." Connection failed with WinSock error number "
	then
	dup . CR
	drop \ better to leave the result?
;

: 10u.checksocket ( -- ior)
\ check for an uninitialized socket
	MNTSOC 0 = if 
		CR ." Use mount.connect first" CR -1 
	else
		0
	then
;
	
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

: MAKE-DATA-COMMAND
\ defining word for a 10Micron command which takes a data string
\ s" raw-command-prefix" MAKE-DATA-COMMAND <name>
	CREATE	( caddr u --)
		$,
	DOES>	( caddr u -- caddr u)
		count				\ copy the counted string at the PFA to the stack in caddr u format
		CR 2swap compose-command 10u.tell 
		10u.ask 2dup type
;

: MAKE-QUIET-COMMAND
\ defining word for a 10Micron command which has no return signal
\ s" raw-command-string" MAKE-QUIET-COMMAND <name>
	CREATE	( caddr u --)
		$,
	DOES>	( --)
		count				\ copy the counted string at the PFA to the stack in caddr u format
		CR 10u.tell 
;

s" :GR#"  MAKE-COMMAND 		10u.RA? ( --)
\ get the 10Micron telescope right ascension in the raw format
s" :GD#"  MAKE-COMMAND		10u.DEC? ( --)
\ get the 10Micron telescope declination in the raw format
s" :GA#"  MAKE-COMMAND		10u.ALT? ( --)
\ get the 10Micron telescope altitude in the raw format
s" :GZ#"  MAKE-COMMAND		10u.AZ? ( --)
\ get the 10Micron telescope altitude in the raw format
s" :GS#"  MAKE-COMMAND		10u.ST?
\ get the siderial time at the mount in raw format
s" :Gstat#" MAKE-COMMAND 	10u.status?
\ get the status of the mount
s" :pS#"  MAKE-COMMAND		10u.pierSide?
\ get the 10Micron pier side
\ East#, telescope is on the east of the pier looking west
\ West#, telescope is on the west of the pier looking east
s" :D#"  MAKE-COMMAND		10u.tracking?
\ test the tracking status of the mount
s" :MS#"  MAKE-COMMAND		10u.slew
\ slew to target RA Dec coordinates and start tracking

s" :Sd" MAKE-DATA-COMMAND 	10u.DEC
\ set the 10Micron target to a declension in the format sDDD:MM:SS
s" :Sr" MAKE-DATA-COMMAND	10u.RA ( caddr u --)
\ set the 10Micron target to a right ascension in the format HH:MM:SS

s" :U2#" MAKE-QUIET-COMMAND 10u.highPrecision
\ set the mount in high precision mode
s" :KA#" MAKE-QUIET-COMMAND 10u.park
\ park the mount
s" :PO#" MAKE-QUIET-COMMAND 10u.unpark
\ unpark the mount
s" :Q#"  MAKE-QUIET-COMMAND 10u.halt
\ halt all mount movement	
