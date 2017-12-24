#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Tue Sep 12 14:07:33 IST 2017
#ARGUMENTS     : pressure ($1)
#CHANGE LIST   : paths and filenames are hard coded (9/12/2017)
#
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#ENVIRONMENTAL PATHS (Hardcoded)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PW_EXEC_ROOT='/usr/bin'
PW_COMMAND="$PW_EXEC_ROOT/pw.x"
PW_BANDS="$PW_EXEC_ROOT/bands.x"
PW_DOS="$PW_EXEC_ROOT/dos.x"
PW_PDOS="$PW_EXEC_ROOT/projwfc.x"
PW_FERMI="$PW_EXEC_ROOT/fs.x"
PH_COMMAND="$PW_EXEC_ROOT/ph.x"
PH_COMMAND_DYNMAT="$PW_EXEC_ROOT/dynmat.x"
PH_COMMAND_Q2R="$PW_EXEC_ROOT/q2r.x"
PH_COMMAND_MATDYN="$PW_EXEC_ROOT/matdyn.x"
#
PREFIX="Si"
#
SCF_INP="$PREFIX.scf.$1.in"
SCF_OUT="$PREFIX.scf.$1.out"
#
VCRELAX_INP="$PREFIX.vcrelax.$1.in"
VCRELAX_INP="$PREFIX.vcrelax.$1.out"
#
BANDS_NSCF_INP="$PREFIX.bands.nscf.$1.in"
BANDS_NSCF_OUT="$PREFIX.bands.nscf.$1.out"
#
BANDS_INP="$PREFIX.bands.$1.in"
BANDS_OUT="$PREFIX.bands.$1.out"
#
DOS_INP="$PREFIX.dos.$1.in"
DOS_OUT="$PREFIX.dos.$1.out"
#
FERMI_INP="$PREFIX.fermi.$1.in"
FERMI_OUT="$PREFIX.fermi.$1.out"
#
PDOS_INP="$PREFIX.pdos.$1.in"
PDOS_OUT="$PREFIX.pdos.$1.out"
#
#
#--------------------------->>>>START OF BANNER MESSAGE<<<<--------------------------------
echo "-------------------------------------------------------------"
echo "QUANTUM ESPRESSO AUTOMATION SCRIPT"
echo "-------------------------------------------------------------"
echo "STARTED ON : "`date`
echo
#---------------------------->>>>END OF BANNER MESSAGE<<<<---------------------------------

#------------------------>>>>START OF VCRELAX CALCULATION<<<<------------------------------
#
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Variable cell relaxation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"

###########################################################################################
# VARIABLE CELL RELAXATION INPUT FILE DEFINED HERE
###########################################################################################

cat > Si.$1.vcrelax.in << EOF
&CONTROL
		    title = 'Si'
              calculation = 'vc-relax'
             restart_mode = 'from_scratch'
                   outdir = './output'
               pseudo_dir = '/home/rajeshprashanth/pseudo' 
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
	          degauss = 0.025
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
	            press = $1
/
ATOMIC_SPECIES
  Si   28.085  Si.pw-mt_fhi.UPF

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

echo "Running variable cell relaxation......"
$PW_COMMAND < Si.$1.vcrelax.in > Si.$1.vcrelax.out

grep "This run was terminated on" Si.$1.vcrelax.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi

###########################################################################################
# SCF INPUT FILE DEFINED HERE
###########################################################################################

cat > Si.$1.scf.in << EOF
&CONTROL
		    title = 'Si'
              calculation = 'scf'
             restart_mode = 'from_scratch'
                   outdir = './output'
               pseudo_dir = '/home/rajeshprashanth/pseudo' 
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
	          degauss = 0.025
 /
 &ELECTRONS
                 conv_thr = 1.0D-10
         diago_cg_maxiter = 5000
          diagonalization = 'cg'
 /
 
ATOMIC_SPECIES
  Si   28.085  Si.pw-mt_fhi.UPF

EOF

###########################################################################################
# VARIABLE CELL RELAXATION TO SCF CONVERSION
###########################################################################################

python vc2scf.py Si.$1.vcrelax.out >> Si.$1.scf.in

echo "K_POINTS {automatic}" >> Si.$1.scf.in
echo "10 10 10  0 0 0" >> Si.$1.scf.in

###########################################################################################

#-------------------------->>>>END OF VCRELAX CALCULATION<<<<------------------------------

#---------------------------->>>>START OF SCF CALCULATION<<<<------------------------------
#
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Confirmation SCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running scf calculation......"
###########################################################################################
$PW_COMMAND < Si.$1.scf.in > Si.$1.scf.out
###########################################################################################
grep "This run was terminated on" Si.$1.scf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
#
#----------------------------->>>>END OF SCF CALCULATION<<<<-------------------------------

#---------------------------->>>>START OF BAND STRURCTURE<<<<------------------------------
#
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Band structure SCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running scf calculation......"
###########################################################################################
$PW_COMMAND < Si.$1.scf.in > Si.$1.scf.out
###########################################################################################
grep "This run was terminated on" Si.$1.scf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################
# K PATH INTEGRATION PATH DEFINITION goes here
###########################################################################################
cat > kpath << EOF
12
   0.0000000000     0.0000000000     0.0000000000     10
   0.5000000000     0.0000000000     0.5000000000     10
   0.5000000000     0.2500000000     0.7500000000     10
   0.3750000000     0.3750000000     0.7500000000     10
   0.0000000000     0.0000000000     0.0000000000     10
   0.5000000000     0.5000000000     0.5000000000     10
   0.6250000000     0.2500000000     0.6250000000     10
   0.5000000000     0.2500000000     0.7500000000     10
   0.5000000000     0.5000000000     0.5000000000     10
   0.3750000000     0.3750000000     0.7500000000     1
   0.6250000000     0.2500000000     0.6250000000     10
   0.5000000000     0.0000000000     0.5000000000     1
EOF
###########################################################################################
# NSCF FILE GENERATION
###########################################################################################
sed s/'scf'/'bands'/ Si.$1.scf.in | sed s/{automatic}/crystal_b/ |sed '$d' > Si.$1.nscf.in
cat kpath >> Si.$1.nscf.in
#
###########################################################################################
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Band Structure NSCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running nscf calculation......"
#
###########################################################################################
# NSCF CALCULATION
###########################################################################################
#
$PW_COMMAND < Si.$1.nscf.in > Si.$1.nscf.out

grep "This run was terminated on" Si.$1.nscf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################
#
###########################################################################################
# BANDS CALCULATION
###########################################################################################
#
cat > bands.in << EOF
&BANDS
outdir='./output',
filband = 'bands.dat',
no_overlap = .true.
/
EOF
###########################################################################################
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Bands Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running bands calculation......"
#
$PW_BANDS < bands.in > bands.out
grep "This run was terminated on" bands.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
#------------------------>>>>END OF BAND STRURCTURE<<<<------------------------------

#------------------------>>>>START OF DOS CALCULATION<<<<------------------------------

echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "DOS SCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running scf calculation......"
##########################################################################################
$PW_COMMAND < Si.$1.scf.in > Si.$1.scf.out
###########################################################################################
grep "This run was terminated on" Si.$1.scf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################
# NSCF INPUT FILE GENERATION FOR DOS FROM SCF INPUT
###########################################################################################
sed s/'scf'/'nscf'/ Si.$1.scf.in | sed s/"occupations = 'smearing'"/"occupations = 'tetrahedra'"/  > Si.$1.dos.nscf.in
#
#
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "DOS NSCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running nscf calculation......"
##########################################################################################
$PW_COMMAND < Si.$1.dos.nscf.in > Si.$1.dos.nscf.out
###########################################################################################
grep "This run was terminated on" Si.$1.dos.nscf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################
# DOS INPUT FILE GENERATION 
###########################################################################################
cat > dos.in <<EOF
&DOS
outdir = './output' ,
fildos='dos.dat',
Emin=-50.0, Emax=50, DeltaE=0.1
/
EOF
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "DOS Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running dos calculation......"
##########################################################################################
$PW_DOS < dos.in > dos.out
###########################################################################################
grep "This run was terminated on" dos.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
#----------------------------->>>>END OF DOS CALCULATION<<<<------------------------------

#--------------------------->>>>START OF PDOS CALCULATION<<<<------------------------------
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "PDOS SCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running scf calculation......"
###########################################################################################
$PW_COMMAND < Si.$1.scf.in > Si.$1.scf.out
###########################################################################################
grep "This run was terminated on" Si.$1.scf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
#
###########################################################################################
# PROJWFC INPUT FILE GENERATION 
###########################################################################################
cat > projwfc.in <<EOF
&projwfc
       		outdir = './output'
      	       degauss = 0.3401424516
       		DeltaE = 0.001
      	       filpdos = 'pdos_data.dat'
 	  kresolveddos = .false.
/
EOF
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "PDOS Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running pdos calculation......"
###########################################################################################
$PW_PDOS < projwfc.in > projwfc.out
###########################################################################################
grep "This run was terminated on" projwfc.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi

#----------------------------->>>>END OF PDOS CALCULATION<<<<------------------------------

#------------------------>>>>START OF FERMI CALCULATION<<<<----------------------------
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "FERMI SCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running scf calculation......"
##########################################################################################
$PW_COMMAND < Si.$1.scf.in > Si.$1.scf.out
###########################################################################################
grep "This run was terminated on" Si.$1.scf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "FERMI NSCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running nscf calculation......"
#
cp Si.$1.dos.nscf.in Si.$1.fermi.nscf.in
# 
##########################################################################################
$PW_COMMAND < Si.$1.fermi.nscf.in > Si.$1.fermi.nscf.out
###########################################################################################
grep "This run was terminated on" Si.$1.dos.nscf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################
# FERMI SURFACE INPUT FILE GENERATION 
###########################################################################################

cat > fermi.in <<EOF
&fermi
    outdir = './output'
/
EOF
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "FERMI Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running fermi calculation......"
# 
##########################################################################################
$PW_FERMI < fermi.in > fermi.out
###########################################################################################
grep "This run was terminated on" fermi.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi

#------------------------>>>>END OF FERMI CALCULATION<<<<----------------------------------

#------------------------>>>>START OF TRANSPORT CALCULATION<<<<----------------------------
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "TRANSPORT Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running BoltzTraP calculation......"

###########################################################################################
# QE TO BOLTZTRAP CONVERSION
###########################################################################################
python qe2boltz.py pwscf pw 1e7 0 Si.$1.dos.nscf.out

###########################################################################################
# MAIN BOLTZTRAP CALCULATION
###########################################################################################
x_trans -f pwscf BoltzTraP

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
#------------------------>>>>END OF TRANSPORT CALCULATION<<<<----------------------------

#------------------>>>>START OF GAMMA POINT PHONON CALCULATION<<<<-----------------------
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Gamma point SCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running scf calculation......"
###########################################################################################
$PW_COMMAND < Si.$1.scf.in > Si.$1.scf.out
###########################################################################################
grep "This run was terminated on" Si.$1.scf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Gamma point phonon Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running phonon calculation......"
###########################################################################################
# GAMMA POINT PHONON CONFIRMATION
###########################################################################################

cat > Si.$1.phG.in << EOF
 Mg2Si Gamma point phonons
&inputph
	outdir = './output',
     verbosity = 1,
	tr2_ph = 1.0d-14
	 epsil = .true.,
	 trans = .true.,
	fildyn = 'dyn.G'
/
0.0 0.0 0.0
EOF
###########################################################################################
$PH_COMMAND < Si.$1.phG.in > Si.$1.phG.out
###########################################################################################
if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################
# SUM RULE INPUT FILE ON GAMMA POINT PHONON 
###########################################################################################
cat > dynmat.in << EOF
&input  
	fildyn = 'dyn.G', 
           asr = 'simple',    
/
EOF
###########################################################################################
# SUM RULE ON GAMMA POINT PHONON CALCULATION
###########################################################################################
#
$PH_COMMAND_DYNMAT < dynmat.in > dynmat.out
###########################################################################################

grep "This run was terminated on" Si.$1.dos.nscf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################

#------------------>>>>END OF GAMMA POINT PHONON CALCULATION<<<<-----------------------

#------------------>>>>START OF PHONON DISPERSION CALCULATION<<<<-----------------------
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Phonon dispersion SCF Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running scf calculation......"
###########################################################################################
$PW_COMMAND < Si.$1.scf.in > Si.$1.scf.out
###########################################################################################
grep "This run was terminated on" Si.$1.scf.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Phonon dispersion Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running phonon calculation......"
###########################################################################################
# GAMMA POINT PHONON CONFIRMATION
###########################################################################################

cat > Si.$1.ph.in << EOF
 &inputph
  tr2_ph=1.0d-14,
  ldisp=.true.,
  nq1=4, nq2=4, nq3=4
  amass(1)=28.0855,
  outdir='./output'
  fildyn='si.dyn',
 /
EOF
###########################################################################################
$PH_COMMAND < Si.$1.ph.in > Si.$1.ph.out
###########################################################################################
if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################
# q2r calculation
###########################################################################################
cat >Si.q2r.in<<EOF
 &input
   fildyn='si.dyn', 
   zasr='simple', 
   flfrc='si444.fc'
 /
EOF
###########################################################################################
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "IFC Calculation"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Running IFC calculation......"
###########################################################################################
$PH_COMMAND_Q2R < Si.q2r.in > Si.q2r.out
###########################################################################################
grep "This run was terminated on" Si.q2r.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi
###########################################################################################
# Dispersion calculation
###########################################################################################

cat > Si.matdyn.in << EOF
 &input
    asr='simple',  amass(1)=28.0855,
    flfrc='si444.fc', flfrq='si.freq'
 /
36
  0.000 0.0 0.0  0.0 
  0.100 0.0 0.0  0.0  
  0.200 0.0 0.0  0.0  
  0.300 0.0 0.0  0.0  
  0.400 0.0 0.0  0.0  
  0.500 0.0 0.0  0.0  
  0.600 0.0 0.0  0.0  
  0.700 0.0 0.0  0.0  
  0.800 0.0 0.0  0.0  
  0.900 0.0 0.0  0.0  
  1.000 0.0 0.0  0.0  
  1.000 0.1 0.0  0.0  
  1.000 0.2 0.0  0.0  
  1.000 0.3 0.0  0.0  
  1.000 0.4 0.0  0.0  
  1.000 0.5 0.0  0.0  
  1.000 0.6 0.0  0.0  
  1.000 0.7 0.0  0.0  
  1.000 0.8 0.0  0.0  
  1.000 0.9 0.0  0.0  
  1.000 1.0 0.0  0.0
  0.900 0.9 0.0  0.0  
  0.800 0.8 0.0  0.0  
  0.700 0.7 0.0  0.0  
  0.600 0.6 0.0  0.0  
  0.500 0.5 0.0  0.0  
  0.400 0.4 0.0  0.0  
  0.300 0.3 0.0  0.0  
  0.200 0.2 0.0  0.0  
  0.100 0.1 0.0  0.0  
  0.000 0.0 0.0  0.0  
  0.1   0.1 0.1  0.0  
  0.2   0.2 0.2  0.0  
  0.3   0.3 0.3  0.0  
  0.4   0.4 0.4  0.0  
  0.5   0.5 0.5  0.0  
EOF
###########################################################################################
# Dispersion calculation
###########################################################################################
$PH_COMMAND_MATDYN < Si.matdyn.in > Si.matdyn.out
###########################################################################################
grep "This run was terminated on" Si.matdyn.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi

###########################################################################################
# PHONON dos calculation
###########################################################################################

cat > Si.phdos.in << EOF
 &input
        asr = 'simple',
	dos = .true. 
	amass(1) = 28.0855,
        flfrc = 'si444.fc', 
        fldos = 'si.phdos', 
        nk1 = 6,
        nk2 = 6, 
        nk3 = 6
 /
EOF

###########################################################################################
$PH_COMMAND_MATDYN < Si.phdos.in > Si.phdos.out
###########################################################################################
grep "This run was terminated on" Si.phdos.out

if [  $? != 0  ] ;then
	echo "FATAL ERROR--Premature termination"
	exit
fi

#------------------>>>>END OF PHONON DISPERSION CALCULATION<<<<-----------------------


