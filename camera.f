\ requires
\ include C:\MPE\VfxForth64\Lib\Win32\TimeBase.fth 

XISF_BUFFER BUFFER XISFBuffer			\ reserved buffer for camera image in XISF format
0 value mainCamera						\ active imaging camera

: review-cameras
	\ list the connected cameras by device number with their key properties
	\ use the results of review-cameras to update mainCamera if needed
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


