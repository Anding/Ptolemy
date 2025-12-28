include e:\coding\ForthBase\libraries\libraries.f
NEED forth-map
NEED ForthVT100

map CONSTANT DASHmap
DASHmap +map				\ need to expose the map to compile the keywords in .DASHBOARD

	s" 13:45:00"		DASHmap =>" LOCALTME"
	s" Powered" 		DASHmap =>" STATUS"
	s" 23:10:50"		DASHmap =>" OBJCTRA"	
	s" 55:25:20"		DASHmap =>" OBJCTALT"	
	s" -02:30:30"		DASHmap =>" OBJCTHA"		
	s" East		"		DASHmap =>" PIERSIDE"	
	s" 10:20:00"		DASHmap =>" SIDEREAL"	
	s" Tracking"		DASHmap =>" TRACKING"	
	s" -60:20:00"		DASHmap =>" OBJCTDEC"				
	s" 175:40:33"		DASHmap =>" OBJCTAZ"
	s" 01:50:00"		DASHmap =>" TRACKEND"	
	s" West"				DASHmap =>" TGTPSIDE"


	vt.reset vt.cls vt.home

	0 12 1 table
	assign vt.green to-do table.text-format
	assign vt.blue to-do table.line-format 

	table.cellWidth dup 4 * 3 + -> table.cellWidth	\ merge 4 columns
	row |h ." Deep Sky Chile 10Micron mount telemetry"		-> table.cellWidth	\ restore column width
	row |r 							|r 						|r 							|r
	row |t s" Local time" RJ.	|t LOCALTME RJ.		|t s" Sidereal" RJ.		|t SIDEREAL RJ.	
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

vt.newline