#!/usr/bin/env python
#
#Sun Aug 27 09:20:48 IST 2017

#-------------------------------------------------
#
#

import numpy as np

cell=np.array([(0.0,0.0,0.0),(0.0,0.0,0.0),(0.0,0.0,0.0)])

atoms = []
coordinates = []

scf_file = open("test.out","r")
for line in scf_file:
	if "number of atoms/cell" in line:
		nat = line.split("=")[1]
	if "Begin final coordinates" in line:
		templine = next(scf_file)
		vol_au =  templine.split()[4]
		vol_ang = templine.split()[7]
		for nextline in scf_file:
			if "CELL_PARAMETERS" in nextline:
				templine1 = next(scf_file)
				cell[0][0] = templine1.split()[0]
				cell[0][1] = templine1.split()[1]
				cell[0][2] = templine1.split()[2]
				templine2 = next(scf_file)
				cell[1][0] = templine2.split()[0]
				cell[1][1] = templine2.split()[1]
				cell[1][2] = templine2.split()[2]
				templine3 = next(scf_file)
				cell[2][0] = templine3.split()[0]
				cell[2][1] = templine3.split()[1]
				cell[2][2] = templine3.split()[2]
			
			if "ATOMIC_POSITIONS" in nextline:
				for i in range(int(nat)):
					templines = next(scf_file) 
					atom,x,y,z = templines.split()
					atoms.append(atom)
					coordinates.append([float(x),float(y),float(z)])
					

					
			
			
			
			
			
			
			
	
print "----------------------------"		
print cell
print vol_au
print "number of atom :",nat
print vol_ang
print "----------------------------"		
print "----------------------------"	
for i in range(int(nat)):	
	print atoms[i],"\t",coordinates[i][0],"\t",coordinates[i][1],"\t",coordinates[i][2]


