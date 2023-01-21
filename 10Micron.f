\ Experimental code for controlling the 10Micron mount

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
	SOCKET_ERROR = if 
		." Connection failed with WinSock error number "
	else
		." Connection succeeded on socket "
		dup -> MNTSOC
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
	
: 10u.status?
\ obtain mount status
	CR
	s" :Gstat#" 10u.tell
	10u.ask 2dup type
;

: 10u.highPrecision
\ set the mount in high precision mode
	s" :U2#" 10u.tell
;

: 10u.DEC ( caddr u --)
\ set the 10Micron target to a declination in the format sDD*MM:SS
	CR
	s" :Sd" 2swap compose-command 10u.tell
	10u.ask 2dup type
;

: 10u.RA ( caddr u --)
\ set the 10Micron target to a right ascension in the format HH:MM:SS
	CR
	s" :Sr" 2swap compose-command 10u.tell
	10u.ask 2dup type
;

: 10u.DEC? ( --)
\ get the 10Micron telescope declination in the raw format
	CR
	s" :GD#" 10u.tell
	10u.ask 2dup type
;

: 10u.RA? ( --)
\ get the 10Micron telescope right ascension in the raw format
	CR
	s" :GR#" 10u.tell
	10u.ask 2dup type
;

: 10u.ALT? ( --)
\ get the 10Micron telescope altitude in the raw format
	CR
	s" :GA#" 10u.tell
	10u.ask 2dup type
;

: 10u.AZ? ( --)
\ get the 10Micron telescope altitude in the raw format
	CR
	s" :GZ#" 10u.tell
	10u.ask 2dup type
;

: 10u.pierSide?
\ get the 10Micron pier side
\ East#, telescope is on the east of the pier looking west
\ West#, telescope is on the west of the pier looking east
	CR
	s" :pS#" 10u.tell
	10u.ask 2dup type
;

: 10u.ST?
\ get the siderial time at the mount in raw format
	CR
	s" :GS#" 10u.tell
	10u.ask 2dup type
;

: 10u.unpark
\ unpark the mount
	CR
	s" :PO#" 10u.tell
;	

: 10u.park
\ park the mount
	CR
	s" :KA#" 10u.tell
;

: 10u.halt
\ halt all mount movement	
	CR
	s" :Q#" 10u.tell
;

: 10u.slew
\ slew to target RA Dec coordinates
	CR
	s" :MS#" 10u.tell
	10u.ask 2dup type
;

: 10u.tracking?
\ test the tracking status of the mount
	CR
	s" :D#" 10u.tell
	10u.ask 2dup type
; 

