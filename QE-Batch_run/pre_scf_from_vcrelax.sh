#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Mon Dec 25 04:31:44 IST 2017
#
#
###########################################################################################
# Global variables
# Please edit this section as required.For more info check env_path.sh script
###########################################################################################
#
. ./env_path.sh
#
###########################################################################################
#Input file structure defined here
###########################################################################################
cat > $SCF_INP << EOF
&CONTROL
		    title = 'Si'
              calculation = 'scf'
             restart_mode = 'from_scratch'
                   outdir = './output'
               pseudo_dir = '/usr/share/espresso/pseudo' 
                  tstress = .true.
                  tprnfor = .true.
            etot_conv_thr = 1.0D-10
            forc_conv_thr = 1.0D-8
		verbosity = 'high'
 /
 &SYSTEM
                     ibrav = 0
                        A = 5.43070
                      nat = 2
                     ntyp = 1
                  ecutwfc = 50
              occupations = 'smearing'
                 smearing = 'm-v'
	          degauss = 0.0025
 /
 &ELECTRONS
                 conv_thr = 1.0D-10
         diago_cg_maxiter = 5000
          diagonalization = 'cg'
 /
 
ATOMIC_SPECIES
  Si   28.085  Si.pz-vbc.UPF
EOF

###########################################################################################
# VARIABLE CELL RELAXATION TO SCF CONVERSION
###########################################################################################

python $AUX_EXECUTABLE_PATH/vc2scf.py $VCRELAX_OUT >> $SCF_INP

grep -A1 "K_POINTS" $VCRELAX_INP >> $SCF_INP
