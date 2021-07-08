#!/bin/sh
PROJECTNAME="Rebound"

BuildError () {
    PROJECTNAME=
    echo Build failed, aborting...
    exit 1
}

echo "Converting maps... (This may take a while)"
cd Levels
for file in *.json; do
	python3 ../convertmap.py -c $file
done
cd ..

echo Assembling...
rgbasm -o $PROJECTNAME.obj -p 255 Main.asm
if test $? -eq 1; then
    BuildError
fi

echo Linking...
rgblink -p 255 -o $PROJECTNAME.gb -n $PROJECTNAME.sym $PROJECTNAME.obj
if test $? -eq 1; then
    BuildError
fi

echo Fixing...
rgbfix -v -p 255 $PROJECTNAME.gb

echo Cleaning up...
rm $PROJECTNAME.obj

echo Build complete.

# unset vars
PROJECTNAME=
echo "** Build finished with no errors **"
