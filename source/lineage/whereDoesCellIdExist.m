%*****************************************************************************
function [cframe] = whereDoesCellIdExist(celln, frame, cellList)
    for cframe=frame:oufti_getLengthOfCellList(cellList) %length(cellList)
        if oufti_doesCellStructureHaveMesh(celln, frame, cellList)
            return
        end
    end
    cframe = -1;
end