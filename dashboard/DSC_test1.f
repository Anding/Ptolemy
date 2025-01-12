\ test mount dashboard
NEED Forth10Micron
NEED ForthVT100


	192 168 1 107 toIPv4 -> 10Micron.IP		\ DSC
\ 	192 168 1  14 toIPv4 -> 10Micron.IP		\ DB

CR ." Connecting to mount"
add-mount

CR ." Set high precision mode"
10u.HighPrecisionOn

map CONSTANT DASHmap
DASHmap add-mountDASH 
CR DASHmap .map CR

: .DASHBOARD ( map --)
	dup +map >R
	12 5 1 table vt.home
	assign vt.green to-do table.text-format
	assign vt.blue to-do table.line-format 

	table.cellWidth dup 4 * 3 + -> table.cellWidth	\ merge 4 columns
	row |h ." Deep Sky Chile 10Micron mount telemetry"		-> table.cellWidth	\ restore column width
	row |t s" Local time" RJ.	|t LOCALTME RJ.		|t s" Sidereal time"		|t SIDEREAL RJ.	
	row |r 							|r 						|r 							|r
	row |t s" Status" RJ.		|t STATUS RJ.			|t s" TRACKING" RJ.		|t TRACKING RJ.	
	row |l 							|l 						|l 							|l	
	row |t s" R.A." RJ.			|t OBJCTRA RJ.			|t s" DEC" RJ.				|t OBJCTDEC RJ.
	row |l 							|l 						|l 							|l
	row |t s" Alt" RJ.			|t OBJCTALT RJ.		|t s" AZ" RJ.				|t OBJCTAZ RJ.
	row |l 							|l 						|l 							|l
	row |t s" H.A." RJ.			|t OBJCTHA RJ.			|t s" Track end" RJ.		|t TRACKEND RJ.									|t
	row |l 							|l 						|l 							|l
	row |t s" Pier side" RJ.	|t PIERSIDE RJ.		|t s" Target side" RJ.	|t TGTPSIDE RJ.	
	row |f 							|f 						|f 							|f

	R> -map
;

: cycle-dashboard
	begin 
		vt.reset vt.cursor_off vt.cls 
	-1 while
		key? if CR vt.cursor_on exit then
		DASHmap add-mountDASH
		.DASHBOARD
	repeat
;

cycle-dashboard