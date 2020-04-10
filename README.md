This is a fork of the Oufti software package, to allow correction lineage assignment errors and other improvements to the user interface. This version also supports more modern versions of MATLAB. 


## Prerequisites

Updated to support MATLAB R2018b. Only the Mac version of oufti is supported in this fork at this time. 

In addition, the following toolboxes are required:

```
Image Processing Toolbox                              Version 10.3        (R2018b)
Optimization Toolbox                                  Version 8.2         (R2018b)
Parallel Computing Toolbox                            Version 6.13        (R2018b)
```


## Install and run

To run:

1. Ensure this folder is in your MATLAB path (right click and select "Add to Path > Selected Folders and Subfolders")
2. run the script `oufti` by entering:

        oufti

    in the MATLAB command window, or opening the script `source/gui/oufti.m` and clicking "Run"


## New Features

### Lineage Editing

- To change the cell number of an existing cell, select a cell and enter a new cell number in the “Selected cell” box in the lower left
- To add or remove a division event, select the cell on the frame before it divides, and edit the value of the “Descendants” box. To add a division event, type two new cell numbers, separated by a space and press Enter. To remove a division event, type "" and press Enter
- To view the lineage tree, go to Tools > display lineage tree. Click on any cell in the tree to go to the frame where it was birthed. 

### Keyboard shortcuts

+ A: toggle manually add cell mode
+ J: join two selected cells 
+ P: split selected cell into two (hold shift and click to place the septum)
+ R: refine selected cell

### Mouse handling
- Use the scroll wheel in the main window to move between frames
- Hold shift and drag to select multiple cells

## Undocumented oufti features

- Undo with ctrl+Z
- When manually adding a cell, you can choose the number its assigned by holding shift when double-clicking or pressing Enter to finish drawing the cell. 
- When splitting a cell, if you hold shift, you can click to choose the position of the septum

## Lineage editing tips

- The lineage editing features show lots of warnings. This is to help you avoid making mistakes and to force you to be explicit in your intentions. 
- Keep an eye on the Lineage Tree view while you're editing; it will help you notice cells which have no ancestors ("Orphaned" cells) or cells which have more than two daughter cells. 
- It works best to go frame by frame, starting from the beginning of the movie---both for segmentation but also for lineage tracing. Choose "Time Lapse" mode under "Detection & analysis," but then click the button "This Frame" instead of "All Frames"
- In general, make changes on the first frame where the problem occurs, then let oufti propagate the fixes forward. For instance, if you need to renumber a cell, do it on the first frame with the wrong number, or the frame the cell was birthed. 
- When editing lineages, work in the following order:
    1. **Remove any spurious division events.**
    2. **Make sure the same cell doesn't change number.** If oufti creates a new cell with the wrong number, select the first frame where that wrong cell appears and change the number; this will give the cell the correct ancestry
    3. **Create any missing daughter cells, or renumber as necessary.** This is kind of tricky. For example, if cell 5 divides on frame 2 and oufti doesn't realize it, it may number the new cells 5 and 6 on frame 3. On frame 3, Change the number of the mother cell (cell 5) to a new number (you can enter "" and oufti will pick the first one available); you will get a warning about this, choose `Rename starting from this frame`. 
    4. **Create missing division events**. Go to the last frame before the mother cell divides, and enter the numbers of the new daughter cells in the "Descendants" box. 
    5. **Only edit "Ancestors" if you get a warning from the Lineage Tree view about broken ancestors**. For technical reasons, it is always better to edit descendants than ancestors. _Do not edit the "Ancestors" field to create a division event._
