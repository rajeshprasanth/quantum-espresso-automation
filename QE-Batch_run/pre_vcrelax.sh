#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Mon Dec 25 00:21:41 IST 2017
#
#Usage:  vcrelax.sh <simulation_variable1> <simulation_variable2>
#Example: vcrelax.sh 10
#
###########################################################################################
# Global variables
# Please edit this section as required.For more info check env_path.sh script
###########################################################################################
#
. ./env_path.sh
#
###########################################################################################
# Local Variables
###########################################################################################
variable1=$1
###########################################################################################
# Variable checks
###########################################################################################
if [ $# -ne 1 ]; then
		echo " "
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo "FATAL ERROR--Incorrect number of variables"
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo " "
		echo "Usage: $0 <variable1> <variable2>"
		echo "       Minimum number of variables required is 1"
		echo "       Variable1 -> Variable 1 for simulation"
		echo "       Variable2 -> Variable 2 for simulation"
		echo " "
		exit
fi

###########################################################################################
#Input file structure defined here
###########################################################################################
cat > $VCRELAX_INP << EOF
&CONTROL
		    title = 'Si'
              calculation = 'vc-relax'
             restart_mode = 'from_scratch'
                   outdir = './output'
               pseudo_dir = '/usr/share/espresso/pseudo' 
                  tstress = .true.
                  tprnfor = .true.
            etot_conv_thr = 1.0D-10
            forc_conv_thr = 1.0D-8
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
 &IONS
             ion_dynamics = 'bfgs'
 /
 &CELL
	            press = $variable1
/
ATOMIC_SPECIES
  Si   28.085  Si.pz-vbc.UPF

ATOMIC_POSITIONS {crystal}
Si   0.000000000000000   0.000000000000000   0.000000000000000 
Si   0.250000000000000   0.250000000000000   0.250000000000000 

CELL_PARAMETERS {alat}
  0.500000000000000   0.500000000000000   0.000000000000000 
  0.500000000000000   0.000000000000000   0.500000000000000 
  0.000000000000000   0.500000000000000   0.500000000000000 

K_POINTS {automatic}
10 10 10  0 0 0
EOF
###########################################################################################
#End of the section
###########################################################################################
