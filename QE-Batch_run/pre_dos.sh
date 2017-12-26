#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Mon Dec 25 06:36:01 IST 2017
#
#
###########################################################################################
# Global variables
# Please edit this section as required.For more info check env_path.sh script
###########################################################################################
#
. ./env_path.sh
###########################################################################################
# NSCF INPUT FILE GENERATION FOR DOS FROM SCF INPUT
###########################################################################################
sed s/'scf'/'nscf'/ $SCF_INP | sed s/"occupations = 'smearing'"/"occupations = 'tetrahedra'"/  > $DOS_NSCF_INP
###########################################################################################
# DOS INPUT FILE GENERATION 
###########################################################################################
cat > $DOS_INP <<EOF
&DOS
outdir = './output' ,
fildos='dos.dat',
Emin=-50.0, Emax=50, DeltaE=0.1
/
EOF
