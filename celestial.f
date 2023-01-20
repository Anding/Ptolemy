\ Handle and convert between various celestial data formats

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

: $RA ( hr min sec -- caddr u)
\ obtain a right ascension string in the format HH:MM:SS	from 3 integers
	<#
	0 # # 2drop
	':' HOLD
	0 # # 2drop
	':' HOLD
	0 # # 
	#>
;

: $ALT ( deg min sec -- caddr u)
\ obtain an altitude string in the format sDD*MM:SS from 3 integers
	$DEC
;

: $AZ ( deg min sec -- caddr u)
\ obtain an azimuth string in the format DDD*MM:SS from 3 integers	
	<#
	0 # # 2drop
	':' HOLD
	0 # # 2drop
	'*' HOLD
	dup >R 
	0 # # #
	#>
;

: check-sign ( caddr u -- caddr u +/-1)
\ test for a sign character (including blank) at the start of a string
\ inc/decrement caddr u if a sign character is found
\ VFX's SKIP-SIGN may not handle blank	
	over c@ case
	'+' of  1 >R endof
	BL  of  1 >R endof
	'-' of -1 >R endof
	0 >R endcase
	R@ 0= if 
		R> drop 1
	else
		1- swap 1+ swap R> 
	then
;

: $NUM ( caddr u -- x y z)
\ split a three part string of the form sXXX:YY:ZZ.ZZ into 3 integers
\ .ZZ decimal is ignored	
	>R >R 0 0 R> R>						( 0 0 caddr u)
	3 0 do
		check-sign >R						( ud caddr u R:+/-1)
		>number 								( ud caddr u R:+/-1)
		R> -rot >R >R						( ud +/-1 R:u caddr)
		nip *									( +/-n R:u caddr)
		0 0 R> 1+ R> 1-					( n 0 0 caddr+1 u-1)
	loop
	2drop 2drop								( x y z)
;		
	
	
	
	
	
