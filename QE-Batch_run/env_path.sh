#!/bin/bash
#
#VERSION       : 1.0.0
#PROGRAMMED BY : Rajesh Prashanth
#MODIFIED DATE : Mon Dec 25 00:21:41 IST 2017
#
###########################################################################################
# Environmental Path
# Please edit this part as required.
###########################################################################################
#
EXECUTABLES_PARENT_DIR="/usr/share/espresso/bin"
PREFIX="Silicon"
AUX_EXECUTABLE_PATH="./"
###########################################################################################
#
PW_EXEC_ROOT=$EXECUTABLES_PARENT_DIR
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
SCF_INP="$PREFIX.scf.in"
SCF_OUT="$PREFIX.scf.out"
#
VCRELAX_INP="$PREFIX.vcrelax.in"
VCRELAX_OUT="$PREFIX.vcrelax.out"
#
BANDS_NSCF_INP="$PREFIX.bands.nscf.in"
BANDS_NSCF_OUT="$PREFIX.bands.nscf.out"
#
BANDS_INP="$PREFIX.bands.in"
BANDS_OUT="$PREFIX.bands.out"
#
DOS_NSCF_INP="$PREFIX.dos.nscf.in"
DOS_NSCF_OUT="$PREFIX.dos.nscf.out"
#
DOS_INP="$PREFIX.dos.in"
DOS_OUT="$PREFIX.dos.out"
#
FERMI_INP="$PREFIX.fermi.in"
FERMI_OUT="$PREFIX.fermi.out"
#
PDOS_INP="$PREFIX.pdos.in"
PDOS_OUT="$PREFIX.pdos.out"


