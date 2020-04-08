function CL = oufti_removeCellStructureFromCellList(cellId, frame, CL)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%function CL = removeCellStrucutreFromCellList(id, frame, CL)
%oufti.v0.2.8
%@author:  Ahmad J Paintdakhi
%@date:    March 21, 2013
%@copyright 2012-2013 Yale University
%==========================================================================
%**********output********:
%CL:    A structure containing two fields meshData and cellId    
%**********Input********:
%CL:    A structure containing two fields meshData and cellId
%frame:  frame to be added to the cellList.
%cellId:  cell id to be removed from the cellList
%==========================================================================
%This function removes a cell structure from cellList given the cellId.
%-------------------------------------------------------------------------- 
%-------------------------------------------------------------------------- 

%if frame is larger than the length of meshData then skip the process.
if length(CL.meshData) < frame
   disp('oufti_removeCellStructureFromCellList: Frame larger than length of cell meshData.');
   return;
end
    
cellIndex = CL.cellId{frame} == cellId;

% if cellId is not found in this frame, then cellIndex = []; without this
% check the following lines error with "Deletion requires an existing 
% variable." becuse assignment to [] constitutes deleting a variable?
if ~isempty(cellIndex)
    CL.meshData{frame}(cellIndex)       = [];
    CL.cellId{frame}(cellIndex)         = [];
end
end