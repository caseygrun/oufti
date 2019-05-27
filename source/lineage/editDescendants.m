function [ cellList ] = editDescendants( cellId, frame, newDescendants, forceOrphan, cellList )
%EDITDESCENDANTS Creates a division event from `cellId` to `newDescendants` on
%`frame`. 
%   `newDescendants` will have their `ancestors` updated in `cellList`, as
%   on this and all subsequent frames, and all their descendants will be
%   updated as well.
%   If `cellId` already has existing existing descendants in this `frame` 
%   or any subsequent frame, you must pass `true` to `forceOrphan`, or an
%   `MException('editDescendants:alreadyHasDescendants')` will be raised.
%   If `forceOrphan` is passed `true`, then each existing descendant of
%   `cellId` will be made an orphan (its `ancestors` will be set to `[]`),
%   and subsequent descendants will have `cellId` and its `ancestors`
%   removed from their lineage. 
%   Returns an updated `cellList`. 

    % callback for changing descendants
    % if cellId has any existing descendants in this frame or any other frame, 
    % first warn and then make each of them orphans. 
    % then change cellId's descendants, and rebuild the ancestors of all of
    % cellId's descendants
    
    if ~oufti_doesFrameExist(frame, cellList) || oufti_isFrameEmpty(frame, cellList)
        throw(MException('editDescendants:noCells','Descendent assignment failed: no cells in this frame'));
    end

    % get meshData about the currently selected cell (including
    % importantly the current ancestors and descendants of that
    % cell)
    celldata = oufti_getCellStructure(cellId,frame, cellList);
    if isempty(celldata)
        throw(MException('editDescendants:cellNotFound',sprintf('Cell %d not found in frame %d',cellId, frame)));
    end
    old_descendants = celldata.descendants;

    % check that both of the new descendants are numbers
    % check that exactly two descendants are entered
    if any(isnan(newDescendants))...
            || (~isempty(newDescendants)...
                && length(newDescendants) ~= 2)
        throw(MException('editDescendants:wrongDescendantNumber',...
            'Must enter exactly zero or two cell numbers as descendents'))
    end

    % check that both descendants exist
    descendants_exist = []
    for i = 1:length(newDescendants)
        descendants_exist(i) = oufti_doesCellExist(newDescendants(i),frame+1,cellList);
    end
    
    if sum(~descendants_exist) == 1
        missing_descendant = find(~descendants_exist,1);
        throw(MException('editDescendants:descendantDoesNotExist',...
            sprintf('Cell %d does not exist in the next frame (frame %d); create cell %d first',...
            newDescendants(missing_descendant),frame+1,newDescendants(missing_descendant))...
        ))
    elseif sum(~descendants_exist) == 2
        throw(MException('editDescendants:descendantDoesNotExist',...
            sprintf(['Cell %d does not exist in the next frame (frame %d); neither does '...
            'cell %d. Create cell %d and cell %d in frame %d first, then assign them as '...
            'descendents of this cell. '],...
            newDescendants(1),frame+1,newDescendants(2),...
            newDescendants(1),newDescendants(2),frame+1)...
        ))
    end
        
    disp('Old descendants: ')
    disp(celldata.descendants)
    disp('New descendants: ')
    disp(num2str(newDescendants))        

    % check if cellId already has any descendants, and warn if so
    [division_frame, old_daughters] = findCellDivision(cellId, frame, cellList);
    if division_frame ~= -1 
        % if user has not already cancelled this warning
        if ~forceOrphan
            if ~isempty(newDescendants)
                throw(MException('editDescendants:alreadyHasDescendants',...
                   sprintf(['You are trying to indicate that after this frame (%d), '...
                    'cell %d divides into two daughter cells %s. However, cell %d already divides into '...
                    'cells %s on frame %d. If you choose to proceed, cells %s will be orphaned. '],...
                    frame, cellId, num2str(newDescendants), cellId,...
                    num2str(old_daughters), division_frame, num2str(old_daughters))...
                ))
            end
        end
        cellList = replaceAncestry(old_daughters(1), frame+1, [], cellList);
        cellList = replaceAncestry(old_daughters(2), frame+1, [], cellList);

    end

    % update descendants of cellId in cell list
    cellList = oufti_addFieldToCellList(cellId,frame,'descendants',newDescendants,cellList);

    % traverse the descendants of each of the new_descendants and
    % update its ancestry to include that of cellId
    new_ancestry = [celldata.ancestors cellId];
    for ii = 1:length(newDescendants)
        cellList = replaceAncestry(newDescendants(ii), frame+1, new_ancestry, cellList);
    end

end

