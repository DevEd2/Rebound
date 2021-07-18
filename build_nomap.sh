#!/bin/sh
PROJECTNAME="Rebound"

BuildError () {
    PROJECTNAME=
    echo Build failed, aborting...
    exit 1
}

echo Assembling...
rgbasm -o $PROJECTNAME.obj -p 255 Main.asm
if test $? -eq 1; then
    BuildError
fi

echo Linking...
rgblink -p 255 -o $PROJECTNAME.gbc -n $PROJECTNAME.sym $PROJECTNAME.obj
if test $? -eq 1; then
    BuildError
fi

echo Fixing...
rgbfix -v -p 255 $PROJECTNAME.gbc

echo Cleaning up...
rm $PROJECTNAME.obj

echo Build complete.

# unset vars
PROJECTNAME=
echo "** Build finished with no errors **"
