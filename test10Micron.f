\ VFX Winsock support
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

\ try to connect to the 10 Micron mount at Deep Sky Chile
initwinsock
CR
192 168 1 107 toIPv4 0 3490 TCPConnect
. dup .

