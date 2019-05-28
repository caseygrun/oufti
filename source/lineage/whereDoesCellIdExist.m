%*****************************************************************************
function [cframe] = whereDoesCellIdExist(celln, frame, cellList)
    for cframe=frame:oufti_getLengthOfCellList(cellList) %length(cellList)
        if oufti_doesCellExist(celln, cframe, cellList)
            return
        end
    end
    cframe = -1;
end