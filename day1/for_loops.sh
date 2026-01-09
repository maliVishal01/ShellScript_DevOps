#!/bin/bash

echo "creating project directories..."

for DIR in Dev test prod logs backup
do 
	if [ ! -d "$DIR" ]; then 
		mkdir "$DIR"
		echo "created Directory: $DIR"
	else
		echo "Directory already  exists: $DIR"
	fi 
done 











