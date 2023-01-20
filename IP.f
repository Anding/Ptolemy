\ Use the WinSock functionality of VFX Forth

include C:\MPE\VfxForth\Lib\Win32\Genio\SocketIo.fth

: toIPv4 ( x1 x2 x3 x4 -- x1.x2.x3.x4 )
\ convert four separate numbers to a four-byte IPv4 number
\ network order is assumed
	>R >R >R
	256 * R> +
	256 * R> +	
	256 * R> +
;

CR
initwinsock
CR