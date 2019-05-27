%*****************************************************************************
function [birth_frame] = findCellBirth(cellId, frame, cellList)
    % Finds the frame in which cellId was birthed (i.e. the first frame
    % cellId is present, before or including `frame`)
    % returns -1 if cellId is not found in `frame`.
    if ~oufti_doesCellExist(cellId, frame, cellList)
        birth_frame = -1;
        return
    end
    
    birth_frame = frame;
    for ii=frame:-1:1
        if ~oufti_doesCellExist(cellId, birth_frame, cellList)
            birth_frame = birth_frame + 1;
            return
        else
            birth_frame = birth_frame - 1;
        end
    end
    birth_frame = 1;
end