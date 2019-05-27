%% findCellBirth
clear
load('./tests/data/PA14 Pt-sfGFP MinS_NTA s1 col1.mat','cellList') %,'cellListN','paramString','objectParams','spotParams');

birth_frame = findCellBirth(1, 1, cellList)
assert(birth_frame == 1)

birth_frame = findCellBirth(1, 3, cellList)
assert(birth_frame == 1)

% cell 1 is not found in frame 4 onward
birth_frame = findCellBirth(1, 4, cellList)
assert(birth_frame == -1)

birth_frame = findCellBirth(50, 7, cellList)
assert(birth_frame == 7)

birth_frame = findCellBirth(50, 10, cellList)
assert(birth_frame == 7)

%% findCellDivision
clear
load('./tests/data/PA14 Pt-sfGFP MinS_NTA s1 col1.mat','cellList') %,'cellListN','paramString','objectParams','spotParams');

[division_frame, daughters] = findCellDivision(1, 1, cellList)
assert(division_frame == 3)
assert(all(sort(daughters) == [48 49]))

[division_frame, daughters] = findCellDivision(1, 4, cellList)
assert(division_frame == -1)
assert(isempty(daughters))

%% replaceAncestry
clear
load('./tests/data/PA14 Pt-sfGFP MinS_NTA s1 col1.mat','cellList') %,'cellListN','paramString','objectParams','spotParams');

cellList = replaceAncestry(49, 4, [], cellList);
% 1 -> 49 -> 50, 51
% 50 -> 56, 57
% 51 -> 54, 55

cellData_49 = oufti_getCellStructure(49,4,cellList)
assert(isempty(cellData_49.ancestors))
cellData_49 = oufti_getCellStructure(49,5,cellList)
assert(isempty(cellData_49.ancestors))
cellData_49 = oufti_getCellStructure(49,6,cellList)
assert(isempty(cellData_49.ancestors))

cellData_50 = oufti_getCellStructure(50,7,cellList)
assert(cellData_50.ancestors == [49])
cellData_50 = oufti_getCellStructure(50,8,cellList)
assert(cellData_50.ancestors == [49])
cellData_50 = oufti_getCellStructure(50,9,cellList)
assert(cellData_50.ancestors == [49])
cellData_50 = oufti_getCellStructure(50,10,cellList)
assert(cellData_50.ancestors == [49])


cellData_51 = oufti_getCellStructure(51,7,cellList)
assert(cellData_51.ancestors == [49])
cellData_51 = oufti_getCellStructure(51,8,cellList)
assert(cellData_51.ancestors == [49])
cellData_51 = oufti_getCellStructure(51,9,cellList)
assert(cellData_51.ancestors == [49])
cellData_51 = oufti_getCellStructure(51,10,cellList)
assert(cellData_51.ancestors == [49])

cellData_56 = oufti_getCellStructure(56,11,cellList)
assert(all(cellData_56.ancestors == [49 50]))
cellData_56 = oufti_getCellStructure(56,12,cellList)
assert(all(cellData_56.ancestors == [49 50]))
cellData_56 = oufti_getCellStructure(56,13,cellList)
assert(all(cellData_56.ancestors == [49 50]))
cellData_56 = oufti_getCellStructure(56,14,cellList)
assert(all(cellData_56.ancestors == [49 50]))
cellData_56 = oufti_getCellStructure(56,15,cellList)
assert(all(cellData_56.ancestors == [49 50]))

cellData_57 = oufti_getCellStructure(57,11,cellList)
assert(all(cellData_57.ancestors == [49 50]))
cellData_57 = oufti_getCellStructure(57,12,cellList)
assert(all(cellData_57.ancestors == [49 50]))
cellData_57 = oufti_getCellStructure(57,13,cellList)
assert(all(cellData_57.ancestors == [49 50]))
cellData_57 = oufti_getCellStructure(57,14,cellList)
assert(all(cellData_57.ancestors == [49 50]))

cellData_55 = oufti_getCellStructure(55,11,cellList)
assert(all(cellData_55.ancestors == [49 51]))
cellData_55 = oufti_getCellStructure(55,12,cellList)
assert(all(cellData_55.ancestors == [49 51]))
cellData_55 = oufti_getCellStructure(55,13,cellList)
assert(all(cellData_55.ancestors == [49 51]))
cellData_55 = oufti_getCellStructure(55,14,cellList)
assert(all(cellData_55.ancestors == [49 51]))

cellData_54 = oufti_getCellStructure(54,11,cellList)
assert(all(cellData_54.ancestors == [49 51]))
cellData_54 = oufti_getCellStructure(54,12,cellList)
assert(all(cellData_54.ancestors == [49 51]))
% after frame 12, 51 gets mis-assigned to 58

            
%% whereDoesCellIdExist
clear
load('./tests/data/PA14 Pt-sfGFP MinS_NTA s1 col1.mat','cellList') %,'cellListN','paramString','objectParams','spotParams');

where_exists = whereDoesCellIdExist(50, 1, cellList)
assert(where_exists == 7)

%% editDescendants( cellId, frame, newDescendants, forceOrphan, cellList )
clear
load('./tests/data/PA14 Pt-sfGFP MinS_NTA s1 col1.mat','cellList') %,'cellListN','paramString','objectParams','spotParams');

cellList = editDescendants( 58, 15, [69 70], 0, cellList )
cellData_58 = oufti_getCellStructure(58,15,cellList)
assert(all(cellData_58.descendants == [69 70]))
cellData_58 = oufti_getCellStructure(58,14,cellList)
assert(all(cellData_58.descendants == []))

cellData_69 = oufti_getCellStructure(69,16,cellList)
assert(all(cellData_69.ancestors == [58]))
cellData_69 = oufti_getCellStructure(69,17,cellList)
assert(all(cellData_69.ancestors == [58]))

cellData_70 = oufti_getCellStructure(70,16,cellList)
assert(all(cellData_70.ancestors == [58]))
cellData_70 = oufti_getCellStructure(70,17,cellList)
assert(all(cellData_70.ancestors == [58]))


%% editCellId( old_cellId, new_cellId, frame, goToBirthFrame, cellList )
clear
load('./tests/data/PA14 Pt-sfGFP MinS_NTA s1 col1.mat','cellList') %,'cellListN','paramString','objectParams','spotParams');

% give cell 58 two descendants, 69--70 (this case is tested earlier)
cellList = editDescendants( 58, 15, [69 70], 0, cellList )

% rename cell 58 to 54 on frames 13--15; its new descendants 69--70 should
% have their ancestry updated on frames 16--17
cellList = editCellId( 58, 54, 13, [], cellList )

% make sure cell 58 disappeared
cellData_58 = oufti_getCellStructure(58,13,cellList)
assert(isempty(cellData_58))
cellData_58 = oufti_getCellStructure(58,14,cellList)
assert(isempty(cellData_58))
cellData_58 = oufti_getCellStructure(58,15,cellList)
assert(isempty(cellData_58))

% make sure cell 54 appears & has correct birth frame
cellData_54 = oufti_getCellStructure(54,13,cellList)
assert(~isempty(cellData_54))
assert(cellData_54.birthframe == 11)
cellData_54 = oufti_getCellStructure(54,14,cellList)
assert(~isempty(cellData_54))
assert(cellData_54.birthframe == 11)
cellData_54 = oufti_getCellStructure(54,15,cellList)
assert(~isempty(cellData_54))
assert(cellData_54.birthframe == 11)

% check cell 54 has correct descendants
cellData_54 = oufti_getCellStructure(54,15,cellList)
assert(all(sort(cellData_54.descendants) == [69 70]))

% check ancestors of descendants are set correctly
cellData_69 = oufti_getCellStructure(69,16,cellList)
assert(all(cellData_69.ancestors == [1 49 51 54]))
cellData_69 = oufti_getCellStructure(69,17,cellList)
assert(all(cellData_69.ancestors == [1 49 51 54]))

cellData_70 = oufti_getCellStructure(70,16,cellList)
assert(all(cellData_70.ancestors == [1 49 51 54]))
cellData_70 = oufti_getCellStructure(70,17,cellList)
assert(all(cellData_70.ancestors == [1 49 51 54]))

% -----------

clear
load('./tests/data/Ph-PA14 GFP RFP MinS_NTA s3 col11','cellList') %,'cellListN','paramString','objectParams','spotParams');

% rename cell 73 to 39 on frame 22; however, 73 is currently marked as a
% descendent of 39, so throw an error
thrown = false;
try
    editCellId( 73, 39, 22, [], cellList )
catch ME
    thrown = true;
    assert(strcmp(ME.identifier,'editCellId:oldCellIdIsNotOrphan'))
    disp(ME.message)
    global errorHint;
    disp(errorHint)
    assert(errorHint.division_frame == 21)
    assert(errorHint.last_ancestor == 39)
end
assert(thrown)



