# Roping-prediciton-supplementary materials
#  --------------------------------------------------------
This dataset and codes are attached to the article:
An artificial neural network-based model for roping prediction in aluminum alloy sheet.
If you use the dataset or codes, please cite them.
#  --------------------------------------------------------
Author: Yuanzhe, Hu.

Affiliation: State Key Laboratory of Mechanical Systems and Vibration, Shanghai Jiao Tong University
#  --------------------------------------------------------
Code availability
Codes available here are in two folders:

1- Python: 
	Euler_FZ.py: Transfer the Euler angles with Bunge convention into one subdomain of Euler space. 
	
2- Matlab:
	Artificial_orientation_map_generation.m (Main code): Generate in-plane orientation maps close to the actual texture distribution with variable components.
	
	Characteristic_grain_allocation.m: allocate Cube and Goss in the TD/RD plane.
	
	MTEX (version 5.6.1) is used to generate random orientations in the main code.

#  --------------------------------------------------------
Database availability 
Five cases in the article are included
-Experimental case 
-Supplementary case 
-Case with initial Texture-I
-Case with initial Texture-II
-Case with initial Texture-III

Contents details:
Each case has eight 3-D orientation maps due to random texture replacement, which is denoted as Rep(i).
Data of each orientation map contains Euler angles with Bunge convention and thickness strain after deformation.
And it is arranged in order of M(TD)×H(ND)×N(RD), M=240 N=120 H=8.
