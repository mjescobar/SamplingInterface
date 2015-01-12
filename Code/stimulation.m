

function stimulation(compressData)
oldLevel = Screen('Preference', 'VisualDebugLevel', 1);
oldSkip = Screen('Preference', 'SkipSyncTests',0);

%Serial COM
down = uint8(0);
up = uint8(1);
change = uint8(2);

filesNotCharged = false;

% Non-visual
nonVisual = ischar(compressData);
if nonVisual
    delete *.si
    dirName = sprintf('../Log/Exp__%04d_%02d_%02d-%02d.%02d.%02d',round(clock));
    mkdir(dirName)
    system(['unzip ' strrep(compressData,' ','\ ') ' -d ' dirName]);
    %unzip(compressData,dirName)
    cd(dirName)
    fileName = 'Final Configuration.si';
    if exist(fullfile(pwd,fileName),'file')
        data = getInformation(which(fileName));
    else
        filesNotCharged = true;
        disp('ERROR: Can''t open configuration file "Final Configuration.si"');
    end
else % VISUAL
    data = compressData;
end

data.startedTime = round(clock);

% Creating window
win=Screen('OpenWindow',data.screens.selected,0);
priorityLevel=MaxPriority(win);
Priority(priorityLevel);
HideCursor();
[w,h]=Screen('WindowSize',win);
refresh = Screen('GetFlipInterval', win);
Screen('TextSize',win, 20);
data.refresh = refresh;
data.screens.width = w;
data.screens.height = h;

%Matlab Pool
Screen('DrawText', win, 'Starting...', w/2-170, h/2-50, [150, 150, 0]);
Screen('Flip',win);
% if matlabpool('size')==0,
%     matlabpool OPEN
% end


% KbName('UnifyKeyNames');
% KbQueueCreate();
% KbQueueStart();
% abort = 0;
indexed = 0;
%% Charging experiment Data
for i=length(data.experiments.file)-1:-1:1,
%     if abort
%         break;
%     else
%         abort = KbQueueCheck();
%     end
    fileName = ['Exp' sprintf('%03d',data.experiments.file(i+1)) '.si'];
    if ~filesNotCharged && exist(fullfile(pwd,fileName),'file'),
        experiment(i) = getInformation(fullfile(pwd,fileName));%which(fileName));
        % Charging images
        if ~strcmp((experiment(i).mode),'Presentation')
%             experiment(i).img.charged = zeros(1,experiment(i).img.files);
%             imgName = fullfile(experiment(i).img.directory,experiment(i).img.nInitial);
%             experiment(i).img.first = imread(imgName);
%             experiment(i).img.charge = zeros([size(experiment(i).img.first),...
%                 experiment(i).img.files],class(experiment(i).img.first));
            experiment(i).img.charge = zeros(1,experiment(i).img.files);
            experiment(i).img.repeated = 0;
            % Bar variables adjust
            if experiment(i).bottomBar.is
                experiment(i).bottomBar.posLeft = (experiment(i).bottomBar.posLeft-1)*w/99.0;
                experiment(i).bottomBar.posTop = (experiment(i).bottomBar.posTop-1)*h/99.0;
                experiment(i).bottomBar.posRight = (experiment(i).bottomBar.posRight-1)*w/99.0;
                experiment(i).bottomBar.posBottom = (experiment(i).bottomBar.posBottom-1)*h/99.0;
                experiment(i).bottomBar.r = (experiment(i).bottomBar.r-experiment(i).bottomBar.baseR)/(experiment(i).bottomBar.division-1); 
                experiment(i).bottomBar.g = (experiment(i).bottomBar.g-experiment(i).bottomBar.baseG)/(experiment(i).bottomBar.division-1); 
                experiment(i).bottomBar.b = (experiment(i).bottomBar.b-experiment(i).bottomBar.baseB)/(experiment(i).bottomBar.division-1); 
            end
            if experiment(i).beforeStimulus.is && experiment(i).beforeStimulus.bar.is
                experiment(i).beforeStimulus.bar.posLeft = (experiment(i).beforeStimulus.bar.posLeft-1)*w/99.0;
                experiment(i).beforeStimulus.bar.posTop = (experiment(i).beforeStimulus.bar.posTop-1)*h/99.0;
                experiment(i).beforeStimulus.bar.posRight = (experiment(i).beforeStimulus.bar.posRight-1)*w/99.0;
                experiment(i).beforeStimulus.bar.posBottom = (experiment(i).beforeStimulus.bar.posBottom-1)*h/99.0;
            end
%         else
%             experiment(i).img.charged = nan;
        end
     else
        filesNotCharged = true;
        path = [fileName ...             'This is a intern program file, this means that were an intern error.'...
            ' You should restart the interface.'];
     end
end
total = length(data.experiments.file)-1;
for i=1:length(data.experiments.file)-1
    if strcmp(experiment(i).mode,'Presentation') || strcmp(experiment(i).mode,'White noise')
        if strcmp(experiment(i).mode,'White noise')
            experiment(i).noise = zeros(experiment(i).whitenoise.blocks*experiment(i).whitenoise.pxY,...
                experiment(i).whitenoise.blocks*experiment(i).whitenoise.pxX);
            if strcmp(experiment(i).whitenoise.type,'BW'),
                experiment(i).whitenoise.imgToComp = zeros(experiment(i).whitenoise.blocks*experiment(i).whitenoise.pxY,...
                    experiment(i).whitenoise.blocks*experiment(i).whitenoise.pxX,experiment(i).whitenoise.saveImages);
                experiment(i).noiseimg = zeros(size(experiment(i).noise));
            else
                experiment(i).whitenoise.imgToComp = zeros(experiment(i).whitenoise.blocks*experiment(i).whitenoise.pxY,...
                    experiment(i).whitenoise.blocks*experiment(i).whitenoise.pxX,...
                    3,experiment(i).whitenoise.saveImages);
                experiment(i).noiseimg = zeros([size(experiment(i).noise) 3]);
            end
        end
        continue;
    end
    difference=find((experiment(i).img.nInitial==experiment(i).img.nFinal)==0);
    nExt = find(experiment(i).img.nInitial=='.');
    ext = experiment(i).img.nInitial(nExt(end):end);
    name = experiment(i).img.nInitial(1:difference(1)-1);
    nInit = str2double(experiment(i).img.nInitial(difference(1):nExt(end)-1));
    ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
    for j=nInit:experiment(i).img.files+nInit-1,
        num = sprintf(ns,j);
        tmp = imread(fullfile(experiment(i).img.directory,strcat(name,num,ext)));
        % experiment(i).img.charge(:,:,:,pos) = imread(fullfile(experiment(i).img.directory,strcat(name,num,ext)));
        if islogical(tmp),
            tmp = uint8(tmp);
        end
        experiment(i).img.charge(j-nInit+1) = Screen('MakeTexture',win,tmp); 
        if ~mod(j,100)
            Screen('DrawText', win,['Chaging experiment ' num2str(i) ' img ' num2str(j-nInit+1) ],...
                w/2-170, i*h/(total+1), [150, 150, 0]);
            Screen('Flip',win);
        end
    end
    
    clearvars tmp;
end

% Screen('DrawText', win, 'Closing MATLAB pool...', w/2-170, h/2-50, [150, 150, 0]);
% Screen('Flip',win);
% matlabpool CLOSE
% Process aborted

if filesNotCharged % || abort
    Screen('DrawText', win, 'Process   aborted  !!', w/2-170, h/2-50, [255, 0, 0]);
    Screen('Flip',win);
    WaitSecs(1);
    Screen('Close');
    Screen('CloseAll');
    Priority(0);
    ShowCursor();
    data.finishedTime = round(clock);
    Screen('Preference', 'SkipSyncTests',oldSkip);
    Screen('Preference', 'VisualDebugLevel', oldLevel );
    if filesNotCharged
        disp(['ERROR: File not found: ' path]);
    end
        return;
end

data.serial.is = 0;
data.serial.com = '/dev/tty.SLAB_USBtoUART';
data.serial.baudrate = 115200;


if data.serial.is
%     serialCom = serial(data.serial.com,'BaudRate',data.serial.baudrate);
%     fclose(serialCom);
%     fopen(serialCom);
%     fwrite(serialCom,up);

%Using PTB IOPort commands
    IOPort('CloseAll')
    configString = 'ReceiverEnable=1 BaudRate=115200 StartBits=1 DataBits=8 StopBits=1 Parity=No RTS=0 DTR=1';
    port='/dev/cu.SLAB_USBtoUART';
    [serialCom] = IOPort('OpenSerialPort', port, configString);
    IOPort('Flush', serialCom); %flush data queued to send to device 
    IOPort('Purge', serialCom); %clear existing data queues.
    IOPort('Write', serialCom, up);
end

% The next code has the goal to charge in memmory the function imread and
% (if they are separate files) the functions to use of Screen.
% tmp = imread('black.jpg');
% texture = Screen('MakeTexture',win,tmp);
% Screen('DrawTexture', win, texture);
% Screen('Close',texture);
% clear tmp
% Screen('Flip',win);
% WaitSecs(0.5);

Screen('DrawText',win,'Experiment ready to be displayed, press any key to continue...',...
    w/2-300,h-100,[0,200,0]);
Screen('Flip',win);
pressed = 0;
KbName('UnifyKeyNames');
KbQueueCreate();
KbQueueStart();
while ~pressed,
    pressed = KbQueueCheck();
    WaitSecs(0.2);
end

KbQueueFlush();
KbQueueRelease();

%% Starting the sampling

% displaying experiment
i = 1;
time = 0;
while(i<length(data.experiments.file)),
    if filesNotCharged % || abort 
        break;
%     else
%         abort = KbQueueCheck();
    end
    time = time + 1;
    % Just background
    if strcmp(experiment(i).mode,'Presentation'),
        Screen('FillRect', win, [experiment(i).presentation.r ...
            experiment(i).presentation.g experiment(i).presentation.b]);
        T(time).start = Screen('Flip', win);
        if length(experiment)>i && experiment(i+1).beforeStimulus.is && ...
                experiment(i+1).beforeStimulus.rest,
            T(time).finish = WaitSecs((experiment(i).presentation.time - ...
                experiment(i+1).beforeStimulus.time)/1000.0 - 0.5*refresh);
        else
            T(time).finish = WaitSecs(experiment(i).presentation.time/1000.0 - 0.5*refresh);
        end
    else
        if experiment(i).img.background.isImg
            if exist(experiment(i).img.background.imgName,'file'),
                [tmp,tmpMap] = imread(experiment(i).img.background.imgName);
                if isempty(tmpMap)
                    background = Screen('MakeTexture',win,tmp);
                    clear tmp;
                else
                    % abort = 1;
                    indexed = 1;
                    break;
                end
            else
                filesNotCharged = true;
                break;
            end
        end
%         if experiment(i).img.files > 1,
%             difference=find((experiment(i).img.nInitial==experiment(i).img.nFinal)==0);
%             nExt = find(experiment(i).img.nInitial=='.');
%             ext = experiment(i).img.nInitial(nExt(end):end);
%             name = experiment(i).img.nInitial(1:difference(1)-1);
%             nInit = str2double(experiment(i).img.nInitial(difference(1):nExt(end)-1));
%             ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
%         else
%             ns = '';
%             name = experiment(i).img.nInitial;
%             ext = '';
%             nInit = 0;
%         end
%         imgName = fullfile(experiment(i).img.directory,experiment(i).img.nInitial);
%         if exist(imgName,'file'),
%             [tmp,tmpMap] = imread(imgName);
%             if isempty(tmpMap)
%                 firstStimulusTexture = experiment(i).img.charge(1); %Screen('MakeTexture',win,experiment(i).img.charge(:,:,:,1));
%                 clear tmp;
%             else
%                 % abort = 1;
%                 indexed = 1;
%                 break;
%             end
%         else
%             filesNotCharged = true;
%             break;
%         end
        if strcmp(experiment(i).mode,'White noise'),
            l1 = experiment(i).whitenoise.blocks*experiment(i).whitenoise.pxX;
            l2 = experiment(i).whitenoise.blocks*experiment(i).whitenoise.pxY;
            position = [(w-l1)/2+experiment(i).img.deltaX ...
                (h-l2)/2+experiment(i).img.deltaY ...
                (w+l1)/2+experiment(i).img.deltaX ...
                (h+l2)/2+experiment(i).img.deltaY];
        else
        firstStimulusTexture = experiment(i).img.charge(1); %Screen('MakeTexture',win,experiment(i).img.charge(:,:,:,1));
        position = [(w-experiment(i).img.size.width)/2+experiment(i).img.deltaX ...
            (h-experiment(i).img.size.height)/2+experiment(i).img.deltaY ...
            (w+experiment(i).img.size.width)/2+experiment(i).img.deltaX ...
            (h+experiment(i).img.size.height)/2+experiment(i).img.deltaY];
        end
        charged = 0;
    
        % FLICKER
        if strcmp(experiment(i).mode,'Flicker'),
            nRefreshImg = ...
                round(experiment(i).flicker.dutyCicle/(100.0*experiment(i).flicker.fps*refresh));
            nRefreshBackground = ...
                round((100-experiment(i).flicker.dutyCicle)/(100.0*experiment(i).flicker.fps*refresh));
            img = false;
            if experiment(i).flicker.repetitions == 0
                imgNumber = nInit+1;
                rep = 0;
            else
                imgNumber = nInit;
                rep = 1;
            end
            if i>1
                vbl = T(i-1).finish;
            else
                vbl = GetSecs;
            end
            if experiment(i).beforeStimulus.is
                Screen('FillRect',win,[experiment(i).beforeStimulus.background.r ...
                    experiment(i).beforeStimulus.background.g ...
                    experiment(i).beforeStimulus.background.b]);
                if experiment(i).beforeStimulus.bar.is
                    Screen('FillRect',win,[experiment(i).beforeStimulus.bar.r ...
                    experiment(i).beforeStimulus.bar.g ...
                    experiment(i).beforeStimulus.bar.b], ...
                    [experiment(i).beforeStimulus.bar.posLeft, ...
                    experiment(i).beforeStimulus.bar.posTop, ...
                    experiment(i).beforeStimulus.bar.posRight, ...
                    experiment(i).beforeStimulus.bar.posBottom]);
                end
                T(time).start = Screen('Flip', win, vbl);
                vbl = WaitSecs(round(experiment(i).beforeStimulus.time/(refresh*1000.0))*refresh-0.5*refresh);
            end
            if experiment(i).img.background.isImg
                Screen('DrawTexture',win,background);
            else
                Screen('FillRect',win,[experiment(i).img.background.r ...
                    experiment(i).img.background.g experiment(i).img.background.b]);
            end
            if experiment(i).flicker.img.is
                imgName = experiment(i).flicker.img.name;
                if exist(imgName,'file'),
                    tmp = imread(imgName);
                    flickerBackground = Screen('MakeTexture', win,tmp);
                    clear tmp;
                else
                    filesNotCharged = true;
                    break;
                end
            end
            Screen('DrawTexture', win, firstStimulusTexture,[],position);
            Screen('Close',firstStimulusTexture);
            if experiment(i).bottomBar.is
                Screen('FillRect', win,[experiment(i).bottomBar.baseR ...
                    experiment(i).bottomBar.baseG...
                    experiment(i).bottomBar.baseB], ...
                    [experiment(i).bottomBar.posLeft ...
                    experiment(i).bottomBar.posTop ...
                    experiment(i).bottomBar.posRight ...
                    experiment(i).bottomBar.posBottom]);
            end
            vbl = Screen('Flip',win,vbl);
            if ~experiment(i).beforeStimulus.is
                T(time).start = vbl;
            end
            if experiment(i).flicker.repeatBackground,
                rep = 0;
            else
                rep = experiment(i).flicker.repetitions;
            end
            for j = 2:2*(rep+1)*experiment(i).img.files,
%                 if abort
%                     break;
%                 else
%                     abort = KbCheck;
%                 end
                if img,
                    if experiment(i).img.background.isImg
                        Screen('FillRect',win,[0 0 0]);
                        Screen('DrawTexture',win,background);
                    else
                        Screen('FillRect',win,[experiment(i).img.background.r ...
                            experiment(i).img.background.g experiment(i).img.background.b]);
                    end
%                     num = sprintf(ns,imgNumber);
%                       imgName = fullfile(experiment(i).img.directory,strcat(name,num,ext));
%                     if exist(imgName,'file'),
%                         if ~strcmp(charged,imgName)
%                             tmp = imread(imgName);
                           % image = Screen('MakeTexture', win,experiment(i).img.charge(:,:,:,j));%tmp);
%                             clear tmp;
%                             charged = imgName;
%                        end
                        Screen('DrawTexture', win, experiment(i).img.charge(imgNumber-nInit+1),[],position); %image,[],position);
                        if rep==experiment(i).flicker.repetitions,
                            Screen('Close',experiment(i).img.charge(imgNumber-nInit+1));%image);
                        end
%                     else
%                         filesNotCharged = true;
%                         break;
%                     end
                    if experiment(i).bottomBar.is
                        Screen('FillRect', win,[experiment(i).bottomBar.baseR+experiment(i).bottomBar.r*mod(j-1,experiment(i).bottomBar.division) ... ...
                            experiment(i).bottomBar.baseG+experiment(i).bottomBar.g*mod(j-1,experiment(i).bottomBar.division) ...
                            experiment(i).bottomBar.baseB+experiment(i).bottomBar.b*mod(j-1,experiment(i).bottomBar.division)], ...
                            [experiment(i).bottomBar.posLeft ...
                            experiment(i).bottomBar.posTop ...
                            experiment(i).bottomBar.posRight ...
                            experiment(i).bottomBar.posBottom]);
                        %b = b + 1;
                    end
                    vbl = Screen('Flip', win, vbl + ...
                        (nRefreshBackground - 0.5) * refresh);
                    if rep == experiment(i).flicker.repetitions;
                        imgNumber = imgNumber + 1;
                        rep = 0;
                    else
                        rep = rep + 1;
                    end
                else
                    if experiment(i).flicker.img.is
                        Screen('FillRect',win,[0 0 0]);
                        Screen('DrawTexture', win, flickerBackground);
                    else
                        Screen('FillRect', win, [experiment(i).flicker.r ...
                        experiment(i).flicker.g experiment(i).flicker.b]);    
                    end
                    if experiment(i).bottomBar.is
                        Screen('FillRect', win,[experiment(i).bottomBar.baseR+experiment(i).bottomBar.r*mod(j-1,experiment(i).bottomBar.division) ... ...
                            experiment(i).bottomBar.baseG+experiment(i).bottomBar.g*mod(j-1,experiment(i).bottomBar.division) ...
                            experiment(i).bottomBar.baseB+experiment(i).bottomBar.b*mod(j-1,experiment(i).bottomBar.division)], ...
                            [experiment(i).bottomBar.posLeft ...
                            experiment(i).bottomBar.posTop ...
                            experiment(i).bottomBar.posRight ...
                            experiment(i).bottomBar.posBottom]);
                        %b = b + 1;
                    end
                    vbl = Screen('Flip', win, vbl + ...
                        (nRefreshImg - 0.5) * refresh);
                end
                img = ~img;
            end
            T(time).finish = WaitSecs((nRefreshBackground-0.5)*refresh);
            if experiment(i).flicker.img.is
                Screen('Close',flickerBackground);
            end
            if experiment(i).flicker.repeatBackground && i>1 && strcmp(experiment(i-1).mode,'Presentation') ...
                    && experiment(i).img.repeated < experiment(i).flicker.repetitions,
                experiment(i).img.repeated = experiment(i).img.repeated + 1;
                i = i-2;
            end
        elseif strcmp(experiment(i).mode,'Only stimulus (fps)'),
        % Frames per second
            nRefreshImg = round(1/(experiment(i).onlyStimulus.fps*refresh));
            if nRefreshImg==1,
                nRefreshImg = 0.5;
            end
            if i>1
                vbl = T(i-1).finish;
            else
                vbl = GetSecs;
            end
            if experiment(i).beforeStimulus.is
                Screen('FillRect',win,[experiment(i).beforeStimulus.background.r ...
                    experiment(i).beforeStimulus.background.g ...
                    experiment(i).beforeStimulus.background.b]);
                if experiment(i).beforeStimulus.bar.is
                    Screen('FillRect',win,[experiment(i).beforeStimulus.bar.r ...
                    experiment(i).beforeStimulus.bar.g ...
                    experiment(i).beforeStimulus.bar.b], ...
                    [experiment(i).beforeStimulus.bar.posLeft, ...
                    experiment(i).beforeStimulus.bar.posTop, ...
                    experiment(i).beforeStimulus.bar.posRight, ...
                    experiment(i).beforeStimulus.bar.posBottom]);
                end
                T(time).start = Screen('Flip', win, vbl);
                vbl = WaitSecs(round(experiment(i).beforeStimulus.time/(refresh*1000.0))*refresh-0.5*refresh);
            end
            b = 0;
            b_serial = 0;
            if experiment(i).img.background.isImg
                Screen('FillRect',win,[0 0 0]);
                Screen('DrawTexture',win,background);
            else
                Screen('FillRect',win,[experiment(i).img.background.r ...
                    experiment(i).img.background.g experiment(i).img.background.b]);
            end
            Screen('DrawTexture', win, firstStimulusTexture,[],position);
            % Screen('Close',firstStimulusTexture);
            if experiment(i).bottomBar.is
                Screen('FillRect', win,[experiment(i).bottomBar.baseR+experiment(i).bottomBar.r*mod(b,experiment(i).bottomBar.division) ... ...
                    experiment(i).bottomBar.baseG+experiment(i).bottomBar.g*mod(b,experiment(i).bottomBar.division) ...
                    experiment(i).bottomBar.baseB+experiment(i).bottomBar.b*mod(b,experiment(i).bottomBar.division)], ...
                    [experiment(i).bottomBar.posLeft ...
                    experiment(i).bottomBar.posTop ...
                    experiment(i).bottomBar.posRight ...
                    experiment(i).bottomBar.posBottom]);
                b = b + 1;
            end
            if data.serial.is
                % fwrite(serialCom,change);
                IOPort('Write', serialCom, change);
                b_serial = b_serial + 1;
            end
            vbl = Screen('Flip',win,vbl);
            if ~experiment(i).beforeStimulus.is
                T(time).start = vbl;
            end
            if experiment(i).onlyStimulus.repeatBackground,
                rep = 0;
            else
                rep = experiment(i).onlyStimulus.repetitions;
            end
            for j=1:rep+1,
                if j==1, tmp = nInit+1; else tmp = nInit; end
                for k=tmp:nInit+experiment(i).img.files-1, %length(experiment(i).img.charged)-1,
                    if filesNotCharged % || abort
                        break;
%                     else
%                         abort = KbQueueCheck();
                    end
                    if experiment(i).img.background.isImg
                        Screen('FillRect',win,[0 0 0]);
                        Screen('DrawTexture',win,background);
                    else
                        Screen('FillRect',win,[experiment(i).img.background.r ...
                            experiment(i).img.background.g experiment(i).img.background.b]);
                    end
%                     
%                     num = sprintf(ns,k);
%                     imgName = fullfile(experiment(i).img.directory,strcat(name,num,ext));
%                     if exist(imgName,'file'),
%                         if ~strcmp(charged,imgName)
%                             [tmp,tmpMap] = imread(imgName);
%                             if isempty(tmpMap)
                               % img = Screen('MakeTexture',win,experiment(i).img.charge(:,:,:,k-nInit));
%                                 clear tmp;
%                             else
%                                 % abort = 1;
%                                 indexed = 1;
%                                 break;
%                             end
%                             charged = imgName;
%                         end
                        Screen('DrawTexture', win, experiment(i).img.charge(k-nInit+1),[],position); %img, [], position);
                        % Screen('Close',experiment(i).img.charge(k-nInit)); %img);
%                     else
%                         filesNotCharged = true;
%                         break;
%                     end
                    if experiment(i).bottomBar.is
                        Screen('FillRect', win,[experiment(i).bottomBar.baseR+experiment(i).bottomBar.r*mod(b,experiment(i).bottomBar.division) ... ...
                            experiment(i).bottomBar.baseG+experiment(i).bottomBar.g*mod(b,experiment(i).bottomBar.division) ...
                            experiment(i).bottomBar.baseB+experiment(i).bottomBar.b*mod(b,experiment(i).bottomBar.division)], ...
                            [experiment(i).bottomBar.posLeft ...
                            experiment(i).bottomBar.posTop ...
                            experiment(i).bottomBar.posRight ...
                            experiment(i).bottomBar.posBottom]);
                        b = b + 1;
                    end
                    if data.serial.is
                        % fwrite(serialCom,change);
                        IOPort('Write', serialCom, change);
                        b_serial = b_serial + 1;
                    end
                    if nRefreshImg == 1,
                        vbl = Screen('Flip', win, vbl);
                    else
                        vbl = Screen('Flip', win, vbl + ...
                            (nRefreshImg - 0.5) * refresh);
                    end
%                     if mod(k,100)==0,
% %                         set(data.dispImg,'String', ['Img: ' num2str(k)]);
% %                         disp(get(data.dispImg,'String'));
%                         disp(['Img: ' num2str(k)]);
%                     end
                end
            end
            T(time).finish = WaitSecs((nRefreshImg - 0.5) * refresh);
            if data.serial.is
                    % fwrite(serialCom,down);
                    IOPort('Write', serialCom, down);
            end
            if experiment(i).img.background.isImg
                Screen('Close',background);
            end
            if experiment(i).onlyStimulus.repeatBackground && i>1 && strcmp(experiment(i-1).mode,'Presentation') ...
                    && experiment(i).img.repeated < experiment(i).onlyStimulus.repetitions,
                experiment(i).img.repeated = experiment(i).img.repeated + 1;
                i = i-2;
            end
        % -------------------------------------------
        % Noise
        else
            rng(experiment(i).whitenoise.seed);
            nRefreshImg = round(1/(experiment(i).whitenoise.fps*refresh));
            if nRefreshImg==1,
                nRefreshImg = 0.5;
            end
            if i>1
                vbl = T(i-1).finish;
            else
                vbl = GetSecs;
            end
            if experiment(i).beforeStimulus.is
                Screen('FillRect',win,[experiment(i).beforeStimulus.background.r ...
                    experiment(i).beforeStimulus.background.g ...
                    experiment(i).beforeStimulus.background.b]);
                if experiment(i).beforeStimulus.bar.is
                    Screen('FillRect',win,[experiment(i).beforeStimulus.bar.r ...
                    experiment(i).beforeStimulus.bar.g ...
                    experiment(i).beforeStimulus.bar.b], ...
                    [experiment(i).beforeStimulus.bar.posLeft, ...
                    experiment(i).beforeStimulus.bar.posTop, ...
                    experiment(i).beforeStimulus.bar.posRight, ...
                    experiment(i).beforeStimulus.bar.posBottom]);
                end
                T(time).start = Screen('Flip', win, vbl);
                vbl = WaitSecs(round(experiment(i).beforeStimulus.time/(refresh*1000.0))*refresh-0.5*refresh);
            end
            b = 0;
            b_serial = 0;
            if experiment(i).img.background.isImg
                Screen('FillRect',win,[0 0 0]);
                Screen('DrawTexture',win,background);
            else
                Screen('FillRect',win,[experiment(i).img.background.r ...
                    experiment(i).img.background.g experiment(i).img.background.b]);
            end
            if data.serial.is
                % fwrite(serialCom,change);
                IOPort('Write', serialCom, change);
                b_serial = b_serial + 1;
            end
            if ~experiment(i).beforeStimulus.is
                T(time).start = vbl;
            end
            for j=1:experiment(i).whitenoise.frames,
                if filesNotCharged % || abort
                    break;
%                     else
%                         abort = KbQueueCheck();
                end
                if experiment(i).img.background.isImg
                    Screen('FillRect',win,[0 0 0]);
                    Screen('DrawTexture',win,background);
                else
                    Screen('FillRect',win,[experiment(i).img.background.r ...
                        experiment(i).img.background.g experiment(i).img.background.b]);
                end
                experiment(i).noise =  randi(2,experiment(i).whitenoise.blocks,experiment(i).whitenoise.blocks)-1;
                %experiment(i).noise = Expand(experiment(i).noise,experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);
                
                if strcmp(experiment(i).whitenoise.type,'BW')
                    experiment(i).noiseimg = Expand(experiment(i).noise*254,experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);
                    if j<=experiment(i).whitenoise.saveImages,
                        experiment(i).whitenoise.imgToComp(:,:,j) = experiment(i).noiseimg;
                    end
                else
                    switch experiment(i).whitenoise.type,
                        case 'BB', experiment(i).noiseimg = Expand(cat(3, ...
                                experiment(i).noise*0,experiment(i).noise*0,...
                                experiment(i).noise*254),experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);
                        case 'BG', experiment(i).noiseimg = Expand(cat(3, ...
                                experiment(i).noise*0,experiment(i).noise*254,...
                                experiment(i).noise*0),experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);
                        case 'BC', experiment(i).noiseimg = Expand(cat(3, ...
                                experiment(i).noise*0,experiment(i).noise*254,...
                                experiment(i).noise*254),experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);
                        case 'BBGC', noise2 = randi(2,experiment(i).whitenoise.blocks,...
                                    experiment(i).whitenoise.blocks)-1;
                                experiment(i).noiseimg = Expand(cat(3, ...
                                    experiment(i).noise*0,experiment(i).noise*254,...
                                    noise2*254),experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);
                        case 'BY', experiment(i).noiseimg = Expand(cat(3, ...
                                experiment(i).noise*254,experiment(i).noise*254,...
                                experiment(i).noise*0),experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);
                        case 'BLG', experiment(i).noiseimg = Expand(cat(3, ...
                                experiment(i).noise*0,experiment(i).noise*254,...
                                (~experiment(i).noise)*254),experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);                            
                            
                        otherwise, experiment(i).noiseimg = Expand(cat(3, ...
                                experiment(i).noise*0,experiment(i).noise*0,...
                                experiment(i).noise*254),experiment(i).whitenoise.pxX,experiment(i).whitenoise.pxY);
                    end
                    if j<=experiment(i).whitenoise.saveImages,
                        experiment(i).whitenoise.imgToComp(:,:,:,j) = experiment(i).noiseimg;
                    end
                end
                
                noisetxt = Screen('MakeTexture',win,experiment(i).noiseimg);
                Screen('DrawTexture', win, noisetxt,[],position);
                Screen('Close',noisetxt);
                if experiment(i).bottomBar.is
                    Screen('FillRect', win,[experiment(i).bottomBar.baseR+experiment(i).bottomBar.r*mod(b,experiment(i).bottomBar.division) ... ...
                        experiment(i).bottomBar.baseG+experiment(i).bottomBar.g*mod(b,experiment(i).bottomBar.division) ...
                        experiment(i).bottomBar.baseB+experiment(i).bottomBar.b*mod(b,experiment(i).bottomBar.division)], ...
                        [experiment(i).bottomBar.posLeft ...
                        experiment(i).bottomBar.posTop ...
                        experiment(i).bottomBar.posRight ...
                        experiment(i).bottomBar.posBottom]);
                    b = b + 1;
                end
                if data.serial.is
                    % fwrite(serialCom,change);
                    IOPort('Write', serialCom, change);
                    b_serial = b_serial + 1;
                end
                if nRefreshImg == 1,
                    vbl = Screen('Flip', win, vbl);
                else
                    vbl = Screen('Flip', win, vbl + ...
                        (nRefreshImg - 0.5) * refresh);
                end
            end
            T(time).finish = WaitSecs((nRefreshImg - 0.5) * refresh);
            if data.serial.is
                    % fwrite(serialCom,down);
                    IOPort('Write', serialCom, down);
            end
            if experiment(i).img.background.isImg
                Screen('Close',background);
            end
            
        end % end if-else flicker-fps
    end % end if-else presentation
    i = i + 1;
end % end for(experiments)

% Process aborted by the user
% if abort
%     Screen('DrawText', win, 'Process   aborted  !!', w/2-170, h/2-50, [255, 0, 0]);
%     Screen('Flip',win);
%     WaitSecs(1);
% end

%KbQueueRelease();

%% Finishing
if ~filesNotCharged && ~indexed % && ~abort
    Screen('DrawText',win,'Process done',...
    w/2-300,h-100,[150,30,30]);
    Screen('Flip',win);
    WaitSecs(1);
end
Screen('Close');
Screen('CloseAll');
Priority(0);
ShowCursor();
data.finishedTime = round(clock);
Screen('Preference', 'SkipSyncTests',oldSkip);
Screen('Preference', 'VisualDebugLevel', oldLevel);

if data.serial.is
    %fclose(serialCom);
    IOPort('CloseAll')
end

% Process aborted because there is a missing file
if filesNotCharged
    disp(['ERROR: File not found: ' imgName]);
end
if indexed
    disp('ERROR: The frames selected are indexed and not RGB, this creates a delay in the stimulation process. Just use another stimuli.');
end
if ~filesNotCharged && ~indexed% && ~abort
    saveLogFile(data,T);
    for i=1:total,
        if strcmp(experiment(i).mode,'White noise')
            s = experiment(i).whitenoise.seed;
            fi = experiment(i).whitenoise.imgToComp;
            save(['Seed_' num2str(i) '.mat'],'s');
            save(['FirstImages_' num2str(i) '.mat'],'fi');
        end
    end
end

if nonVisual
    delete *.si
    exit
else
    return
end
end
