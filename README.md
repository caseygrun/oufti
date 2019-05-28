This is a fork of the Oufti software package, to allow correction of lineage assignment errors and other improvements to the user interface.


## Prerequisites

Requires **MATLAB R2014b**. Will NOT work on later versions of MATLAB. Only the Mac version of oufti is supported in this fork at this time. 

In addition, the following toolboxes are required:

Bioinformatics Toolbox            Version 4.5        (R2014b)
Computer Vision System Toolbox    Version 6.1        (R2014b)
Curve Fitting Toolbox             Version 3.5        (R2014b)
Image Processing Toolbox          Version 9.1        (R2014b)
MATLAB Coder                      Version 2.7        (R2014b)
MATLAB Compiler                   Version 5.2        (R2014b)
Optimization Toolbox              Version 7.1        (R2014b)
Parallel Computing Toolbox        Version 6.5        (R2014b)
Statistics Toolbox                Version 9.1        (R2014b)


## Install and run

To run:

1. Ensure this folder is in your MATLAB path (right click and select "Add to Path > Selected Folders and Subfolders")
2. run the script `oufti` by entering:

        oufti

    in the MATLAB command window, or opening the script `source/gui/oufti.m` and clicking "Run"


## New Features

- To change the cell number of an existing cell, select a cell and enter a new cell number in the “Selected cell” box in the lower left
- To add or remove a division event, select the cell on the frame before it divides, and edit the value of the “Descendants” box. To add a division event, type two new cell numbers, separated by a space and press Enter. To remove a division event, type "" and press Enter
- To view the lineage tree, go to Tools > display lineage tree. Click on any cell in the tree to go to the frame where it was birthed. 

- Keyboard shortcuts: 
    + A: toggle manually add cell mode
    + J: join two selected cells 
    + P: split selected cell into two (hold shift and click to place the septum)
    + R: refine selected cell

## Undocumented oufti features

- Undo with ctrl+Z
- When manually adding a cell, you can choose the number its assigned by holding shift when double-clicking or pressing Enter to finish drawing the cell. 
- When splitting a cell, if you hold shift, you can click to choose the position of the septum
