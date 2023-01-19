\ value type holding the socket number of the 10Micron mount
0 value MNTSOC

\ buffer to hold strings received from the 10Micron mount
256 buffer: MNTBUF

\ try to connect to the 10 Micron mount at Deep Sky Chile
: mount.connect ( -- )
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

\ check for an uninitialized socket
: mount.checksocket ( -- ior)
	CR
	MNTSOC 0 = if 
		CR." Use mount.connect first" CR -1 
	else
		0
	then
;
	
\ pass a command string to the mount
: mount.tell ( c-addr u --)
	CR
	mount.checksocket if drop drop exit then
	dup -rot 						( u c-addr u)
	MNTSOC writesock		( u len 0 | u error SOCKET_ERROR)
	SOCKET_ERROR = if ." Failed to write to the socket with error " . CR exit then
	<> if ." Failed to write the full string to the socket" CR exit then
;

\ get a response from the mount
: mount.ask ( -- c-addr u)
	CR
	mount.checksocket if MNTBUF 0 exit then
	0 >R 5														( tries R:bytes)
	begin
		1- dup 0 >=
	while
		100 ms
		MNTSOC pollsock									( tries len | tries SOCKET_ERROR)
		dup SOCKET_ERROR = if 
			drop ." Failed to poll the socket " CR
		else
			0= if
				." 0 bytes available at the socket" CR
			else
				MNTBUF 256 MNTSOC readsock 	( tries len 0 | tries error SOCKET_ERROR)
				SOCKET_ERROR = if						( tries ior)
					." Failed to read the socket with error " . CR
				else												( tries len)
					R> drop >R drop 0					( 0 R:bytes)
				then												( tries R:bytes)
			then
		then
	repeat
	drop MNTBUF R>
;
	
\ obtain mount status
: mount.status
	CR
	s" :Gstat#" mount.tell
	mount.ask 
	?dup 0= if ." No response from the mount" CR drop exit then
	type
;
	
		

