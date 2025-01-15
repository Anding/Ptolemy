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
DASHmap +map				\ need to expose the map to compile the keywords in .DASHBOARD

: .DASHBOARD ( --)
	0 12 1 table
	assign vt.green to-do table.text-format
	assign vt.blue to-do table.line-format 

	table.cellWidth dup 4 * 3 + -> table.cellWidth	\ merge 4 columns
	row |h ." Deep Sky Chile 10Micron mount telemetry"		-> table.cellWidth	\ restore column width
	row |r 							|r 						|r 							|r
	row |t s" Local time" RJ.	|t LOCALTME RJ.		|t s" Sidereal time" RJ.		|t SIDEREAL RJ.	
	row |l 							|l 						|l 							|l
	row |t s" Status" RJ.		|t STATUS RJ.			|t s" Tracking" RJ.		|t TRACKING RJ.	
	row |l 							|l 						|l 							|l	
	row |t s" R.A." RJ.			|t OBJCTRA RJ.			|t s" DEC" RJ.				|t OBJCTDEC RJ.
	row |l 							|l 						|l 							|l
	row |t s" Alt" RJ.			|t OBJCTALT RJ.		|t s" AZ" RJ.				|t OBJCTAZ RJ.
	row |l 							|l 						|l 							|l
	row |t s" H.A." RJ.			|t OBJCTHA RJ.			|t s" Track end" RJ.		|t TRACKEND RJ.						
	row |l 							|l 						|l 							|l
	row |t s" Pier side" RJ.	|t PIERSIDE RJ.		|t s" Target side" RJ.	|t TGTPSIDE RJ.	
	row |f 							|f 						|f 							|f

;

: cycle-dashboard
	vt.reset vt.cursor_off vt.cls
	begin
		5 0 do
			key? if CR vt.cursor_on vt.reset exit then
			200 ms
		loop
		DASHmap add-mountDASH
		vt.home .DASHBOARD
	again
;

vt.reset vt.cursor_off vt.cls vt.home
.DASHBOARD 
CR vt.cursor_on vt.reset