%****************************************************************************
function cellList = replaceAncestry(cellId, frame, new_ancestors, cellList)
    % Change the lineage tree such that, starting at `frame`, `cellId` and 
    % its descendants now descend from `new_ancestors`.
    % If `old_cellId` is not [] then if `cellId` or its descendents
    % descend from `old_cellId`, `old_cellId` and its ancestors will be
    % replaced with `new_ancestors`. 
    % example 1:
    %     cellList:
    %       frame:  1    2    3    4
    %       cellId: 5 -> 7 -> 9 -> 10
    %     cellList = replace_ancestry(9, 3, [2 3], cellList)
    %     cellList:
    %       frame:  1    2    3    4
    %       cellId: 2 -> 3 -> 9 -> 10
    
    % for each frame until the end of the movie
    for cframe = frame:oufti_getLengthOfCellList(cellList)
        celldata = oufti_getCellStructure(cellId, cframe, cellList);
        if isempty(celldata)
            return
        end
        
        % update ancestors in this frame
        cellList = oufti_addFieldToCellList(cellId, cframe, ...
            'ancestors', new_ancestors, cellList);
        
        % if `cellId` divides this frame
        if ~isempty(celldata.descendants)
            
            % recurse and replace the ancestry of each descendant
            cellList = replaceAncestry(celldata.descendants(1), cframe+1, [new_ancestors cellId], cellList);
            cellList = replaceAncestry(celldata.descendants(2), cframe+1, [new_ancestors cellId], cellList);
            return
        end
    end
end