#!/bin/bash
# WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Tue Sep 12 14:07:33 IST 2017
#ARGUMENTS     : pressure ($1)
#CHANGE LIST   : paths and filenames are hard coded (9/12/2017)
#
# WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER---WRAPPER

for pressure in 0 100 200 300 400 500; do
	mkdir $pressure
	cp *.sh *.py $pressure
	cd $pressure
	bash batch.sh $pressure
	rm -rf output
	cd ..
done
