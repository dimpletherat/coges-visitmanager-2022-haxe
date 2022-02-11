
rem start /wait for /R %%i in (*.svg) do "C:\Program Files\Inkscape\bin\inkscape.exe" --export-filename "%%~dpni-16.png" "%%~fi"  -d 90 -h 16 -C       
rem for /R %%i in (*.svg) do "C:\Program Files\Inkscape\bin\inkscape.exe" --export-filename "%%~dpni-16.png" "%%~fi"  -d 90 -h 16 -C       
rem convfor /R %%i in (*.svg) do "C:\Program Files\Inkscape\bin\inkscape.exe" --export-filename "%%~dpni-24.png" "%%~fi"  -d 90 -h 24 -C       
for /R %%i in (*.svg) do "C:\Program Files\Inkscape\bin\inkscape.exe" --export-filename "%%~dpni-32.png" "%%~fi"  -d 90 -h 32 -C  