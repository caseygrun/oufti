function [ cellList ] = editCellId( old_cellId, new_cellId, frame, goToBirthFrame, cellList )
%EDITCELLID Summary of this function goes here
%   Detailed explanation goes here

% reassign a cell with `old_cellId` from the point it is birthed to
    % have `new_cellId` in this and all future frames. If `new_cellId`
    % exists in the previous frame and has ancestors, then this cell 
    % and all its descendants will retain that ancestry. 
    
    % If new_cellId exists in this frame, error
    % If new_cellId has descendants in the frame before `old_cellId` is birthed, error
    
    
    % make a copy of cellList in case we need to error out
    newCellList = cellList;
    
    new_cellId_created = 0; 
    
    % if the new cellId is blank, assign a new number
    if new_cellId == -1
       new_cellId = getDaughterNum();
       % remember that a new daughter cell number was assigned so we don't
       % go looking for it later. 
       new_cellId_created = 1;
    else
        if any(isnan(new_cellId)) || (length(new_cellId) ~= 1)
            throw(MException('editCellId:badNewCellId',...
                'You must enter a single numeric value for the new cell number'))
        end
    end
    
    % find whether the new_cellId exists in a later frame; if so, error
    where_new_cellId_exists = whereDoesCellIdExist(new_cellId, frame, newCellList);
    if where_new_cellId_exists ~= -1
        throw(MException('editCellId:newCellIdAlreadyExistsLater',...
            sprintf('Cell %d already exists in frame %d',new_cellId, where_new_cellId_exists)))
    end
    
    % go back to the frame in which old_cellId was birthed and replace
    % starting there
    birth_frame = findCellBirth(old_cellId, frame, newCellList);
    if birth_frame == -1 || birth_frame == 0
        throw(MException('editCellId:cantFindNewCellBirthFrame',...
            sprintf(['Could not find the frame in which %d was birthed. '...
            'If you intended to create a new cell ID, enter "" and oufti '
            'will assign an unused one'],num2str(old_cellId))...
        ))
    end
    
    % warn if birth_frame ~= frame
    if birth_frame ~= frame 
        % user has not confirmed whether they wish to start renaming from
        % the birth frame
        if isempty(goToBirthFrame)
            throw(MException('editCellId:goToBirthFrame',...
                sprintf(['You are trying to rename cell %d to %d at frame %d; '...
                'however, cell %d first appears on frame %d. Do you wish to \n'...
                '- rename all instances of cell %d to cell %d, starting from the '...
                'frame it first appeared (frame %d; recommended), \n'...
                '- or just rename cell %d to cell %d starting from this frame?'],...
                old_cellId, new_cellId, ...
                old_cellId, birth_frame, old_cellId,...
                new_cellId, birth_frame, old_cellId, new_cellId)...
            ))
        
        % user has indicated they wish to force renaming to begin here
        elseif ~goToBirthFrame
            birth_frame = frame;
        end
    end
    
    % find if new_cellId has any ancestors
    if ~oufti_doesCellExist(new_cellId, birth_frame-1, newCellList)
        
        throw(MException('editCellId:couldntFindNewCellId',...
            sprintf(['Could not find cell %d in frame %d (the frame before cell %d was birthed)'
            'If you intended to create a new cell ID, enter "" and oufti '...
            'will assign an unused one'],...
            new_cellId, birth_frame-1, old_cellId)...
        ))
    end
    if new_cellId_created
        new_ancestors = [];
        new_birthframe = birth_frame;
    else
        previous_frame_cellData = oufti_getCellStructure(new_cellId, birth_frame-1, newCellList);
        new_ancestors = [previous_frame_cellData.ancestors new_cellId];
        new_birthframe = previous_frame_cellData.birthframe;
    end
    
    % iterate across all frames from birth_frame onward and
    for ii = birth_frame:oufti_getLengthOfCellList(newCellList)
        
        % 1) reassign old_cellId to new_cellId
        if oufti_doesCellExist(old_cellId, ii, newCellList)
            positionInFrame = oufti_cellId2PositionInFrame(old_cellId, ii, newCellList);
            oldcelldata = oufti_getCellStructure(old_cellId, ii, newCellList);
            
            % check if this cell has any ancestry; if it does, prompt to
            % user to confirm.
            if ~isempty(oldcelldata.ancestors)
                global errorHint;
                errorHint = struct();
                ME = MException('editCellId:oldCellIdIsNotOrphan',...
                sprintf(['You are trying to rename cell %d to %d. This will replace cell %d''s ancestors with '...
                    'cell %d''s ancestors (%s). However, cell %d is not an orphan; '...
                    'it has ancestors %s at frame %d (%d frames after it was birthed in frame %d). '...
                    'This is probably not what you intended. If it is, go back to frame %d and make cell %d an orphan by '...
                    'setting the descendants of cell %d to "".'],...
                    old_cellId, new_cellId, old_cellId,...
                    new_cellId, num2str(new_ancestors(1:end-1)), old_cellId,...
                    num2str(oldcelldata.ancestors), ii, ii-birth_frame, birth_frame,...
                    birth_frame-1, old_cellId, oldcelldata.ancestors(end)));
                
                errorHint.division_frame = birth_frame-1;
                errorHint.last_ancestor = oldcelldata.ancestors(end);
                throw(ME)
            end
                        
            % reassign `old_cellId` to have ancestors of `new_cellId`
            % (omit the last element of `new_ancestors`, which is
            % `new_cellId` itself)
            newCellList = oufti_addFieldToCellList(old_cellId, ii, ...
                'ancestors', new_ancestors(1:end-1), newCellList);
            
            % reassign `old_cellId` to have `birthframe` of `new_cellId`
            newCellList = oufti_addFieldToCellList(old_cellId, ii, ...
                'birthframe', new_birthframe, newCellList);
            
            % finally, rename old_cellId to new_cellId
            newCellList.cellId{ii}(positionInFrame) = new_cellId;
            
            fprintf(['Cell %d in frame %d changed to cell %d. \n'...
                'Ancestry changed to %s. \n'...
                'birthframe changed to frame %d.\n'],...
                old_cellId,ii,new_cellId,num2str(new_ancestors(1:end-1)),new_birthframe)

        end
        
        % 2) assign any cells that have old_cellId in their `ancestors` to have
        % the ancestry of new_cellId

        % for each cell position jj in frame ii
        cellStructures = newCellList.meshData{ii};
        cellIdNums = newCellList.cellId{ii};
        for jj = 1:length(cellIdNums)
            
            % see if old_cellId is an ancestor of this cell
            old_ancestors = cellStructures{jj}.ancestors;
            ancestry_pos = find(old_ancestors  == old_cellId);
            
            % if it is an ancestor
            if length(ancestry_pos) == 1
                
                % construct a new ancestry, beginning with the ancestors of
                % new_cellId, then including new_cellId in place of
                % old_cellId, and finally with the subsequent chain of
                % ancestors
                new_ancestry = [new_ancestors old_ancestors(ancestry_pos+1:end)];
                                
                newCellList = oufti_addFieldToCellList(cellIdNums(jj), ii, ...
                        'ancestors', new_ancestry, newCellList);
                
                fprintf('Cell %d ancestry changed from %s to %s',...
                    cellIdNums(jj),num2str(old_ancestors),num2str(new_ancestry))

                    
            elseif length(ancestry_pos) > 1
                throw(MException('editCellId:invalidLineage',...
                    sprintf(['Invalid lineage: cell %d found in ancestry '
                    'of cell %d more than once in frame %d (ancestry: %s)'],...
                    old_cellId, cellIdNums{jj}, ii, num2str(cellStructures{jj}.ancestors))...
                ))
            end
        end
    end
    
    cellList = newCellList;
end


