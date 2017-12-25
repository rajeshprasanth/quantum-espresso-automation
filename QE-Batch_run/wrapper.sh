#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Mon Dec 25 04:01:23 IST 2017

#./env_path.sh
. ./functions.sh

./pre_vcrelax.sh $1
run_vcrelax

./pre_scf_from_vcrelax.sh
run_scf

./pre_bandstructure.sh
run_scf
run_bands_nscf
run_bands_final

./pre_dos.sh
run_scf
run_dos_nscf
run_dos_final

