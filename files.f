\ prototype directory and file handling

\ create a directory if it doesn't already exist
\ 	will only extend one directory level at a time
 s" c:\test\special-test" (caddr len) forceDir (ior)

\ setting up a textmacro for filepaths
 textmacro: IMAGEPATH
 c" c:\test\special-test" SETMACRO IMAGEPATH		\ c" " creates a counted string
 s" %IMAGEPATH%\new-test.csv" w/o create-file