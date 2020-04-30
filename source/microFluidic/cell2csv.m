function cell2csv(filename,cellArray,delimiter)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%function cell2csv(filename,cellArray,delimiter)
% Writes cell array content into a *.csv file.
%author:  Ahmad Paintdakhi
%@revision date:    December 19, 2012
%@copyright 2012-2013 Yale University
%==========================================================================
%********** input ********:
%filename = Name of the file to save. [ i.e. 'text.csv' ]
%cellarray = Name of the Cell Array where the data is in
% delimiter = seperating sign, normally:',' (it's default)
%==========================================================================
global paramString cellListN shiftframes handles
screenSize = get(0,'ScreenSize');

try
    % R2010a and newer
    iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
    iconsSizeEnums = javaMethod('values',iconsClassName);
    SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
    jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, 'Processing...');  % icon, label
catch
    % R2009b and earlier
    redColor   = java.awt.Color(1,0,0);
    blackColor = java.awt.Color(0,0,0);
    jObj = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
end
jObj.setPaintsWhenStopped(true);  % default = false
jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
hh =  figure('pos',[(screenSize(3)/2)-100 (screenSize(4)/2)-100 100 100],'Toolbar','none',...
    'Menubar','none','NumberTitle','off','DockControls','off');
pause(0.05);drawnow;
pos = hh.Position;
javacomponent(jObj.getComponent, [1,1,pos(3),pos(4)],hh);
pause(0.01);drawnow;
jObj.start;
% do some long operation...
tempCellList = cellArray;
if ~isfield(tempCellList,'meshData')
    tempCellList = oufti_makeNewCellListFromOld(tempCellList);
end


datei = fopen(filename,'w');
debugi = 1;

dateAndTimeDataProcessed = clock();
fprintf(debugi,'%s','%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(debugi,'\n\n');
fprintf(debugi,'%s',['MicroFluidic ".csv" file named ' char(filename) ' processed on ---> ' num2str(dateAndTimeDataProcessed(2)) ...
    '/' num2str(dateAndTimeDataProcessed(3)) '/' num2str(dateAndTimeDataProcessed(1)) ' at ' ...
    num2str(dateAndTimeDataProcessed(4)) ':' num2str(dateAndTimeDataProcessed(5))]);
fprintf(debugi,'\n\n');
fprintf(debugi,'%s','%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
fprintf(debugi,'\n\n');
try
    if ~iscell(whos('paramString'))
        paramString = get(handles.params,'string');
        for z=1:size(paramString,1)
            for s=1:size(paramString,2)
                
                var = eval('paramString{z,s}');
                
                if size(var,1) == 0
                    var = '';
                end
                
                if isnumeric(var) == 1
                    var = num2str(var);
                end
                
                fprintf(debugi,'# % s\n',var);
                
            end
        end
        fprintf(debugi,'\n');
    end
catch
end
fieldNamesCellList = {'ancestors'
    'birthframe'
    'box'
    'descendants'
    'divisions'
    'length'
    'area'
    'volume'
    'polarity'
    'signal0'
    'signal1'
    'signal2'
    'mfi0'
    'mfi1'
    'mfi2'
    'mesh'
    'spots'
    'objects'
    };

if exist('cellListN', 'var'),fprintf(debugi,'$ cellListN');fprintf(debugi,'% d',cellListN);end
fprintf(debugi,'\n');
if exist('coefPCA', 'var'),fprintf(debugi,'$ coefPCA');fprintf(debugi,'% d',coefPCA);end
fprintf(debugi,'\n');
if exist('mCell', 'var'),fprintf(debugi,'$ mCell');fprintf(debugi,'% d',mCell);end
fprintf(debugi,'\n');
if exist('shiftfluo', 'var'),fprintf(debugi,'$ shiftfluo');fprintf(debugi,'% d',shiftfluo);end
fprintf(debugi,'\n');
if exist('shiftframes', 'var')
    if isstruct(shiftframes)
        tempShiftFrames = (struct2cell(shiftframes))';
        fprintf(debugi,'$ shiftframes');
        fprintf(debugi,'% g',tempShiftFrames{1});
        fprintf(debugi,';');fprintf(debugi,'% g',tempShiftFrames{2});
    else
        fprintf(debugi,'$ shiftframes');fprintf(debugi,'% g',shiftframes);
    end
end
fprintf(debugi,'\n');
fprintf(debugi,'\n');

fprintf(debugi,'%% parameter values\n');
fprintf(datei,'frameNumber,');
for ii = 1:length(fieldNamesCellList)
    var = eval('fieldNamesCellList{ii}');
    fprintf(datei,'%s',var);
    if ii < length(fieldNamesCellList),fprintf(datei,',');end
end
fprintf(datei,',cellId;\n');

% if cell geometry data is missing, calculate it
tempCellList.meshData = getExtraDataMicroFluidic(tempCellList.meshData);

for frame = 1:length(tempCellList.meshData)
    for cells = 1:length(tempCellList.meshData{frame})
        fprintf(datei,'%d,',frame);
        
        % if cell geometry data is missing, calculate it
        cellStruct = tempCellList.meshData{frame}{cells};
%         if (~isfield(cellStruct,'length') || ~isfield(cellStruct,'area') || ~isfield(cellStruct,'volume'))
%             tempCellList.meshData{frame}{cells} = getExtraDataMicroFluidic(cellStruct);
%         end
        
        % for each field
        for ii = 1:length(fieldNamesCellList)
            switch fieldNamesCellList{ii}
                case 'ancestors'
                    if ~isfield(cellStruct,'ancestors') || isempty(cellStruct.ancestors)
                        fprintf(datei,' ,');
                    else
                        for jj = 1:length(cellStruct.ancestors) - 1
                            fprintf(datei,'%g;',cellStruct.ancestors(jj));
                        end
                        fprintf(datei,'%g,',cellStruct.ancestors(end));
                    end
                    
                case 'birthframe'
                    if ~isfield(cellStruct,'birthframe') || isempty(cellStruct.birthframe)
                        fprintf(datei,' ,');
                    else
                        for jj = 1:length(cellStruct.birthframe) - 1
                            fprintf(datei,'%g;',cellStruct.birthframe(jj));
                        end
                        fprintf(datei,'%g,',cellStruct.birthframe(end));
                    end
                    
                case 'box'
                    if ~isfield(cellStruct,'box') || isempty(cellStruct.box)
                        fprintf(datei,' ,');
                    else
                        for jj = 1:length(cellStruct.box) - 1
                            fprintf(datei,'%g;',cellStruct.box(jj));
                        end
                        fprintf(datei,'%g,',cellStruct.box(end));
                    end
                    
                case 'descendants'
                    if ~isfield(cellStruct,'descendants') || isempty(cellStruct.descendants)
                        fprintf(datei,' ,');
                    else
                        for jj = 1:length(cellStruct.descendants) - 1
                            fprintf(datei,'%g;',cellStruct.descendants(jj));
                        end
                        fprintf(datei,'%g,',cellStruct.descendants(end));
                    end
                    
                case 'divisions'
                    if ~isfield(cellStruct,'divisions') || isempty(cellStruct.divisions)
                        fprintf(datei,' ,');
                    else
                        for jj = 1:length(cellStruct.divisions) - 1
                            fprintf(datei,'%g;',cellStruct.divisions(jj));
                        end
                        fprintf(datei,'%g,',cellStruct.divisions(end));
                    end
                    
                case 'mesh'
                    if ~isfield(cellStruct,'mesh') || isempty(cellStruct.mesh)
                        fprintf(datei,' ,');
                    else
                        for jj = 1:size(cellStruct.mesh,2) - 1
                            fprintf(datei,'%g ',cellStruct.mesh(:,jj));
                            fprintf(datei,';');
                        end
                        fprintf(datei,'% g',cellStruct.mesh(:,end));
                        fprintf(datei,',');
                    end
                case {'length', 'area', 'volume'}
                    field = fieldNamesCellList{ii};
                    if ~isfield(cellStruct, field )
                        fprintf(datei,' ,');
                    else
                        fprintf(datei,'% g', cellStruct.(field) );
                        fprintf(datei,',');
                    end
                    
                case 'polarity'
                    if ~isfield(cellStruct,'polarity')
                        fprintf(datei,' ,');
                    else
                        fprintf(datei,'% g',cellStruct.polarity);
                        fprintf(datei,',');
                    end
                    
                case {'signal0', 'signal1', 'signal2'}
                    field = fieldNamesCellList{ii};
                    if ~isfield(cellStruct,field)
                        fprintf(datei,' ,');
                    else
                        fprintf(datei,'% g',cellStruct.(field));
                        fprintf(datei,',');
                    end
                case {'mfi0', 'mfi1', 'mfi2'}
                    field = fieldNamesCellList{ii};
                    signal = ['signal' field(end)];
                    if ~isfield(cellStruct,signal) || ~isfield(cellStruct,'area')
                        fprintf(datei,' ,');
                    else
                        mfi = sum(cellStruct.(signal)) / cellStruct.area;
                        fprintf(datei,'% g', mfi);
                        fprintf(datei,',');
                    end
                case 'spots'
                    if ~isfield(cellStruct,'spots')
                        fprintf(datei,' ,');
                    elseif isempty(cellStruct.spots.l)
                        fprintf(datei,' ,');
                    else
                        try
                            fprintf(datei,'% g',cellStruct.spots.l);
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.spots.d);
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.spots.x);
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.spots.y);
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.spots.positions);
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.spots.rsquared);
                            fprintf(datei,',');
                        catch
                        end
                    end
                case 'objects'
                    if ~isfield(cellStruct,'objects')
                        fprintf(datei,' ,');
                    elseif isempty(cellStruct.objects.outlines)
                        fprintf(datei,' ,');
                    else
                        for jj = 1:size(cellStruct.objects.outlines,2)-1
                            fprintf(datei,'% g',cellStruct.objects.outlines{jj}(:,1));
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.objects.outlines{jj}(:,2));
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.objects.pixels{jj});
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.objects.pixelvals{jj});
                            fprintf(datei,';');
                            fprintf(datei,'% g',cellStruct.objects.area{jj});
                            fprintf(datei,';');
                        end
                        fprintf(datei,'% g',cellStruct.objects.outlines{end}(:,1));
                        fprintf(datei,';');
                        fprintf(datei,'% g',cellStruct.objects.outlines{end}(:,2));
                        fprintf(datei,';');
                        fprintf(datei,'% g',cellStruct.objects.pixels{end});
                        fprintf(datei,';');
                        fprintf(datei,'% g',cellStruct.objects.pixelvals{end});
                        fprintf(datei,';');
                        fprintf(datei,'% g',cellStruct.objects.area{end});
                        fprintf(datei,',');
                    end
            end
        end
        fprintf(datei,'%g,\n',tempCellList.cellId{frame}(cells));
    end
end

fclose(datei);
disp(['Analysis converted from ".mat" format to ".csv" format in file ' filename]);
jObj.stop;
delete(hh)
%tar('cellAray.tgz','.');

    function d=edist(x1,y1,x2,y2)
        % complementary for "getextradata", computes the length between 2 points
        d=sqrt((x2-x1).^2+(y2-y1).^2);
    end

end
