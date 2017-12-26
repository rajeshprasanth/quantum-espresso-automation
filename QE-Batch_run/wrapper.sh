#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Mon Dec 25 04:01:23 IST 2017
#
. ./functions.sh
#
#--------------------------->>>>START OF BANNER MESSAGE<<<<--------------------------------
#
run_banner
#
#---------------------------->>>>END OF BANNER MESSAGE<<<<---------------------------------
#
#------------------------>>>>START OF VCRELAX CALCULATION<<<<------------------------------
#
./pre_vcrelax.sh $1
run_vcrelax
#
#-------------------------->>>>END OF VCRELAX CALCULATION<<<<------------------------------
#
#---------------------------->>>>START OF SCF CALCULATION<<<<------------------------------
#
./pre_scf_from_vcrelax.sh
run_scf
#
#----------------------------->>>>END OF SCF CALCULATION<<<<-------------------------------
#
#---------------------------->>>>START OF BAND STRURCTURE<<<<------------------------------
#
./pre_bandstructure.sh
run_scf
run_bands_nscf
run_bands_final
#
#------------------------------>>>>END OF BAND STRURCTURE<<<<------------------------------
#
#---------------------------->>>>START OF DOS CALCULATION<<<<------------------------------
#
./pre_dos.sh
run_scf
run_dos_nscf
run_dos_final
#
#------------------------------>>>>END OF DOS CALCULATION<<<<------------------------------

