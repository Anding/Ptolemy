\ requires
\ include C:\MPE\VfxForth64\Lib\Win32\TimeBase.fth 

include "%idir%\..\ForthBase\ForthBase.f"
include "%idir%\..\ForthBase\FiniteFractions.f"
include "%idir%\..\ForthXISF\XISF.f"
include "%idir%\..\ForthASI\ForthASI\ASI_SDK.f"

XISF_BUFFER BUFFER XISFBuffer			\ reserved buffer for camera image in XISF format
0 value mainCamera						\ active imaging camera

: review-cameras
	\ list the connected cameras by device number with their key properties
	\ use the results of review-cameras to update mainCamera if needed
	ASIGetNumOfConnectedCameras ( -- n)
	?dup
	CR IF
		\ loop over each connected camera
		0 do
			\ review the camera property structure
			ASICameraInfo i ASIGetCameraProperty ( buffer index --) ASI.?abort
			ASICameraInfo ASI_CAMERA_ID ." ASI_CAMERA_ID " l@ dup u. CR
				CameraID !
			TAB ASICameraInfo ASI_CAMERA_NAME ." ASI_CAMERA_NAME " zcount type CR
			TAB ASICameraInfo ASI_MAX_HEIGHT ." ASI_MAX_HEIGHT "  l@ . CR
			TAB ASICameraInfo ASI_MAX_WIDTH ." ASI_MAX_WIDTH "  l@ . CR
			\ open the camera
			CameraID @ ASIOpenCamera ASI.?abort
			\ get the serial number			
			CameraID @ ASISN ASIGetSerialNumber ASI.?abort
			TAB ASISN @ ." Serial no. "u. CR
			\ close the camera
			CameraID @ ASICloseCamera ASI.?abort			
			CR CR
		loop
	ELSE
		." No ASI cameras connected" CR
	THEN
;

: full-frame
	\ obtain the image size of MainCamera and set variables
	\ set the camera RAW16 format
;

: partial-frame ( a b --)
	\ set fractional frame size a/b
	\ set ROI in the centre
;

: camera-on
	\ open the mainCamera
	\ initialize the camera
	full-frame
;

: camera-off
	\ close the mainCamera
;

: download
	\ triggered by a timer after expose
	\ download camera data
	\ write the XISF buffer to disk
;

: expose ( ms --)
	\ set the exposure time
	\ prepare an XISF buffer
	\ insert basic FITS headers
	\ start the exposure
	\ setup a timer using AFTER to call download
;


