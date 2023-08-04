\ Experimental code for VFX WinSock

include C:\MPE\VfxForth\Lib\Win32\Genio\SocketIo.fth
CR

\ helper functions
: toIPv4 ( x1 x2 x3 x4 -- x1.x2.x3.x4 )
\ convert four separate numbers to a four-byte IPv4 number
\ network order is assumed
	>R >R >R
	256 * R> +
	256 * R> +	
	256 * R> +
;

\ try to connect as a client to some typical TCP ports
initwinsock
CR
127 0 0 1 toIPv4 0 5354 TCPConnect . .
CR
127 0 0 1 toIPv4 0 5939 TCPConnect . .