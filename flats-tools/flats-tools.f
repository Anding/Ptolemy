\ obtain a set of reference flat frames

include "%idir%\..\..\ForthBase\libraries\libraries.f"
NEED ForthBase
NEED FiniteFractions
NEED Network
NEED Windows
NEED Forth-Map
NEED ForthKMTronic
NEED ForthPegasusAstro
NEED ForthASI
NEED ForthEFW
NEED Buffers
NEED ForthXML
NEED ForthXISF
NEED ImageAnalysis

0 value height
0 value width
0 value image
8000 mSecs value exposure_setting ( units uS)
0 value mean_pixel_level
0x8000 value target_level
0 value relative_to_target
0 constant ASI2600MM_031F 

\ Set the rig to the Epsilon 160-ED
s" Takahashi Epsilon 160-ED" $-> rig.telescope
160 	-> rig.aperature_dia
520 	-> rig.focal_len
0 		-> rig.aperature_area

\ Set the observation type to flats
FLAT -> obs.type
s" Andrew Read" $-> obs.observer

: startup
	\ activate the relays and switch on camera power
	6 -> KMTronic.COM
	add-relays
	1 relay-on
	1000 ms

	\ activate the lightbox and switch on ilumination
	5 -> Pegasus.COM
	add-lightbox
	lightbox-on
	20 ->lightbox.intensity

	\ activate the camera
	scan-cameras
	ASI2600MM_031F add-camera
	ASI2600MM_031F use-camera
	
	\ activate the filter wheel
	scan-wheels
	0 add-wheel
	0 use-wheel
	
	\ obtain the size of the camera sensor and allocate an image buffer with descriptor
	camera_pixels ( width height) -> height -> width
	width height 1 allocate-image ( img) -> image
	map image FITS_map !
	map image XISF_map !
;

: shutdown
	lightbox-off
	remove-lightbox
	0 ->wheel_position
	0 remove-wheel
	ASI2600MM_031F remove-camera
	500 ms
	1 relay-off
	remove-relays
;

: filter ( n --)
	->wheel_position
	wait-wheel
;
		
: expose
\ take a test image
	exposure_setting dup ->camera_exposure
	CR ." Exposure time (us) " . CR	
	start-exposure
 	image FITS_MAP @ add-observationFITS		\ includes timestame and UUID
 	image XISF_MAP @ add-observationXISF
 	image FITS_MAP @ add-rigFITS	
 	image FITS_MAP @ add-cameraFITS
 	image FITS_MAP @ add-wheelFITS	
 	image XISF_MAP @ add-cameraXISF		
	exposure_setting 1000 / 100 + ms
	image IMAGE_BITMAP image image_size ( addr n) download-image
;

: review
\ review the image 
	width height image IMAGE_BITMAP make-histogram
	histogram.mean dup -> mean_pixel_level dup
	 CR ." Mean pixel level " . CR
	 100 target_level */ dup -> relative_to_target
	 CR ." Relative to target (%) " . CR
;

: adjust
\ scale the exposure time
	exposure_setting target_level mean_pixel_level */ dup -> exposure_setting
	CR ." Revised exposure time (us) " . CR
;

: save ( --)
	image save-image
;

: burst ( --)
\ take a batch of flat-frame images
	CR 7 0 DO 
		i . tab
		expose save
	LOOP CR
;





