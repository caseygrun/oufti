%*****************************************************************************
function [frame, daughters] = findCellDivision(cellId, start_frame, cellList)
    % find if cellId ever divides; if so, return on what frame and the
    % cellIDs of its daughter cells. If not, return -1 and []. 

    for frame = start_frame:oufti_getLengthOfCellList(cellList)
        cellData = oufti_getCellStructure(cellId, frame, cellList);
        if ~isempty(cellData) && ~isempty(cellData.descendants)
            daughters = cellData.descendants;
            return
        end
    end
    daughters = [];
    frame = -1;
end
