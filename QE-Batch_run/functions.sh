#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Mon Dec 25 02:52:47 IST 2017
#
#Functions

. ./env_path.sh
#check number of arguments needed. (Maximum number of arguments + 1)  is defined in $1 position
run_vcrelax() {
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
