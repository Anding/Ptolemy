\ Use the serial port (COM) functionality of VFX Forth to communicate with a Unihedron Sky Quality Meter

include C:\MPE\VfxForth\Lib\Win32\Genio\serialbuff

256 buffer: SQMBUF
\ buffer to hold strings communicated with the SQM

serdev: SQMCOM
\ prepare an instance of a VFX Forth generic I/O driver

s" COM4: baud=115200 parity=N data=8 stop=1" ( legacy setting) 7 SQMCOM open-gio . . CR
\ prepare a suitable connection string
\ open the port

s" rx" SQMCOM write-gio . CR
\ send a string over the serial port to the SQM

SQMBUF 54 SQMCOM read-gio . CR
\ read a string form the SQM over the serial port

CR SQMBUF 54 type CR

SQMCOM close-gio . CR
\ close the serial port