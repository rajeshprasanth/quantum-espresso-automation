#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Mon Dec 25 02:52:47 IST 2017
#
#Functions
. ./env_path.sh
#
#
#

run_banner() {
	echo "-------------------------------------------------------------"
	echo "QUANTUM ESPRESSO AUTOMATION SCRIPT"
	echo "-------------------------------------------------------------"
	echo "STARTED ON : "`date`
	echo
}

run_vcrelax() {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Variable cell relaxation"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Running variable cell relaxation......"
	$PW_COMMAND < $VCRELAX_INP > $VCRELAX_OUT
	grep "This run was terminated on" $VCRELAX_OUT
	if [  $? != 0  ] ;then
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo "FATAL ERROR--Premature termination"
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		exit
	fi
}

run_scf() {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "SCF Calculation"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Running scf calculation......"
	$PW_COMMAND < $SCF_INP > $SCF_OUT
	grep "This run was terminated on" $VCRELAX_OUT
	if [  $? != 0  ] ;then
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo "FATAL ERROR--Premature termination"
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		exit
	fi
}

run_bands_nscf() {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Bands NSCF Calculation"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Running bands nscf calculation......"
	$PW_COMMAND < $BANDS_NSCF_INP > $BANDS_NSCF_OUT
	grep "This run was terminated on" $BANDS_NSCF_OUT
	if [  $? != 0  ] ;then
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo "FATAL ERROR--Premature termination"
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		exit
	fi
}
run_bands_final() {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Bands Calculation"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Running final bands calculation......"
	$PW_BANDS < $BANDS_INP > $BANDS_OUT
	grep "This run was terminated on" $BANDS_OUT
	if [  $? != 0  ] ;then
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo "FATAL ERROR--Premature termination"
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		exit
	fi
}

run_dos_nscf(){
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "DOS NSCF Calculation"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Running DOS nscf calculation......"
	$PW_COMMAND < $DOS_NSCF_INP > $DOS_NSCF_OUT
	grep "This run was terminated on" $BANDS_NSCF_OUT
	if [  $? != 0  ] ;then
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo "FATAL ERROR--Premature termination"
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		exit
	fi
}

run_dos_final(){
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "DOS Calculation"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "Running final DOS calculation......"
	$PW_DOS < $DOS_INP > $DOS_OUT
	grep "This run was terminated on" $BANDS_NSCF_OUT
	if [  $? != 0  ] ;then
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		echo "FATAL ERROR--Premature termination"
		echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
		exit
	fi
}
