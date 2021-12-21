@echo off
set PROJECTNAME="Rebound"

rem	Build ROM

echo Assembling...
rgbasm -o %PROJECTNAME%.obj -p 255 Pocket.asm
if errorlevel 1 goto :BuildError

echo Linking...
rgblink -p 255 -o %PROJECTNAME%.pocket -n %PROJECTNAME%.sym %PROJECTNAME%.obj
if errorlevel 1 goto :BuildError

echo Fixing...
rgbfix -f hg -p 255 %PROJECTNAME%.pocket

echo Cleaning up...
del %PROJECTNAME%.obj
echo Build complete.
goto :end

:BuildError
set PROJECTNAME=
echo Build failed, aborting...
goto:eof

:end
rem unset vars
set PROJECTNAME=
echo ** Build finished with no errors **
