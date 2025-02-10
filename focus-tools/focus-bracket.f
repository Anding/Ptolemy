\ obtain a brackted set of frames at different fcouses

include "%idir%\..\..\ForthBase\libraries\libraries.f"
NEED ForthBase
NEED FiniteFractions
NEED Network
NEED Windows
NEED Forth-Map
NEED ForthKMTronic
NEED ForthASI
NEED ForthEAF
NEED ForthEFW
NEED Buffers
NEED ForthXML
NEED ForthXISF

0 value height
0 value width
0 value image
10000 mSecs value exposure_setting ( units uS)
0 constant ASI2600MM_031F 

\ Set the rig to the Epsilon 160-ED
s" Takahashi Epsilon 160-ED" $-> rig.telescope
160 	-> rig.aperature_dia
520 	-> rig.focal_len
0 		-> rig.aperature_area

\ Set the observation type to flats
LIGHT -> obs.type
s" Andrew Read" $-> obs.observer

: startup
	\ activate the relays and switch on camera power
	6 -> KMTronic.COM
	add-relays
	1 relay-on
	1000 ms

	\ activate the camera
	scan-cameras
	ASI2600MM_031F add-camera
	ASI2600MM_031F use-camera
	
	\ activate the focuser
	scan-focusers
	0 add-focuser
	0 use-focuser
	
	\ obtain the size of the camera sensor and allocate an image buffer with descriptor, and forth-maps
	camera_pixels ( width height) -> height -> width
	width height 1 allocate-image ( img) -> image
	map image FITS_map !
	map image XISF_map !
;

: shutdown
	0 remove-focuser
	ASI2600MM_031F remove-camera
	500 ms
	1 relay-off
	remove-relays
;

: focus ( n --)
	->focuser_position
	wait-focuser
;
		
: expose
\ take an image
	exposure_setting dup ->camera_exposure
	CR ." Exposure time (us) " . CR	
	start-exposure
 	image FITS_MAP @ add-observationFITS		\ includes timestame and UUID
 	image XISF_MAP @ add-observationXISF
 	image FITS_MAP @ add-rigFITS	
 	image FITS_MAP @ add-cameraFITS
 	image FITS_MAP @ add-focuserFITS	
 	image XISF_MAP @ add-cameraXISF		
	exposure_setting 1000 / 100 + ms
	image IMAGE_BITMAP image image_size ( addr n) download-image
	image save-image
;

: bracket ( --)
\ take a batch of flat-frame images
	." focuser initial position: " focuser_position dup  . CR
	CR 9 0 DO 
		dup 100 - i 25 * + dup ->focuser_position
		." Exposing at focuser position: " . CR
		expose
	LOOP
	dup ->focuser_position
	." focuser final position: " focuser_position dup  . CR	
;

\ convenience functions for the mount
: goto ( RA DEC --) ->mount_equatorial ;
: RA ~ ;
: DEC ~ ;
: name-target ( caddr u --) $-> obs.observer ;

