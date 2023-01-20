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

: mount.connect ( -- )
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

: mount.checksocket ( -- ior)
\ check for an uninitialized socket
	CR
	MNTSOC 0 = if 
		CR ." Use mount.connect first" CR -1 
	else
		0
	then
;
	
: mount.tell ( c-addr u --)
\ pass a command string to the mount	
	CR
	mount.checksocket if drop drop exit then
	dup -rot 						( u c-addr u)
	MNTSOC writesock				( u len 0 | u error SOCKET_ERROR)
	SOCKET_ERROR = if ." Failed to write to the socket with error " . CR exit then
	<> if ." Failed to write the full string to the socket" CR exit then
;

: mount.ask ( -- c-addr u)
\ get a response from the mount
	CR
	mount.checksocket if MNTBUF 0 exit then
	0 >R 3													( tries R:bytes)
	begin
		1- dup 0 >=
	while
		125 ms
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
	
: mount.status?
\ obtain mount status
	CR
	s" :Gstat#" mount.tell
	mount.ask type
;

: mount.DEC ( caddr u --)
\ set the 10Micron target to a declination in the format sDD*MM:SS
	CR
	s" Sd" 2swap compose-command mount.tell
	mount.ask type
;

: mount.RA ( caddr u --)
\ set the 10Micron target to a right ascension in the format HH:MM:SS
	CR
	s" Sr" 2swap compose-command mount.tell
	mount.ask type
;

: mount.DEC? ( --)
\ get the 10Micron target declination in the raw format
	CR
	s" Gd#" mount.tell
	mount.ask type
;

: mount.RA? ( --)
\ get the 10Micron target right ascension in the raw format
	CR
	s" Gr#" mount.tell
	mount.ask type
;

	
		

