#! /bin/bash
# Process the things.sh

GRIDFILES=$(ls | grep .grid)

for file in $GRIDFILES; do
	SIZE=$(< $file tail -n +4 | head -n 1)

	NEWFILENAME=$( echo $file | sed 's/.grid/.dat/' )

	echo "VARIABLES = X Y Particle_Density" > $NEWFILENAME
	

	< $file tail -n +10 >> $NEWFILENAME

done
