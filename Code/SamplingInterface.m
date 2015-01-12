function varargout = SamplingInterface(varargin)
% SamplingInterface MATLAB code for SamplingInterface.fig
%      SamplingInterface, by itself, creates a new SamplingInterface or raises the existing
%      singleton*.
%
%      H = SamplingInterface returns the handle to a new SamplingInterface or the handle to
%      the existing singleton*.
%
%      SamplingInterface('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SamplingInterface.M with the given input arguments.
%
%      SamplingInterface('Property','Value',...) creates a new SamplingInterface or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the SamplingInterface before SamplingInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SamplingInterface_OpeningFcn via varargin.
%
%      *See SamplingInterface Options on GUIDE's Tools menu.  Choose "SamplingInterface allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SamplingInterface

% Last Modified by GUIDE v2.5 25-Nov-2014 10:59:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SamplingInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @SamplingInterface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%val = str2double(get(hObject,'String'));

% --- Executes just before SamplingInterface is made visible.
function SamplingInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SamplingInterface (see VARARGIN)
delete *.si;
handles.mode = 'Flicker';
handles.img.directory=pwd;
set(handles.imgDirectory,'String',handles.img.directory);
filelist = dir(handles.img.directory);
filelist = dir_to_Win_ls(filelist);
handles.list = char('',filelist(3:size(filelist,1),:));
pos = searchFirstFile(handles.img.directory);
if pos==0,
    pos=1;
    handles.img.files = 0;
    handles.img.size.width = 0;
    handles.img.size.height = 0;
else
    handles.img.files = 1;
    set(handles.nFiles,'String',1);
    imageInfo = imfinfo(fullfile(handles.img.directory,handles.list(pos,:)));
    handles.img.size.width = imageInfo.Width;
    handles.img.size.height = imageInfo.Height;
    set(handles.imgSizeWidth,'String',handles.img.size.width);
    set(handles.imgSizeHeight,'String',handles.img.size.height);
end
handles.img.totalFiles = 0;
set(handles.imgInitial,'String',char('Initial image',handles.list(2:end,:)));
set(handles.imgFinal,'String',char('Final image',handles.list(2:end,:)));
set(handles.imgInitial,'Value',pos);
set(handles.imgFinal,'Value',pos);
handles.img.nInitial = handles.list(pos,:);
handles.img.nInitialPos = pos;
handles.img.nFinal = handles.list(pos,:);
handles.img.nFinalPos = pos;
handles.img.deltaX = 0;
handles.img.deltaY = 0;
handles.img.background.isImg = false;
handles.img.background.r = 0;
handles.img.background.g = 0;
handles.img.background.b = 0;
handles.img.background.imgName = '...';
handles.img.background.graph = zeros(1,1,3);
axes(handles.imgBackgroundGraph);
imshow(handles.img.background.graph);
handles.bottomBar.is = false;
handles.bottomBar.r = 255;
handles.bottomBar.baseR = 125;
handles.bottomBar.g = 0;
handles.bottomBar.baseG = 0;
handles.bottomBar.b = 0;
handles.bottomBar.baseB = 0;
handles.bottomBar.posLeft = 1;
handles.bottomBar.posTop = 85;
handles.bottomBar.posRight = 100;
handles.bottomBar.posBottom = 100;
handles.bottomBar.division = 4;
handles.bottomBar.graph = zeros(100,100,3);
axes(handles.bottomBarGraph);
imshow(handles.bottomBar.graph);
handles.beforeStimulus.is = false;
handles.beforeStimulus.time = 50;
handles.beforeStimulus.rest = false;
handles.beforeStimulus.background.r = 0;
handles.beforeStimulus.background.g = 0;
handles.beforeStimulus.background.b = 0;
handles.beforeStimulus.bar.is = false;
handles.beforeStimulus.bar.r = 255;
handles.beforeStimulus.bar.g = 0;
handles.beforeStimulus.bar.b = 0;
handles.beforeStimulus.bar.posLeft = 1;
handles.beforeStimulus.bar.posTop = 85;
handles.beforeStimulus.bar.posRight = 100;
handles.beforeStimulus.bar.posBottom = 100;
handles.beforeStimulus.graph = zeros(100,100,3);
axes(handles.beforeStimulusGraph);
imshow(handles.beforeStimulus.graph);
handles.flicker.time = 0;
handles.flicker.fps = 30;
handles.flicker.dutyCicle = 50;
handles.flicker.imgTime = 0;
handles.flicker.backgroundTime = 0;
handles.flicker.repetitions = 0;
handles.flicker.repeatBackground = false;
handles.flicker.r = 0;
handles.flicker.g = 0;
handles.flicker.b = 0;
handles.flicker.img.name = '...';
handles.flicker.img.is = false;
handles.flicker.graph = zeros(1,1,3);
axes(handles.flickerGraph);
imshow(handles.flicker.graph);
axes(handles.flickerSignalGraph);
periode = 1000.0/handles.flicker.fps;
t = 0:periode/100.0:periode;
signal = t < handles.flicker.dutyCicle*t(end)/100.0; 
area(t,signal); hold on;
plot(t(round(handles.flicker.dutyCicle)+1),1,'ks','MarkerFaceColor',[0 1 0],'MarkerSize',3);
if handles.flicker.dutyCicle>50
    text(t(round(handles.flicker.dutyCicle)+1)-1.85*periode/10.0,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
else
    text(t(round(handles.flicker.dutyCicle)+1)+1,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
end
ylabel('Signal'),xlabel('Time [ms]'),xlim([0 t(end)]),ylim([0 1.5]); hold off;
handles.flicker.time = handles.img.files...
            * 1/handles.flicker.fps * (handles.flicker.repetitions+1);
set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.flicker.time),'HH:MM:SS.FFF'));
handles.onlyStimulus.fps = 30;
handles.onlyStimulus.repetitions = 0;
handles.onlyStimulus.repeatBackground = false;
handles.onlyStimulus.time = handles.img.files...
    * 1/handles.onlyStimulus.fps * (handles.onlyStimulus.repetitions+1);
set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.onlyStimulus.time),'HH:MM:SS.FFF'));
handles.presentation.r = 0;
handles.presentation.g = 0;
handles.presentation.b = 0;
handles.presentation.time = 1000;
handles.presentation.graph = zeros(1,1,3);
axes(handles.presentationGraph);
imshow(handles.presentation.graph);
handles.experiments.number = 0;
handles.experiments.selected = 1;
handles.experiments.file = 0;
handles.experiments.list = 'List of experimets to execute';
handles.time = 0;
handles.screens.list = 0;
handles.screens.selected = 0;
handles.screens.height = 0;
handles.screens.width = 0;
handles.whitenoise.fps = 30;
handles.whitenoise.blocks = 100;
handles.whitenoise.pxX = 5;
handles.whitenoise.pxY = 5;
handles.whitenoise.reduceSide = 0;
handles.whitenoise.type = 'BW';
handles.whitenoise.frames = 1000;
handles.whitenoise.saveImages = 3;
rng('shuffle');
handles.whitenoise.seed = rng;
handles.whitenoise.possibleSeed = 0;
handles.whitenoise.seedFile ='...';
handles.whitenoise.time = handles.whitenoise.frames * 1/handles.whitenoise.fps;
set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.whitenoise.time),'HH:MM:SS.FFF'));
handles.modify = false;
% Choose default command line output for SamplingInterface
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SamplingInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SamplingInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% if IsWin
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% end
oldSkip = Screen('Preference', 'SkipSyncTests', 0);
oldLevel = Screen('Preference', 'VisualDebugLevel', 4);
handles.screens.list = Screen('Screens')';
handles.screens.selected = handles.screens.list(end);
set(handles.selectScreen,'String',handles.screens.list);
set(handles.selectScreen,'Value',handles.screens.selected+1);
[handles.screens.refreshRate,handles.screens.height,handles.screens.width] = ...
    getData(handles.screens.selected);
set(handles.screenHeight,'String',handles.screens.height);
set(handles.screenWidth,'String',handles.screens.width);
set(handles.screenRefreshRateHz,'String',1.0/handles.screens.refreshRate);
set(handles.screenRefreshRateMs,'String',handles.screens.refreshRate);
Screen('Preference', 'SkipSyncTests',oldSkip);
Screen('Preference', 'VisualDebugLevel', oldLevel);
handles.flicker.fps = 1.0/(2.0*handles.screens.refreshRate);
handles.onlyStimulus.fps = 1.0/(2.0*handles.screens.refreshRate);
handles.flicker.imgTime = handles.screens.refreshRate*1000;
handles.flicker.backgroundTime = handles.screens.refreshRate*1000;
axes(handles.flickerSignalGraph);
periode = 1000.0/handles.flicker.fps;
t = 0:periode/100.0:periode;
signal = t < handles.flicker.dutyCicle*t(end)/100.0; 
area(t,signal); hold on;
plot(t(round(handles.flicker.dutyCicle)+1),1,'ks','MarkerFaceColor',[0 1 0],'MarkerSize',3);
if handles.flicker.dutyCicle>50
    text(t(round(handles.flicker.dutyCicle)+1)-1.85*periode/10.0,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
else
    text(t(round(handles.flicker.dutyCicle)+1)+1,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
end
ylabel('Signal'),xlabel('Time [ms]'),xlim([0 t(end)]),ylim([0 1.5]); hold off;
set(handles.flickerFrequency,'String',handles.flicker.fps);
set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);
set(handles.whiteNoiseFps,'String',handles.onlyStimulus.fps);
set(handles.flickerNextFrequency,'String',1.0/(handles.screens.refreshRate));
set(handles.flickerPreviousFrequency,'String',1.0/(3.0*handles.screens.refreshRate));
set(handles.onlyStimulusNextFps,'String',1.0/(handles.screens.refreshRate));
set(handles.onlyStimulusPreviousFps,'String',1.0/(3.0*handles.screens.refreshRate));
set(handles.whiteNoiseNextFps,'String',1.0/(handles.screens.refreshRate));
set(handles.whiteNoisePreviousFps,'String',1.0/(3.0*handles.screens.refreshRate));
set(handles.flickerImgTime,'String',handles.flicker.imgTime);
set(handles.flickerPreviousImgTime,'String',0);
set(handles.flickerNextImgTime,'String',2*handles.flicker.imgTime);
set(handles.flickerPreviousBgndTime,'String',0);
set(handles.flickerNextBgndTime,'String',2*handles.flicker.backgroundTime);
set(handles.flickerBackgroundTime,'String',handles.flicker.backgroundTime);
steps = handles.flicker.fps*handles.screens.refreshRate;
set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
set(handles.flickerDcSlider, 'Value', 50);
set(handles.flickerDc,'String',handles.flicker.dutyCicle);
handles.modify = true;
save('Default Configuration.dsi','-struct','handles');
guidata(hObject,handles);

% --- Executes on button press in startStimulation.
function startStimulation_Callback(hObject, eventdata, handles)
% hObject    handle to startStimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(handles.experiments.file) < 2
    errordlg('There''s no experiment loaded to be run','Error');
else
%     set(handles.dispExp,'String','Starting');
%     set(handles.dispImg,'String','Starting');
%     set(handles.dispExp,'visible','on');
%     set(handles.dispImg,'visible','on');
    stimulation(handles);
%     set(handles.dispExp,'visible','off');
%     set(handles.dispImg,'visible','off');
end

function onlyStimulusFps_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.onlyStimulus.fps);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.onlyStimulus.fps);
  errordlg('Input must be a number and non negative', 'Error')
    else
        in = ceil(1.0/(in*handles.screens.refreshRate));
        handles.onlyStimulus.fps = 1.0/(in*handles.screens.refreshRate);
        if in == 1
            set(handles.onlyStimulusNextFps,'String',1.0/handles.screens.refreshRate);
        else
            set(handles.onlyStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
        end
        set(handles.onlyStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
        set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);
        if handles.beforeStimulus.is
            t = handles.beforeStimulus.time/1000.0;
        else
            t = 0;
        end
        if ~get(handles.onlyStimulusRepWithBackground,'Value')
            handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
                * (handles.onlyStimulus.repetitions+1) + t;
        else
            handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
        end
            set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.onlyStimulus.time),'HH:MM:SS.FFF'));
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of onlyStimulusFps as text
%        str2double(get(hObject,'String')) returns contents of onlyStimulusFps as a double


% --- Executes during object creation, after setting all properties.
function onlyStimulusFps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onlyStimulusFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in samplingFormat.
function samplingFormat_Callback(hObject, eventdata, handles)
% hObject    handle to samplingFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
in = get(hObject,'Value');
if in==1,
    handles.mode = 'Flicker';
    set(handles.flickerMenu,'visible','on');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','off');
elseif in==2,
    handles.mode = 'Only stimulus (fps)';
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','on');
    set(handles.whiteNoiseMenu,'visible','off');
else
    handles.mode = 'White noise';
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','on');
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns samplingFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from samplingFormat


% --- Executes during object creation, after setting all properties.
function samplingFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in beforeStimulusRest.
function beforeStimulusRest_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusRest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
handles.beforeStimulus.rest = not(handles.beforeStimulus.rest);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of beforeStimulusRest


% --- Executes on button press in useImgBeforeStimuling.
function useImgBeforeStimuling_Callback(hObject, eventdata, handles)
% hObject    handle to useImgBeforeStimuling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if handles.beforeStimulus.is,
    handles.beforeStimulus.graph = zeros(100,100,3);
    handles.beforeStimulus.is = false;
    handles.onlyStimulus.time = handles.onlyStimulus.time - handles.beforeStimulus.time/1000.0;
    handles.flicker.time = handles.flicker.time - handles.beforeStimulus.time/1000.0;
else
    handles.beforeStimulus.is = true;
    handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r;
    handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g;
    handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b;
    if handles.beforeStimulus.bar.is
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),1) = ...
                handles.beforeStimulus.bar.r ;
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),2) = ...
                handles.beforeStimulus.bar.g ;
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),3) = ...
                handles.beforeStimulus.bar.b ;
    end
    handles.onlyStimulus.time = handles.onlyStimulus.time + handles.beforeStimulus.time/1000.0;
    handles.flicker.time = handles.flicker.time + handles.beforeStimulus.time/1000.0;
    handles.whitenoise.time = handles.whitenoise.time + handles.beforeStimulus.time/1000.0;
end
    set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,handles.onlyStimulus.time),'HH:MM:SS.FFF'));
    set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,handles.flicker.time),'HH:MM:SS.FFF'));
    set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,handles.whitenoise.time),'HH:MM:SS.FFF'));
    axes(handles.beforeStimulusGraph);
    imshow(handles.beforeStimulus.graph);   
    guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of useImgBeforeStimuling



function beforeStimulusBgndB_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.background.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.background.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.background.b = in;
        handles.beforeStimulus.graph(:,:,3) = in/255.0;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),3) = ...
                    handles.beforeStimulus.bar.b/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBgndB as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBgndB as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBgndB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBgndR_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.background.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.background.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.background.r = in;
        handles.beforeStimulus.graph(:,:,1) = in/255.0;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),1) = ...
                    handles.beforeStimulus.bar.r/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of beforeStimulusBgndR as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBgndR as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBgndR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusTime_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.time);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.beforeStimulus.time);
  errordlg('Input must be a number and non negative', 'Error')
    else
        if handles.beforeStimulus.is
            handles.flicker.time = handles.flicker.time - handles.beforeStimulus.time/1000.0 + in/1000.0;
            handles.onlyStimulus.time = handles.onlyStimulus.time - handles.beforeStimulus.time/1000.0 + in/1000.0;
            set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,handles.flicker.time),'HH:MM:SS.FFF'));
            set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,handles.onlyStimulus.time),'HH:MM:SS.FFF'));
        end
        handles.beforeStimulus.time = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusTime as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusTime as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBgndG_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.background.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.background.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.background.g = in;
        handles.beforeStimulus.graph(:,:,2) = in/255.0;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),2) = ...
                    handles.beforeStimulus.bar.g/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBgndG as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBgndG as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBgndG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarLeft_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.beforeStimulus.bar.posLeft;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.beforeStimulus.bar.posLeft;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in > handles.beforeStimulus.bar.posRight,
              in = handles.beforeStimulus.bar.posLeft;
              set(hObject,'String',in);
              errordlg('Input must be equal or lower than Right value', 'Error')
        else
            handles.beforeStimulus.bar.posLeft = in;
            if handles.beforeStimulus.is,
                handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
                handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
                handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
                if handles.beforeStimulus.bar.is,
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),1) = ...
                            handles.beforeStimulus.bar.r/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),2) = ...
                            handles.beforeStimulus.bar.g/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),3) = ...
                            handles.beforeStimulus.bar.b/255.0 ;      
                end
                axes(handles.beforeStimulusGraph);
                imshow(handles.beforeStimulus.graph);
            end
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarLeft as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarLeft as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarBottom_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.beforeStimulus.bar.posBottom;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.beforeStimulus.bar.posBottom;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in < handles.beforeStimulus.bar.posTop,
              in = handles.beforeStimulus.bar.posBottom;
              set(hObject,'String',in);
              errordlg('Input must be equal or higher than Top value', 'Error')
        else
            handles.beforeStimulus.bar.posBottom = in;
            if handles.beforeStimulus.is,
                handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
                handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
                handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
                if handles.beforeStimulus.bar.is,
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),1) = ...
                            handles.beforeStimulus.bar.r/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),2) = ...
                            handles.beforeStimulus.bar.g/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),3) = ...
                            handles.beforeStimulus.bar.b/255.0 ;      
                end
                axes(handles.beforeStimulusGraph);
                imshow(handles.beforeStimulus.graph);
            end
        end
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarBottom as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarBottom as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarBottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarRight_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.beforeStimulus.bar.posRight;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.beforeStimulus.bar.posRight;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in < handles.beforeStimulus.bar.posLeft,
              in = handles.beforeStimulus.bar.posRight;
              set(hObject,'String',in);
              errordlg('Input must be equal or higher than Left value', 'Error')
        else
            handles.beforeStimulus.bar.posRight = in;
            if handles.beforeStimulus.is,
                handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
                handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
                handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
                if handles.beforeStimulus.bar.is,
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),1) = ...
                            handles.beforeStimulus.bar.r/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),2) = ...
                            handles.beforeStimulus.bar.g/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),3) = ...
                            handles.beforeStimulus.bar.b/255.0 ;      
                end
                axes(handles.beforeStimulusGraph);
                imshow(handles.beforeStimulus.graph);
            end
        end
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarRight as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarRight as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarTop_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.beforeStimulus.bar.posTop;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.beforeStimulus.bar.posTop;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in > handles.beforeStimulus.bar.posBottom,
              in = handles.beforeStimulus.bar.posTop;
              set(hObject,'String',in);
              errordlg('Input must be equal or lower than Bottom value', 'Error')
        else
            handles.beforeStimulus.bar.posTop = in;
            if handles.beforeStimulus.is,
                handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
                handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
                handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
                if handles.beforeStimulus.bar.is,
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),1) = ...
                            handles.beforeStimulus.bar.r/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),2) = ...
                            handles.beforeStimulus.bar.g/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),3) = ...
                            handles.beforeStimulus.bar.b/255.0 ;      
                end
                axes(handles.beforeStimulusGraph);
                imshow(handles.beforeStimulus.graph);
            end
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarTop as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarTop as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarB_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.bar.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.bar.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.bar.b = in;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),3) = ...
                    handles.beforeStimulus.bar.b/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarB as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarB as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarG_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.bar.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.bar.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.bar.g = in;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),2) = ...
                    handles.beforeStimulus.bar.g/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarG as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarG as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarR_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.bar.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.bar.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.bar.r = in;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),1) = ...
                    handles.beforeStimulus.bar.r/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarR as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarR as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in beforeStimulusBottomBar.
function beforeStimulusBottomBar_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if handles.beforeStimulus.bar.is
    handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
    handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
    handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
    handles.beforeStimulus.bar.is = false;
else
    handles.beforeStimulus.bar.is = true;
    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
        floor(handles.beforeStimulus.bar.posBottom),...
        floor(handles.beforeStimulus.bar.posLeft):...
        floor(handles.beforeStimulus.bar.posRight),1) = ...
            handles.beforeStimulus.bar.r/255.0 ;
    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
        floor(handles.beforeStimulus.bar.posBottom),...
        floor(handles.beforeStimulus.bar.posLeft):...
        floor(handles.beforeStimulus.bar.posRight),2) = ...
            handles.beforeStimulus.bar.g/255.0 ;
    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
        floor(handles.beforeStimulus.bar.posBottom),...
        floor(handles.beforeStimulus.bar.posLeft):...
        floor(handles.beforeStimulus.bar.posRight),3) = ...
            handles.beforeStimulus.bar.b/255.0 ;
end
if handles.beforeStimulus.is,
    axes(handles.beforeStimulusGraph);
    imshow(handles.beforeStimulus.graph); 
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of beforeStimulusBottomBar

% --- Executes on button press in insertBottomBar.
function insertBottomBar_Callback(hObject, eventdata, handles)
% hObject    handle to insertBottomBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if handles.bottomBar.is,
    handles.bottomBar.graph = zeros(100,100,3);
    handles.bottomBar.is = false;
else
    handles.bottomBar.is = true;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),1) = ...
            handles.bottomBar.r ;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),2) = ...
            handles.bottomBar.g ;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),3) = ...
            handles.bottomBar.b ;
end
    axes(handles.bottomBarGraph);
    imshow(handles.bottomBar.graph);   
    guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of insertBottomBar



function stimulusBottomBarCr_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.bottomBar.r);
  errordlg(['Input must be a number between ' num2str(handles.bottomBar.baseR) ' (base level) and 255'], 'Error')
else if (in>255 || in<handles.bottomBar.baseR),
  set(hObject,'String',handles.bottomBar.r);
  errordlg(['Input must be a number between ' num2str(handles.bottomBar.baseR) ' (base level) and 255'], 'Error')
    else
        handles.bottomBar.r = in;
        handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
            floor(handles.bottomBar.posBottom),...
            floor(handles.bottomBar.posLeft):...
            floor(handles.bottomBar.posRight),1) = in/255.0;
        if handles.bottomBar.is,
            axes(handles.bottomBarGraph);
            imshow(handles.bottomBar.graph);
        end
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarCr as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarCr as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarCr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarCg_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.bottomBar.g);
  errordlg(['Input must be a number between ' num2str(handles.bottomBar.baseG) ' (base level) and 255'], 'Error')
else if (in>255 || in<handles.bottomBar.g),
  set(hObject,'String',handles.bottomBar.g);
  errordlg(['Input must be a number between ' num2str(handles.bottomBar.baseG) ' (base level) and 255'], 'Error')
    else
        handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
            floor(handles.bottomBar.posBottom),...
            floor(handles.bottomBar.posLeft):...
            floor(handles.bottomBar.posRight),2) = in/255.0;
        if handles.bottomBar.is,
            axes(handles.bottomBarGraph);
            imshow(handles.bottomBar.graph);
        end
        handles.bottomBar.g = in;
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarCg as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarCg as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarCg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarCb_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.bottomBar.b);
  errordlg(['Input must be a number between ' num2str(handles.bottomBar.baseB) ' (base level) and 255'], 'Error')
else if (in>255 || in<handles.bottomBar.baseB),
  set(hObject,'String',handles.bottomBar.b);
  errordlg(['Input must be a number between ' num2str(handles.bottomBar.baseB) ' (base level) and 255'], 'Error')
    else
        handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
            floor(handles.bottomBar.posBottom),...
            floor(handles.bottomBar.posLeft):...
            floor(handles.bottomBar.posRight),3) = in/255.0;
        if handles.bottomBar.is,
            axes(handles.bottomBarGraph);
            imshow(handles.bottomBar.graph);
        end
        handles.bottomBar.b = in;
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarCb as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarCb as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarCb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarT_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.bottomBar.posTop;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.bottomBar.posTop;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in > handles.bottomBar.posBottom,
              in = handles.bottomBar.posTop;
              set(hObject,'String',in);
              errordlg('Input must be equal or lower than Bottom value', 'Error')
        else
            handles.bottomBar.posTop = in;
            handles.bottomBar.graph = zeros(100,100,3);
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),1) = ...
                    handles.bottomBar.r ;
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),2) = ...
                    handles.bottomBar.g ;
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),3) = ...
                    handles.bottomBar.b ;                
            if handles.bottomBar.is,
                axes(handles.bottomBarGraph);
                imshow(handles.bottomBar.graph);
            end           
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarT as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarT as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarR_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.bottomBar.posRight;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.bottomBar.posRight;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in < handles.bottomBar.posLeft,
              in = handles.bottomBar.posRight;
              set(hObject,'String',in);
              errordlg('Input must be equal or higher than Left value', 'Error')
        else
            handles.bottomBar.posRight = in;
            handles.bottomBar.graph = zeros(100,100,3);
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),1) = ...
                    handles.bottomBar.r ;
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),2) = ...
                    handles.bottomBar.g ;
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),3) = ...
                    handles.bottomBar.b ;                
            if handles.bottomBar.is,
                axes(handles.bottomBarGraph);
                imshow(handles.bottomBar.graph);
            end          
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarR as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarR as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarB_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.bottomBar.posBottom;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.bottomBar.posBottom;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in < handles.bottomBar.posTop,
              in = handles.bottomBar.posBottom;
              set(hObject,'String',in);
              errordlg('Input must be equal or higher than Left value', 'Error')
        else
            handles.bottomBar.posBottom = in;
            handles.bottomBar.graph = zeros(100,100,3);
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),1) = ...
                    handles.bottomBar.r ;
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),2) = ...
                    handles.bottomBar.g ;
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),3) = ...
                    handles.bottomBar.b ;                
            if handles.bottomBar.is,
                axes(handles.bottomBarGraph);
                imshow(handles.bottomBar.graph);
            end        
        end
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarB as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarB as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarL_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.bottomBar.posLeft;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.bottomBar.posLeft;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in > handles.bottomBar.posRight,
              in = handles.bottomBar.posLeft;
              set(hObject,'String',in);
              errordlg('Input must be equal or lower than Right value', 'Error')
        else
            handles.bottomBar.posLeft = in;
            handles.bottomBar.graph = zeros(100,100,3);
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),1) = ...
                    handles.bottomBar.r ;
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),2) = ...
                    handles.bottomBar.g ;
            handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
                floor(handles.bottomBar.posBottom),...
                floor(handles.bottomBar.posLeft):...
                floor(handles.bottomBar.posRight),3) = ...
                    handles.bottomBar.b ;                
            if handles.bottomBar.is,
                axes(handles.bottomBarGraph);
                imshow(handles.bottomBar.graph);
            end
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarL as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarL as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function beforeStimulusGraph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate beforeStimulusGraph


% --- Executes during object creation, after setting all properties.
function bottomBarGraph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bottomBarGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate bottomBarGraph


% --- Executes during object deletion, before destroying properties.
function bottomBarGraph_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to bottomBarGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function flickerFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to flickerFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = str2double(get(handles.flickerNextFrequency,'String'));
  in = round(1.0/(in*handles.screens.refreshRate))+1;
  set(hObject,'String',1.0/(in*handles.screens.refreshRate));
  errordlg('Input must be a number and non negative', 'Error')
else if in<=0,
  in = str2double(get(handles.flickerNextFrequency,'String'));
  in = round(1.0/(in*handles.screens.refreshRate))+1;
  set(hObject,'String',1.0/(in*handles.screens.refreshRate));
  errordlg('Input must be a positive number', 'Error')
    else
        in = ceil(1.0/(in*handles.screens.refreshRate));
        fps = 1.0/(in*handles.screens.refreshRate);
        if in == 1
            set(handles.flickerNextFrequency,'String',1.0/handles.screens.refreshRate);
        else
            set(handles.flickerNextFrequency,'String',1.0/((in-1)*handles.screens.refreshRate));
        end
        set(handles.flickerPreviousFrequency,'String',1.0/((in+1)*handles.screens.refreshRate));
        previousSteps = get(handles.flickerDcSlider,'SliderStep');
        steps = fps*handles.screens.refreshRate;
        set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
        dc = str2double(get(handles.flickerDc,'String'));
        if steps == 1,
            dc = 100;
        else
            if dc ~= 0 && dc ~= 100
                actualPos = dc/(100*previousSteps(1));
                if steps>previousSteps(1),
                    if mod(round(1.0/steps),2) ~= 0
                        dc = steps*actualPos*100;
                    else
                        dc = steps*(actualPos-1)*100;
                    end
                else 
                    if mod(round(1.0/steps),2) ~= 0 
                        dc = steps*(actualPos+1)*100;
                    else
                        dc = steps*actualPos*100;
                    end
                end
            end
        end
        if dc>100, dc = 100; end
        set(handles.flickerDcSlider, 'Value', dc);
        set(handles.flickerDc, 'String', dc);
        set(hObject,'String',fps);
        if get(handles.flickerFreqConf,'Value')
            handles.flicker.fps = fps;
            handles.flicker.dutyCicle = dc;
            handles.flicker.time = actualizeTemporalGraph(handles);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerFrequency as text
%        str2double(get(hObject,'String')) returns contents of flickerFrequency as a double


% --- Executes during object creation, after setting all properties.
function flickerFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function flickerR_Callback(hObject, eventdata, handles)
% hObject    handle to flickerR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.flicker.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.flicker.r = in;
        handles.flicker.graph(:,:,1) = in/255.0;
        axes(handles.flickerGraph);
        imshow(handles.flicker.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerR as text
%        str2double(get(hObject,'String')) returns contents of flickerR as a double


% --- Executes during object creation, after setting all properties.
function flickerR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flickerG_Callback(hObject, eventdata, handles)
% hObject    handle to flickerG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.flicker.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.flicker.g = in;
        handles.flicker.graph(:,:,2) = in/255.0;
        axes(handles.flickerGraph);
        imshow(handles.flicker.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerG as text
%        str2double(get(hObject,'String')) returns contents of flickerG as a double


% --- Executes during object creation, after setting all properties.
function flickerG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flickerB_Callback(hObject, eventdata, handles)
% hObject    handle to flickerB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.flicker.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.flicker.b = in;
        handles.flicker.graph(:,:,3) = in/255.0;
        axes(handles.flickerGraph);
        imshow(handles.flicker.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerB as text
%        str2double(get(hObject,'String')) returns contents of flickerB as a double


% --- Executes during object creation, after setting all properties.
function flickerB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function presentationR_Callback(hObject, eventdata, handles)
% hObject    handle to presentationR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.presentation.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.presentation.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.presentation.r = in;
        handles.presentation.graph(:,:,1) = in/255.0;
        axes(handles.presentationGraph);
        imshow(handles.presentation.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationR as text
%        str2double(get(hObject,'String')) returns contents of presentationR as a double


% --- Executes during object creation, after setting all properties.
function presentationR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function presentationG_Callback(hObject, eventdata, handles)
% hObject    handle to presentationG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.presentation.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.presentation.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.presentation.g = in;
        handles.presentation.graph(:,:,2) = in/255.0;
        axes(handles.presentationGraph);
        imshow(handles.presentation.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationG as text
%        str2double(get(hObject,'String')) returns contents of presentationG as a double


% --- Executes during object creation, after setting all properties.
function presentationG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function presentationB_Callback(hObject, eventdata, handles)
% hObject    handle to presentationB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.presentation.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.presentation.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.presentation.b = in;
        handles.presentation.graph(:,:,3) = in/255.0;
        axes(handles.presentationGraph);
        imshow(handles.presentation.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationB as text
%        str2double(get(hObject,'String')) returns contents of presentationB as a double


% --- Executes during object creation, after setting all properties.
function presentationB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function setAll(handles)
if strcmp(handles.mode,'Flicker'),
    set(handles.samplingFormat,'Value',1.0);
    set(handles.flickerMenu,'visible','on');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','off');
elseif strcmp(handles.mode,'Only stimulus (fps)'),
    set(handles.samplingFormat,'Value',2.0);
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','on');
    set(handles.whiteNoiseMenu,'visible','off');
else
    set(handles.samplingFormat,'Value',2.0);
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','on');
end
set(handles.imgDirectory,'String',handles.img.directory);
set(handles.imgInitial,'String',char('Initial image',handles.list(2:end,:)));
set(handles.imgFinal,'String',char('Final image',handles.list(2:end,:)));
set(handles.imgInitial,'Value',handles.img.nInitialPos);
set(handles.imgFinal,'Value',handles.img.nFinalPos);
set(handles.nFiles,'String',handles.img.files);
if handles.img.background.isImg
    set(handles.backgroundImg,'Value',1.0);
    set(handles.backgroundColor,'Value',0.0);
else
    set(handles.backgroundImg,'Value',0.0);
    set(handles.backgroundColor,'Value',1.0);
end
set(handles.backgroundR,'String',handles.img.background.r);
set(handles.backgroundG,'String',handles.img.background.g);
set(handles.backgroundB,'String',handles.img.background.b);
handles.img.background.graph(:,:,1) = handles.img.background.r/255.0;
handles.img.background.graph(:,:,2) = handles.img.background.g/255.0;
handles.img.background.graph(:,:,3) = handles.img.background.b/255.0;
axes(handles.imgBackgroundGraph);
imshow(handles.img.background.graph);
set(handles.backgroundImgDirection,'String',handles.img.background.imgName);
set(handles.stimulusBottomBarLevelR,'String',handles.bottomBar.baseR);
set(handles.stimulusBottomBarLevelG,'String',handles.bottomBar.baseG);
set(handles.stimulusBottomBarLevelB,'String',handles.bottomBar.baseB);
set(handles.stimulusBottomBarCr,'String',handles.bottomBar.r);
set(handles.stimulusBottomBarCg,'String',handles.bottomBar.g);
set(handles.stimulusBottomBarCb,'String',handles.bottomBar.b);
set(handles.stimulusBottomBarL,'String',handles.bottomBar.posLeft);
set(handles.stimulusBottomBarT,'String',handles.bottomBar.posTop);
set(handles.stimulusBottomBarR,'String',handles.bottomBar.posRight);
set(handles.stimulusBottomBarB,'String',handles.bottomBar.posBottom);
handles.bottomBar.graph = zeros(100,100,3);
if handles.bottomBar.is,
    set(handles.insertBottomBar,'Value',1.0);
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),1) = ...
            handles.bottomBar.r/255.0 ;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),2) = ...
            handles.bottomBar.g/255.0 ;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),3) = ...
            handles.bottomBar.b/255.0 ;
else
    set(handles.insertBottomBar,'Value',0.0);
end
axes(handles.bottomBarGraph);
imshow(handles.bottomBar.graph);
set(handles.beforeStimulusTime,'String',handles.beforeStimulus.time);
if handles.beforeStimulus.rest,
    set(handles.beforeStimulusRest,'Value',1.0);
else
    set(handles.beforeStimulusRest,'Value',0.0);
end
set(handles.beforeStimulusBgndR,'String',handles.beforeStimulus.background.r);
set(handles.beforeStimulusBgndG,'String',handles.beforeStimulus.background.g);
set(handles.beforeStimulusBgndB,'String',handles.beforeStimulus.background.b);
set(handles.beforeStimulusBottomBarR,'String',handles.beforeStimulus.bar.r);
set(handles.beforeStimulusBottomBarG,'String',handles.beforeStimulus.bar.g);
set(handles.beforeStimulusBottomBarB,'String',handles.beforeStimulus.bar.b);
set(handles.beforeStimulusBottomBarLeft,'String',handles.beforeStimulus.bar.posLeft);
set(handles.beforeStimulusBottomBarTop,'String',handles.beforeStimulus.bar.posTop);
set(handles.beforeStimulusBottomBarRight,'String',handles.beforeStimulus.bar.posRight);
set(handles.beforeStimulusBottomBarBottom,'String',handles.beforeStimulus.bar.posBottom);
if handles.beforeStimulus.is,
    set(handles.useImgBeforeStimuling,'Value',1.0);
    handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
    handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
    handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
    if handles.beforeStimulus.bar.is
        set(handles.beforeStimulusBottomBar,'Value',1.0);
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),1) = ...
                handles.beforeStimulus.bar.r/255.0 ;
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),2) = ...
                handles.beforeStimulus.bar.g/255.0 ;
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),3) = ...
                handles.beforeStimulus.bar.b/255.0 ;
    else
        set(handles.beforeStimulusBottomBar,'Value',0.0);
    end
else
    set(handles.useImgBeforeStimuling,'Value',0.0);
    handles.beforeStimulus.graph = zeros(100,100,3);
    if handles.beforeStimulus.bar.is
        set(handles.beforeStimulusBottomBar,'Value',1.0);
    else
        set(handles.beforeStimulusBottomBar,'Value',0.0);
    end
end
axes(handles.beforeStimulusGraph);
imshow(handles.beforeStimulus.graph);
set(handles.flickerFrequency,'String',handles.flicker.fps);
set(handles.flickerDc,'String',handles.flicker.dutyCicle);
set(handles.flickerImageRepetition,'String',handles.flicker.repetitions);
set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.flicker.time),'HH:MM:SS.FFF'));
set(handles.flickerR,'String',handles.flicker.r);
set(handles.flickerG,'String',handles.flicker.g);
set(handles.flickerB,'String',handles.flicker.b);
if handles.flicker.img.is
    set(handles.flickerUseImg,'Value',1.0);
else
    set(handles.flickerUseImg,'Value',0.0);
end
set(handles.flickerImgDirection,'String',handles.flicker.img.name);
handles.flicker.graph(:,:,1) = handles.flicker.r/255.0;
handles.flicker.graph(:,:,2) = handles.flicker.g/255.0;
handles.flicker.graph(:,:,3) = handles.flicker.b/255.0;
axes(handles.flickerGraph);
imshow(handles.flicker.graph);
axes(handles.flickerSignalGraph);
periode = 1000.0/handles.flicker.fps;
t = 0:periode/100.0:periode;
signal = t < handles.flicker.dutyCicle*t(end)/100.0; 
area(t,signal); hold on;
plot(t(round(handles.flicker.dutyCicle)+1),1,'ks','MarkerFaceColor',[0 1 0],'MarkerSize',3);
if handles.flicker.dutyCicle>50
    text(t(round(handles.flicker.dutyCicle)+1)-1.85*periode/10.0,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
else
    text(t(round(handles.flicker.dutyCicle)+1)+1,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
end
ylabel('Signal'),xlabel('Time [ms]'),xlim([0 t(end)]),ylim([0 1.5]); hold off;
set(handles.flickerNextFrequency,'String',1.0/(handles.screens.refreshRate));
set(handles.flickerPreviousFrequency,'String',1.0/(3.0*handles.screens.refreshRate));
set(handles.onlyStimulusNextFps,'String',1.0/(handles.screens.refreshRate));
set(handles.onlyStimulusPreviousFps,'String',1.0/(3.0*handles.screens.refreshRate));
steps = handles.flicker.fps*handles.screens.refreshRate;
set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
set(handles.flickerDcSlider, 'Value', 50);
set(handles.flickerDc,'String',handles.flicker.dutyCicle);
set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);
set(handles.onlyStimulusImageRepeatition,'String',handles.onlyStimulus.repetitions);
set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.onlyStimulus.time),'HH:MM:SS.FFF'));
set(handles.presentationR,'String',handles.presentation.r);
set(handles.presentationG,'String',handles.presentation.g);
set(handles.presentationB,'String',handles.presentation.b);
set(handles.presentationTime,'String',handles.presentation.time);
handles.presentation.graph(:,:,1) = handles.presentation.r/255.0;
handles.presentation.graph(:,:,2) = handles.presentation.g/255.0;
handles.presentation.graph(:,:,3) = handles.presentation.b/255.0;
axes(handles.presentationGraph);
imshow(handles.presentation.graph);
set(handles.experimentList,'String',handles.experiments.list);
set(handles.experimentList,'Value',1.0);

% --------------------------------------------------------------------
function restart_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to restart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
delete *.si;
inputHandles = getInformation('Default Configuration.dsi');
handles = replaceHandles(handles,inputHandles);
setAll(handles);
guidata(hObject,handles);


% --------------------------------------------------------------------
function openFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
[name, direction] = uigetfile({'*.zip'},'Open configuration file');

if IsWin
    separate = '\';
else
    separate = '/';
end

if name~=0,
    temp = [pwd separate 'temporalFolder'];
    mkdir (temp);
    fileattrib(temp,'+w','a','s');
    unzip(fullfile(direction,name),temp);
    inputHandles = getInformation([temp separate 'Final Configuration.si'],0);
    delete([temp separate 'Final Configuration.si']);
    if inputHandles.screens.refreshRate ~= handles.screens.refreshRate
        msg = sprintf(['The refresh rate of the selected file doesn''t match '...
        'with the actual refresh rate. The difference between them are %d [Hz]\n\n'...
         'Are you shure you want to open this file?'],...
        abs(1.0/handles.screens.refreshRate-1.0/inputHandles.screens.refreshRate));
        q = questdlg(msg,...
        'Different refresh rate','Yes','No','No');
        if isempty(q) || strcmp(q,'No')
            return;
        end
    end  
    delete *.si;
    copyfile([temp separate '*.si'],pwd);
    rmdir(temp,'s');
    handles = replaceHandles(handles,inputHandles);
    setAll(handles);
    guidata(hObject,handles);
end


% --------------------------------------------------------------------
function saveFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
fileName=sprintf('%04d_%02d_%02d-%02d.%02d.%02d.zip',round(clock));
in = uigetdir(pwd,'Select a directory where the file will be saved');
if in~=0
    name = strtrim(inputdlg('Insert the name of the file to be saved. Remember! the default experiment name used by stimulation scripts is "experiment.zip" and should be located at Documents/Matlab/Experiments/ folder, you are aware!','Insert file name',1,cellstr(fileName)));
    if ~isempty(name)
        save('Final Configuration.si','-struct','handles');
        zip(fullfile(in,name{1}),'*.si');
        selection = questdlg(['Do you want to create a Script ' ...
            'that runs the saved file?'],'Exit','Yes','No','Yes'); 
        if ~isempty(selection) && strcmp(selection,'Yes')
            createScript(fullfile(in,name{1}));
        end
        selection = questdlg(['Do you want to close the ' ...
            'Sampling Interface and Matlab?'],'Exit','Yes','No','Yes'); 
        if isempty(selection)
            return
        end
        switch selection, 
          case 'Yes',
             delete *.si;
             delete *.dsi;
             Screen('Preference', 'SkipSyncTests', 0);
             Screen('Preference', 'VisualDebugLevel', 4);
             delete(gcf);
             exit;
            otherwise
             return 
        end
    end
end
guidata(hObject,handles);


function imgDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to imgDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if ~isempty(in),
    if exist(in,'dir'),
        pos = searchFirstFile(in);
        if pos,
            handles.img.directory = in;
            filelist = dir(in);
            filelist = dir_to_Win_ls(filelist);
            handles.list = char('',filelist(3:size(filelist,1),:));
            set(handles.imgInitial,'String',char('Initial image',handles.list(2:end,:)));
            set(handles.imgFinal,'String',char('Final Image',handles.list(2:end,:)));
            set(handles.imgInitial,'Value',pos);
            set(handles.imgFinal,'Value',pos);
            set(handles.nFiles,'String',1);
            handles.img.nInitial = handles.list(pos,:);
            handles.img.nInitialPos = pos;
            handles.img.nFinal = handles.list(pos,:);
            handles.img.nFinalPos = pos;
            handles.img.files = 1;
            imageInfo = imfinfo(fullfile(handles.img.directory,handles.img.nInitial));
            if handles.img.size.width ~=0 && handles.img.deltaX~=0 && handles.img.deltaY~=0 &&...
                    (handles.img.size.width ~= imageInfo.Width || ...
                    handles.img.size.height ~= imageInfo.Height),
                answ = questdlg(['The stimulus of this new folder have different size. '...
                    'Would you like to conserve the default image position (Delta X, Delta Y)?'],...
                    'Conserve image position','Yes','No','No');
                if ~isempty(answ) && strcmp(answ,'No'),
                    handles.img.deltaX = 0;
                    handles.img.deltaY = 0;
                    set(handles.imgDeltaX,'String',handles.img.deltaX);
                    set(handles.imgDeltaY,'String',handles.img.deltaY);
                end
            end
            handles.img.size.width = imageInfo.Width;
            handles.img.size.height = imageInfo.Height;
            set(handles.imgSizeWidth,'String',handles.img.size.width);
            set(handles.imgSizeHeight,'String',handles.img.size.height);
            if handles.beforeStimulus.is,
                t = handles.beforeStimulus.time/1000.0;
            else
                t = 0;
            end
            if ~get(handles.flickerRepWithBackground,'Value')
                handles.flicker.time = handles.img.files/handles.flicker.fps *...
                    (handles.flicker.repetitions+1) + t;
            else
                handles.flicker.time = handles.img.files/handles.flicker.fps *+ t;
            end
            set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.flicker.time),'HH:MM:SS.FFF'));
            if ~get(handles.onlyStimulusRepWithBackground,'Value')
                handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
                    * (handles.onlyStimulus.repetitions+1) + t;
            else
                handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
            end
                set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                    handles.onlyStimulus.time),'HH:MM:SS.FFF'));
            handles.whitenoise.time = 1/handles.whitenoise.fps + t;
            set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.whitenoise.time),'HH:MM:SS.FFF'));
        else
            errordlg('Directory has no supported image file','Error');
            set(handles.imgDirectory,'String',handles.img.directory);
        end
    else
        errordlg('Directory doesn''t exist','Error');
        set(handles.imgDirectory,'String',handles.img.directory);
    end
else
    errordlg('Directory name can''t be empty','Error');
    set(handles.imgDirectory,'String',handles.img.directory);
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of imgDirectory as text
%        str2double(get(hObject,'String')) returns contents of imgDirectory as a double


% --- Executes during object creation, after setting all properties.
function imgDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',pwd);


% --- Executes on button press in selectDirectory.
function selectDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to selectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = uigetdir;
if in~=0,
    pos = searchFirstFile(in);
    if pos,
        handles.img.directory = in;
        set(handles.imgDirectory,'String',in);
        filelist = dir(in);
        filelist = dir_to_Win_ls(filelist);
        handles.list = char('',filelist(3:size(filelist,1),:));
        set(handles.imgInitial,'String',char('Initial image',handles.list(2:end,:)));
        set(handles.imgFinal,'String',char('Final image',handles.list(2:end,:)));
        set(handles.imgInitial,'Value',pos);
        set(handles.imgFinal,'Value',pos);
        set(handles.nFiles,'String',1);
        handles.img.nInitial = handles.list(pos,:);
        handles.img.nInitialPos = pos;
        handles.img.nFinal = handles.list(pos,:);
        handles.img.nFinalPos = pos;
        imageInfo = imfinfo(fullfile(handles.img.directory,handles.img.nInitial));
        if handles.img.size.width ~=0 && handles.img.deltaX~=0 && handles.img.deltaY~=0 && ...
                (handles.img.size.width ~= imageInfo.Width || ...
                handles.img.size.height ~= imageInfo.Height),
            answ = questdlg(['The stimulus of this new folder have different size. '...
                'Would you like to conserve the default image position (Delta X, Delta Y)?'],...
                'Conserve image position','Yes','No','No');
            if ~isempty(answ) && strcmp(answ,'No'),
                handles.img.deltaX = 0;
                handles.img.deltaY = 0;
                set(handles.imgDeltaX,'String',handles.img.deltaX);
                set(handles.imgDeltaY,'String',handles.img.deltaY);
            end
        end
        handles.img.size.width = imageInfo.Width;
        handles.img.size.height = imageInfo.Height;
        set(handles.imgSizeWidth,'String',handles.img.size.width);
        set(handles.imgSizeHeight,'String',handles.img.size.height);
        handles.img.files = 1;
        if handles.beforeStimulus.is,
            t = handles.beforeStimulus.time/1000.0;
        else
            t = 0;
        end
        if ~get(handles.flickerRepWithBackground,'Value')
            handles.flicker.time = handles.img.files/handles.flicker.fps *...
                (handles.flicker.repetitions+1) + t;
        else
            handles.flicker.time = handles.img.files/handles.flicker.fps *+ t;
        end
        set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.flicker.time),'HH:MM:SS.FFF'));
        if ~get(handles.onlyStimulusRepWithBackground,'Value')
            handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
                * (handles.onlyStimulus.repetitions+1) + t;
        else
            handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
        end
            set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.onlyStimulus.time),'HH:MM:SS.FFF'));
        handles.whitenoise.time = 1/handles.whitenoise.fps + t;
        set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.whitenoise.time),'HH:MM:SS.FFF'));
    else
        errordlg('Directory has no supported image files','Error');
        set(handles.imgDirectory,'String',handles.img.directory);
    end
        
end
guidata(hObject,handles);


% --- Executes on selection change in imgInitial.
function imgInitial_Callback(hObject, eventdata, handles)
% hObject    handle to imgInitial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',handles.img.nInitialPos);
    return
end
dirlist = dir(handles.img.directory);
pos = get(hObject,'Value');
if pos~=1 && (dirlist(pos+1).isdir || ~supportedImageFormat(dirlist(pos+1).name)),
    errordlg('The selected file is not a supported image file','Error');
    set(hObject,'Value',handles.img.nInitialPos);
else if pos~=1
        handles.img.nInitial = handles.list(pos,:);
        handles.img.nInitialPos = pos;
        imageInfo = imfinfo(fullfile(handles.img.directory,handles.img.nInitial));
        if handles.img.size.width ~=0 && handles.img.deltaX~=0 && handles.img.deltaY~=0 && ...
                (handles.img.size.width ~= imageInfo.Width || ...
                handles.img.size.height ~= imageInfo.Height),
            answ = questdlg(['The stimulus of this new folder have different size. '...
                'Would you like to conserve the default image position (Delta X, Delta Y)?'],...
                'Conserve image position','Yes','No','No');
            if ~isempty(answ) && strcmp(answ,'No'),
                handles.img.deltaX = 0;
                handles.img.deltaY = 0;
                set(handles.imgDeltaX,'String',handles.img.deltaX);
                set(handles.imgDeltaY,'String',handles.img.deltaY);
            end
        end
        handles.img.size.width = imageInfo.Width;
        handles.img.size.height = imageInfo.Height;
        set(handles.imgSizeWidth,'String',handles.img.size.width);
        set(handles.imgSizeHeight,'String',handles.img.size.height);
        difference=find((handles.img.nInitial==handles.img.nFinal)==0);
        if ~isempty(difference),
            nExt = find(handles.img.nInitial=='.');
            ext = handles.img.nInitial(nExt:end);
            name = handles.img.nInitial(1:difference(1)-1);
            nInit = str2double(handles.img.nInitial(difference(1):nExt(end)-1));
            nFinal = str2double(handles.img.nFinal(difference(1):nExt(end)-1));
%             ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
%             files = 0;
%             for i=nInit:nFinal,
%                 num = sprintf(ns,i);
%                 display(fullfile(handles.img.directory,strcat(name,num,ext)));
%                 if exist(fullfile(handles.img.directory,strcat(name,num,ext)),'file'),
%                     files = files + 1;
%                 end
%             end
            if nFinal - nInit < 0,
                files = 0;
            else
            files = nFinal - nInit + 1;
            end
            set(handles.nFiles,'String',files);
            handles.img.files = files;
        else
            set(handles.nFiles,'String',1);
            handles.img.files = 1;
            files = 1;
        end
        if handles.beforeStimulus.is,
            t = handles.beforeStimulus.time/1000.0;
        else
            t = 0;
        end
        if ~get(handles.flickerRepWithBackground,'Value')
            handles.flicker.time = handles.img.files/handles.flicker.fps *...
                (handles.flicker.repetitions+1) + t;
        else
            handles.flicker.time = handles.img.files/handles.flicker.fps *+ t;
        end
        set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.flicker.time),'HH:MM:SS.FFF'));
        if ~get(handles.onlyStimulusRepWithBackground,'Value')
            handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
                * (handles.onlyStimulus.repetitions+1) + t;
        else
            handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
        end
        set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.onlyStimulus.time),'HH:MM:SS.FFF'));
        handles.whitenoise.time = handles.whitenoise.frames*1/handles.whitenoise.fps + t;
        set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.whitenoise.time),'HH:MM:SS.FFF'));
    else
        set(handles.nFiles,'String',0);
        handles.img.files = 0;
    end
end
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns imgInitial contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imgInitial


% --- Executes during object creation, after setting all properties.
function imgInitial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgInitial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function imgFinal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgFinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in imgFinal.
function imgFinal_Callback(hObject, eventdata, handles)
% hObject    handle to imgFinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',handles.img.nInitialPos);
    return
end
dirlist = dir(handles.img.directory);
pos = get(hObject,'Value');
if pos~=1 && (dirlist(pos+1).isdir || ~supportedImageFormat(dirlist(pos+1).name)),
    errordlg('The selected file is not a supported image file','Error');
    set(hObject,'Value',handles.img.nFinalPos);
else if pos~=1,
        handles.img.nFinal = handles.list(pos,:);
        handles.img.nFinalPos = pos;
        difference=find((handles.img.nInitial==handles.img.nFinal)==0);
        if ~isempty(difference),
            nExt = find(handles.img.nInitial=='.');
            ext = handles.img.nInitial(nExt:end);
            name = handles.img.nInitial(1:difference(1)-1);
            nInit = str2double(handles.img.nInitial(difference(1):nExt(end)-1));
            nFinal = str2double(handles.img.nFinal(difference(1):nExt(end)-1));
%             ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
%             files = 0;
%             for i=nInit:nFinal,
%                 num = sprintf(ns,i);
%                 if exist(fullfile(handles.img.directory,strcat(name,num,ext)),'file'),
%                     files = files + 1;
%                 end
%             end
            if nFinal - nInit < 0,
                files = 0;
            else
                files = nFinal - nInit + 1;
            end
            set(handles.nFiles,'String',files);
            handles.img.files = files;
        else
            set(handles.nFiles,'String',1);
            handles.img.files = 1;
            files = 1;
        end
        if handles.beforeStimulus.is,
            t = handles.beforeStimulus.time/1000.0;
        else
            t = 0;
        end
        if ~get(handles.flickerRepWithBackground,'Value')
            handles.flicker.time = handles.img.files/handles.flicker.fps *...
                (handles.flicker.repetitions+1) + t;
        else
            handles.flicker.time = handles.img.files/handles.flicker.fps *+ t;
        end
        set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.flicker.time),'HH:MM:SS.FFF'));
        if ~get(handles.onlyStimulusRepWithBackground,'Value')
            handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
                * (handles.onlyStimulus.repetitions+1) + t;
        else
            handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
        end
            set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.onlyStimulus.time),'HH:MM:SS.FFF'));
        handles.whitenoise.time = handles.whitenoise.frames * 1/handles.whitenoise.fps + t;
        set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.whitenoise.time),'HH:MM:SS.FFF'));
    else
        set(handles.nFiles,'String',0);
        handles.img.files = 0;
    end
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns imgFinal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imgFinal


% --- Executes on button press in addExperiment.
function addExperiment_Callback(hObject, eventdata, handles)
% hObject    handle to addExperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if handles.img.files~=0 || strcmp(handles.mode,'White noise')
    handles.experiments.number = handles.experiments.number+1;
    handles.experiments.file = [handles.experiments.file handles.experiments.number];
    save(['Exp' sprintf('%03d',handles.experiments.number) '.si'],'-struct','handles');
    if strcmp(handles.mode,'Flicker')
        newExp = ['Fl - ' get(handles.nFiles,'String') ' file(s) - ' ...
            num2str(handles.flicker.fps,3) ' [Hz] - ' ...
             num2str(handles.flicker.dutyCicle) '% dutyCicle - ' ...
             num2str(handles.flicker.time,4) ' [s]' ];
         if get(handles.flickerRepWithBackground,'Value') && length(handles.experiments.file)>1
            inf = getInformation(['Exp' sprintf('%03d',handles.experiments.file(end-1)) '.si']);
            if strcmp(inf.mode,'Presentation')
                handles.time = handles.time + (inf.presentation.time/1000)*handles.flicker.repetitions +...
                    handles.flicker.time*(handles.flicker.repetitions+1);
            end
         else
            handles.time = handles.time + handles.flicker.time;
         end
    elseif strcmp(handles.mode,'Only stimulus (fps)')
        newExp = ['OS - ' get(handles.nFiles,'String') ' file(s) - ' ...
            num2str(handles.onlyStimulus.fps,3) ' [fps] - '];
             newExp = [newExp num2str(handles.onlyStimulus.time,4) ' [s]' ];
         if get(handles.onlyStimulusRepWithBackground,'Value') && length(handles.experiments.file)>1
            inf = getInformation(['Exp' sprintf('%03d',handles.experiments.file(end-1)) '.si']);
            if strcmp(inf.mode,'Presentation')
                handles.time = handles.time + (inf.presentation.time/1000)*handles.onlyStimulus.repetitions +...
                    handles.onlyStimulus.time*(handles.onlyStimulus.repetitions+1);
            end
         else
            handles.time = handles.time + handles.onlyStimulus.time;
         end
    else
        newExp = ['WN - ' num2str(handles.whitenoise.frames) ' frame(s) - ' ...
            num2str(handles.whitenoise.fps,3) ' [fps] - '];
        newExp = [newExp num2str(handles.whitenoise.time,4) ' [s]' ];
        handles.time = handles.time + handles.whitenoise.time;
    end
    handles.experiments.list = char(handles.experiments.list, newExp);
    handles.img.totalFiles = handles.img.totalFiles + handles.img.files;
    set(handles.experimentList,'String',handles.experiments.list);
    handles.experiments.selected = size(handles.experiments.list,1);
    set(handles.experimentList,'Value',handles.experiments.selected);
    set(handles.totalTime,'String',datestr(datenum(0,0,0,0,0,handles.time),...
        'HH:MM:SS.FFF'));
    guidata(hObject,handles);
else
    errordlg('You are trying to add an imageless experiment','Error');
end

% --- Executes during object creation, after setting all properties.
function experimentList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to handles.experimentList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onlyStimulusImageRepeatition_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusImageRepeatition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.onlyStimulus.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.onlyStimulus.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
    else
        handles.onlyStimulus.repetitions = in;
        if handles.beforeStimulus.is
            t = handles.beforeStimulus.time/1000.0;
        else
            t = 0;
        end
        if ~get(handles.onlyStimulusRepWithBackground,'Value')
            handles.onlyStimulus.time = t + handles.img.files...
                * 1/handles.onlyStimulus.fps * (handles.onlyStimulus.repetitions+1);
            set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.onlyStimulus.time),'HH:MM:SS.FFF'));
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of onlyStimulusImageRepeatition as text
%        str2double(get(hObject,'String')) returns contents of onlyStimulusImageRepeatition as a double


% --- Executes during object creation, after setting all properties.
function onlyStimulusImageRepeatition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onlyStimulusImageRepeatition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function flickerImageRepetition_Callback(hObject, eventdata, handles)
% hObject    handle to flickerImageRepetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.flicker.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
    else
        handles.flicker.repetitions = in;
        if handles.beforeStimulus.is
            t = handles.beforeStimulus.time/1000.0;
        else
            t = 0;
        end
        if ~get(handles.flickerRepWithBackground,'Value'),
            handles.flicker.time = t + handles.img.files...
                * 1/handles.flicker.fps * (handles.flicker.repetitions+1);
            set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.flicker.time),'HH:MM:SS.FFF'));
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerImageRepetition as text
%        str2double(get(hObject,'String')) returns contents of flickerImageRepetition as a double


% --- Executes during object creation, after setting all properties.
function flickerImageRepetition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerImageRepetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pos=searchFirstFile(directory)
list = dir(directory);
pos = 0;
for i=1:length(list),
    if ~list(i).isdir && supportedImageFormat(list(i).name), 
        pos = i;
        break
    end
end
if pos,
    pos = pos-1;
end

function pos=searchLastFile(directory)
list = dir(directory);
pos = 0;
for i=length(list):-1:1,
    if ~list(i).isdir && supportedImageFormat(list(i).name), 
        pos = i;
        break
    end
end
if pos,
    pos = pos-1;
end

function out=supportedImageFormat(file)
points = find(file=='.');
ext = file(points(end):end);
out = false;
if ~isempty(regexpi(ext,'bmp')) || ~isempty(regexpi(ext,'gif')) || ...
    ~isempty(regexpi(ext,'hdf')) || ~isempty(regexpi(ext,'jpeg')) || ...
    ~isempty(regexpi(ext,'jpg')) || ~isempty(regexpi(ext,'jp2')) || ...
    ~isempty(regexpi(ext,'jpf')) || ~isempty(regexpi(ext,'jpx')) || ...
    ~isempty(regexpi(ext,'j2c')) || ~isempty(regexpi(ext,'j2k')) || ...
    ~isempty(regexpi(ext,'pbm')) || ~isempty(regexpi(ext,'pcx')) || ...
    ~isempty(regexpi(ext,'pgm')) || ~isempty(regexpi(ext,'png')) || ...
    ~isempty(regexpi(ext,'pnm')) || ~isempty(regexpi(ext,'ppm')) || ...
    ~isempty(regexpi(ext,'ras')) || ~isempty(regexpi(ext,'tiff')) || ...
    ~isempty(regexpi(ext,'xwd')) || ~isempty(regexpi(ext,'cur')) || ...
    ~isempty(regexpi(ext,'fits')) || ~isempty(regexpi(ext,'ico')),
    out = true;
end


% --- Executes on selection change in handles.experimentList.
function experimentList_Callback(hObject, eventdata, handles)
% hObject    handle to handles.experimentList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'Value');
if in == handles.experiments.selected && in ~=1 ,
    inputH = ['Exp' sprintf('%03d',handles.experiments.file(in)) '.si'];
    expInformation = getInformation(inputH,'print');
    h = getInformation(inputH);
    title = ['Experiment ' num2str(in-1) ' information (' inputH ')'];
    q = questdlg(expInformation,title,'Ok','Delete','Ok');
    if ~isempty(q) && strcmp(q,'Delete'),
        delete(['Exp' sprintf('%03d',handles.experiments.file(in)) '.si']);
        if in==size(handles.experiments.list,1),
            handles.experiments.list = handles.experiments.list(1:in-1,:);
            handles.experiments.file = handles.experiments.file(1:in-1);
        else
            handles.experiments.list = char(handles.experiments.list(1:in-1,:),handles.experiments.list(in+1:end,:));
            handles.experiments.file = [handles.experiments.file(1:in-1)...
                 handles.experiments.file(in+1:end)];
        end
        set(hObject,'String',handles.experiments.list);
        set(hObject,'Value',in-1);
        handles.experiments.selected = in-1;
        switch h.mode 
            case 'Flicker'
                handles.time = handles.time - h.flicker.time;
                handles.img.totalFiles = handles.img.totalFiles - handles.img.files;
            case 'Only stimulus (fps)'
                handles.time = handles.time - h.onlyStimulus.time;
                handles.img.totalFiles = handles.img.totalFiles - handles.img.files;
            case 'White noise'
                handles.time = handles.time - h.whitenoise.time;
            otherwise
                handles.time = handles.time - h.presentation.time/1000.0;
        end
        set(handles.totalTime,'String',datestr(datenum(0,0,0,0,0,handles.time),...
            'HH:MM:SS.FFF'));
    end
else
    handles.experiments.selected = in;
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns handles.experimentList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from handles.experimentList


% --- Executes on button press in downExp.
function downExp_Callback(hObject, eventdata, handles)
% hObject    handle to downExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
pos = get(handles.experimentList,'Value');
if pos~=size(handles.experiments.list,1) && pos~=1
    tmp = handles.experiments.list(pos,:);
    handles.experiments.list(pos,:) = handles.experiments.list(pos+1,:);
    handles.experiments.list(pos+1,:) = tmp;
    set(handles.experimentList,'String',handles.experiments.list);
    set(handles.experimentList,'Value',pos+1);
    handles.experiments.selected = pos+1;
    tmp = handles.experiments.file(pos);
    handles.experiments.file(pos) = handles.experiments.file(pos+1);
    handles.experiments.file(pos+1) = tmp;
end
guidata(hObject,handles);

% --- Executes on button press in upExp.
function upExp_Callback(hObject, eventdata, handles)
% hObject    handle to upExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
pos = get(handles.experimentList,'Value');
if pos>2
    tmp = handles.experiments.list(pos,:);
    handles.experiments.list(pos,:) = handles.experiments.list(pos-1,:);
    handles.experiments.list(pos-1,:) = tmp;
    set(handles.experimentList,'String',handles.experiments.list);
    set(handles.experimentList,'Value',pos-1);
    handles.experiments.selected = pos-1;
    tmp = handles.experiments.file(pos);
    handles.experiments.file(pos) = handles.experiments.file(pos-1);
    handles.experiments.file(pos-1) = tmp;
end
guidata(hObject,handles);


% --- Executes on button press in addPresentation.
function addPresentation_Callback(hObject, eventdata, handles)
% hObject    handle to addPresentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if handles.presentation.time ~= 0
    handles.experiments.number = handles.experiments.number+1;
    handles.experiments.file = [handles.experiments.file handles.experiments.number];
    tmp = handles.mode;
    handles.mode = 'Presentation';
    save(['Exp' sprintf('%03d',handles.experiments.number) '.si'],'-struct','handles');
    newExp = ['Background R:' num2str(handles.presentation.r) ' G:'...
         num2str(handles.presentation.g) ' B:' ...
         num2str(handles.presentation.b) ' ' ...
         num2str(handles.presentation.time/1000.0) ' [s]'];
    handles.time = handles.time + handles.presentation.time/1000.0;
    handles.experiments.list = char(handles.experiments.list,newExp);
    set(handles.experimentList,'String',handles.experiments.list);
    handles.experiments.selected = size(handles.experiments.list,1);
    set(handles.experimentList,'Value',handles.experiments.selected);
    set(handles.totalTime,'String',datestr(datenum(0,0,0,0,0,handles.time),...
        'HH:MM:SS.FFF'));
    handles.mode = tmp;
    guidata(hObject,handles);
else
    errordlg('You are trying to add a timeless background','Error');
end


function presentationTime_Callback(hObject, eventdata, handles)
% hObject    handle to presentationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.presentation.time);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.presentation.time);
  errordlg('Input must be a number and non negative', 'Error')
    else
        if in==0
            warndlg('There''s no sense to set this time to 0','Warning');
        end
        handles.presentation.time = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationTime as text
%        str2double(get(hObject,'String')) returns contents of presentationTime as a double


% --- Executes during object creation, after setting all properties.
function presentationTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function figure1_CloseRequestFcn(hObject,eventdata,hanles)
selection = questdlg(['Are you sure you want to close the ' ...
    'Sampling Interface?'],'Exit','Yes','No','Yes'); 
if isempty(selection)
    return
end
switch selection, 
  case 'Yes',
     delete *.si;
     delete *.dsi;
     Screen('Preference', 'SkipSyncTests', 0);
     Screen('Preference', 'VisualDebugLevel', 4);
     delete(gcf);
    otherwise
     return 
end



function bottomBarDivision_Callback(hObject, eventdata, handles)
% hObject    handle to bottomBarDivision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.bottomBar.division);
  errordlg('Input must be a natural number', 'Error')
else if in<=0 || mod(in,1)~=0,
  set(hObject,'String',handles.bottomBar.division);
  errordlg('Input must be a natural number', 'Error')
    else
        handles.bottomBar.division = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of bottomBarDivision as text
%        str2double(get(hObject,'String')) returns contents of bottomBarDivision as a double


% --- Executes during object creation, after setting all properties.
function bottomBarDivision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bottomBarDivision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in searchScreen.
function searchScreen_Callback(hObject, eventdata, handles)
% hObject    handle to searchScreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
handles.screens.list = Screen('Screens')';
handles.screens.selected = handles.screens.list(1);
set(handles.selectScreen,'String',handles.screens.list);
set(handles.selectScreen,'Value',handles.screens.selected+1);
guidata(hObject,handles);

% --- Executes on selection change in selectScreen.
function selectScreen_Callback(hObject, eventdata, handles)
% hObject    handle to selectScreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(handles.selectScreen,'Value');
if (handles.screens.selected+1)~=in
    q = questdlg(['If you change the selected screen, the experiment list '...
        'will be erased to ensure the refresh rate concordance. Are you '...
        'shure about the change?'],'Screen selection','Yes','No','Yes');
    if ~isempty(q) && strcmp(q,'Yes')
        handles.screens.selected = get(handles.selectScreen,'Value')-1;
        oldSkip = Screen('Preference', 'SkipSyncTests', 0);
        oldLevel = Screen('Preference', 'VisualDebugLevel', 4);
        [handles.screens.refreshRate,handles.screens.height,handles.screens.width] = ...
            identifyScreen(handles.screens.selected);
        set(handles.screenHeight,'String',handles.screens.height);
        set(handles.screenWidth,'String',handles.screens.width);
        set(handles.screenRefreshRateHz,'String',1.0/handles.screens.refreshRate);
        set(handles.screenRefreshRateMs,'String',handles.screens.refreshRate);
        Screen('Preference', 'SkipSyncTests',oldSkip);
        Screen('Preference', 'VisualDebugLevel', oldLevel);
        delete *.si;
        inputHandles = getInformation('Default Configuration.dsi');
        handles.experiments = inputHandles.experiments;
        handles.flicker.fps = 1.0/(2.0*handles.screens.refreshRate);
        handles.onlyStimulus.fps = 1.0/(2.0*handles.screens.refreshRate);
        handles.flicker.dutyCicle = 50;
        setAll(handles);
    end
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns selectScreen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectScreen


% --- Executes during object creation, after setting all properties.
function selectScreen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectScreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in selectAll.
function selectAll_Callback(hObject, eventdata, handles)
% hObject    handle to selectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify || handles.img.nInitialPos == 1
    return
end
pos = searchFirstFile(handles.img.directory);
set(handles.imgInitial,'Value',pos);
handles.img.nInitial = handles.list(pos,:);
handles.img.nInitialPos = pos;
pos = searchLastFile(handles.img.directory);
set(handles.imgFinal,'Value',pos);
handles.img.nFinal = handles.list(pos,:);
handles.img.nFinalPos = pos;
difference=find((handles.img.nInitial==handles.img.nFinal)==0);
if ~isempty(difference),
    nExt = find(handles.img.nInitial=='.');
    ext = handles.img.nInitial(nExt:end);
    name = handles.img.nInitial(1:difference(1)-1);
    nInit = str2double(handles.img.nInitial(difference(1):nExt(end)-1));
    nFinal = str2double(handles.img.nFinal(difference(1):nExt(end)-1));
%    files = 0;
%     ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
%     for i=nInit:nFinal,
%         num = sprintf(ns,i);
%         if exist(fullfile(handles.img.directory,strcat(name,num,ext)),'file'),
%             files = files + 1;
%         end
%     end
    files = nFinal - nInit + 1;
    set(handles.nFiles,'String',files);
    handles.img.files = files;
    if handles.beforeStimulus.is
        t = handles.beforeStimulus.time/1000.0;
    else
        t = 0;
    end
    if ~get(handles.flickerRepWithBackground,'Value')
        handles.flicker.time = handles.img.files/handles.flicker.fps *...
            (handles.flicker.repetitions+1) + t;
    else
        handles.flicker.time = handles.img.files/handles.flicker.fps *+ t;
    end
    set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
        handles.flicker.time),'HH:MM:SS.FFF'));
    if ~get(handles.onlyStimulusRepWithBackground,'Value')
        handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
            * (handles.onlyStimulus.repetitions+1) + t;
    else
        handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
    end
        set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.onlyStimulus.time),'HH:MM:SS.FFF'));
    handles.whitenoise.time = handles.whitenoise.frames * 1/handles.whitenoise.fps + t;
    set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
        handles.whitenoise.time),'HH:MM:SS.FFF'));
else
    set(handles.nFiles,'String',1);
    handles.img.files = 1;
end
guidata(hObject,handles);


% --- Executes on button press in onlyStimulusNextFps.
function onlyStimulusNextFps_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusNextFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.onlyStimulus.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.onlyStimulusNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.onlyStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.onlyStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);
if handles.beforeStimulus.is
    t = handles.beforeStimulus.time/1000.0;
else
    t = 0;
end
if ~get(handles.onlyStimulusRepWithBackground,'Value')
    handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
        * (handles.onlyStimulus.repetitions+1) + t;
else
    handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
end
set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.onlyStimulus.time),'HH:MM:SS.FFF'));
guidata(hObject,handles);

% --- Executes on button press in onlyStimulusPreviousFps.
function onlyStimulusPreviousFps_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusPreviousFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.onlyStimulus.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.onlyStimulusNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.onlyStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.onlyStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);
if handles.beforeStimulus.is
    t = handles.beforeStimulus.time/1000.0;
else
    t = 0;
end
if ~get(handles.onlyStimulusRepWithBackground,'Value')
    handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
        * (handles.onlyStimulus.repetitions+1) + t;
else
    handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
end
    set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
        handles.onlyStimulus.time),'HH:MM:SS.FFF'));
guidata(hObject,handles);

% --- Executes on button press in flickerNextFrequency.
function flickerNextFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to flickerNextFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.flickerNextFrequency,'String',1.0/handles.screens.refreshRate);
else
    set(handles.flickerNextFrequency,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.flickerPreviousFrequency,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.flickerFrequency,'String',fps);
previousSteps = get(handles.flickerDcSlider,'SliderStep');
dc = str2double(get(handles.flickerDc,'String'));
steps = fps*handles.screens.refreshRate;
set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
if dc ~= 0 && dc ~= 100
    actualPos = dc/(100*previousSteps(1));
    if mod(round(1.0/steps),2) ~= 0
        dc = steps*actualPos*100;
    else
        dc = steps*(actualPos-1)*100;
    end
    set(handles.flickerDcSlider, 'Value', dc);
    set(handles.flickerDc, 'String', dc);
end
if get(handles.flickerFreqConf,'Value'),
    handles.flicker.fps = fps;
    handles.flicker.dutyCicle = dc;
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);

% --- Executes on button press in flickerPreviousFrequency.
function flickerPreviousFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to flickerPreviousFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
fps = 1.0/(in*handles.screens.refreshRate);
set(handles.flickerFrequency,'String',fps);
if in == 1
    set(handles.flickerNextFrequency,'String',1.0/handles.screens.refreshRate);
else
    set(handles.flickerNextFrequency,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.flickerPreviousFrequency,'String',1.0/((in+1)*handles.screens.refreshRate));
previousSteps = get(handles.flickerDcSlider,'SliderStep');
steps = fps*handles.screens.refreshRate;
set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
dc = str2double(get(handles.flickerDc,'String'));
if dc ~= 0 && dc ~= 100
    actualPos = dc/(100*previousSteps(1));
        if mod(round(1.0/steps),2) ~= 0 % To odd
            dc = steps*(actualPos+1)*100;
        else
            dc = steps*actualPos*100;
        end
    set(handles.flickerDcSlider, 'Value', dc);
    set(handles.flickerDc, 'String', dc);
end
if get(handles.flickerFreqConf,'Value'),
    handles.flicker.fps = fps;
    handles.flicker.dutyCicle = dc;
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);


% --- Executes on slider movement.
function flickerDcSlider_Callback(hObject, eventdata, handles)
% hObject    handle to flickerDcSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if ~handles.modify
    return
end
in = get(hObject,'Value');
if in~=0 && in ~=100
    step = get(hObject,'SliderStep');
    in = 100*step(1)*round(in/(100*step(1)));
end
dc = in;
set(handles.flickerDc,'String',dc);
set(hObject,'Value',dc);
if get(handles.flickerFreqConf,'Value'),
    handles.flicker.dutyCicle = dc;
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function flickerDcSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerDcSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', 0);
set(hObject, 'Max', 100);
guidata(hObject,handles);



function flickerDc_Callback(hObject, eventdata, handles)
% hObject    handle to flickerDc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flickerDc as text
%        str2double(get(hObject,'String')) returns contents of flickerDc as a double
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>100 || in<0)
  set(hObject,'String',handles.flicker.dutyCicle);
  errordlg('Input must be a number between 0 and 100', 'Error')
else
    if in~=0 && in ~=100
        step = get(handles.flickerDcSlider,'SliderStep');
        in = 100*step(1)*round(in/(100*step(1)));
    end
    handles.flicker.dutyCicle = in;
    set(hObject,'String',handles.flicker.dutyCicle);
    set(handles.flickerDcSlider,'Value',handles.flicker.dutyCicle);
    axes(handles.flickerSignalGraph);
    periode = 1000.0/handles.flicker.fps;
    t = 0:periode/100.0:periode;
    signal = t < handles.flicker.dutyCicle*t(end)/100.0; 
    area(t,signal); hold on;
    plot(t(round(handles.flicker.dutyCicle)+1),1,'ks','MarkerFaceColor',[0 1 0],'MarkerSize',3);
    if handles.flicker.dutyCicle>50
        text(t(round(handles.flicker.dutyCicle)+1)-1.85*periode/10.0,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
    else
        text(t(round(handles.flicker.dutyCicle)+1)+1,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
    end
    ylabel('Signal'),xlabel('Time [ms]'),xlim([0 t(end)]),ylim([0 1.5]); hold off;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function flickerDc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerDc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flickerUseImg.
function flickerUseImg_Callback(hObject, eventdata, handles)
% hObject    handle to flickerUseImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if get(hObject,'Value')==1.0
    handles.flicker.img.is = true;
    if ~supportedImageFormat(handles.flicker.img.name)
        imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
            ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
            ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
            ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
        [fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
        if fileName == 0
            set(hObject,'Value',0.0);
            handles.flicker.img.is = false;
        else
            handles.flicker.img.name = fullfile(fileDirection,fileName);
            set(handles.flickerImgDirection,'String',handles.flicker.img.name);
        end
    end
else
    handles.flicker.img.is = false;
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of flickerUseImg



function flickerImgDirection_Callback(hObject, eventdata, handles)
% hObject    handle to flickerImgDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if exist(in,'file') && supportedImageFormat(in)
    handles.flicker.img.name = in;
else
    errordlg('The direction inserted is not a valid image file');
end
set(handles.flickerImgDirection,'String',handles.flicker.img.name);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerImgDirection as text
%        str2double(get(hObject,'String')) returns contents of flickerImgDirection as a double


% --- Executes during object creation, after setting all properties.
function flickerImgDirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerImgDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flickerSelectImg.
function flickerSelectImg_Callback(hObject, eventdata, handles)
% hObject    handle to flickerSelectImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
    ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
    ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
    ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
[fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
if fileName ~= 0
    handles.flicker.img.name = fullfile(fileDirection,fileName);
    set(handles.flickerImgDirection,'String',handles.flicker.img.name);
end
guidata(hObject,handles);


function stimulusBottomBarLevelR_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
set(hObject,'String',handles.bottomBar.baseR);
errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.bottomBar.baseR = in;
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarLevelR as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarLevelR as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarLevelR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarLevelG_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
set(hObject,'String',handles.bottomBar.baseG);
errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.bottomBar.baseG = in;
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarLevelG as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarLevelG as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarLevelG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarLevelB_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
set(hObject,'String',handles.bottomBar.baseB);
errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.bottomBar.baseB = in;
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarLevelB as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarLevelB as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarLevelB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backgroundColor.
function backgroundColor_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
if handles.img.background.isImg,
    set(hObject,'Value',1.0);
    set(handles.backgroundImg,'Value',0.0);
    handles.img.background.isImg = false;
else
    set(hObject,'Value',1.0);
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of backgroundColor


% --- Executes on button press in backgroundImg.
function backgroundImg_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if ~handles.img.background.isImg,
    set(hObject,'Value',1.0);
    set(handles.backgroundColor,'Value',0.0);
    handles.img.background.isImg = true;
    if ~supportedImageFormat(handles.img.background.imgName)
        imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
            ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
            ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
            ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
        [fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
        if fileName == 0
            set(hObject,'Value',0.0);
            set(handles.backgroundColor,'Value',1.0);
            handles.img.background.isImg = false;
        else
            handles.img.background.imgName = fullfile(fileDirection,fileName);
            set(handles.backgroundImgDirection,'String',handles.img.background.imgName);
        end
    end
else
    set(hObject,'Value',1.0);
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of backgroundImg



function backgroundR_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
  set(hObject,'String',handles.img.background.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.img.background.r = in;
    handles.img.background.graph(:,:,1) = in/255.0;
    axes(handles.imgBackgroundGraph);
    imshow(handles.img.background.graph);
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of backgroundR as text
%        str2double(get(hObject,'String')) returns contents of backgroundR as a double


% --- Executes during object creation, after setting all properties.
function backgroundR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backgroundR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backgroundG_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
  set(hObject,'String',handles.img.background.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.img.background.g = in;
    handles.img.background.graph(:,:,2) = in/255.0;
    axes(handles.imgBackgroundGraph);
    imshow(handles.img.background.graph);
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of backgroundG as text
%        str2double(get(hObject,'String')) returns contents of backgroundG as a double


% --- Executes during object creation, after setting all properties.
function backgroundG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backgroundG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backgroundB_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
  set(hObject,'String',handles.img.background.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.img.background.b = in;
    handles.img.background.graph(:,:,3) = in/255.0;
    axes(handles.imgBackgroundGraph);
    imshow(handles.img.background.graph);
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of backgroundB as text
%        str2double(get(hObject,'String')) returns contents of backgroundB as a double


% --- Executes during object creation, after setting all properties.
function backgroundB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backgroundB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backgroundImgDirection_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundImgDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if exist(in,'file') && supportedImageFormat(in)
    handles.img.background.imgName = in;
else
    errordlg('The direction inserted is not a valid image file');
end
set(handles.backgroundImgDirection,'String',handles.img.background.imgName);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of backgroundImgDirection as text
%        str2double(get(hObject,'String')) returns contents of backgroundImgDirection as a double


% --- Executes during object creation, after setting all properties.
function backgroundImgDirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backgroundImgDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backgroundImgSelect.
function backgroundImgSelect_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundImgSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
    ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
    ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
    ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
[fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
if fileName ~= 0
    handles.img.background.imgName = fullfile(fileDirection,fileName);
    set(handles.backgroundImgDirection,'String',handles.img.background.imgName);
end
guidata(hObject,handles);


% --- Executes on button press in flickerTimeConf.
function flickerTimeConf_Callback(hObject, eventdata, handles)
% hObject    handle to flickerTimeConf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if (get(hObject,'Value')==0)
    set(hObject,'Value',1.0);
else
    set(handles.flickerFreqConf,'value',0);
    handles.flicker.fps = 1000/(handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of flickerTimeConf



function flickerImgTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.imgTime);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.flicker.imgTime);
  errordlg('Input must be a number and non negative', 'Error')
    else
        if str2double(get(handles.flickerBackgroundTime,'String'))==0 && in == 0,
            errordlg('Both, background time and image time can''t be equal to zero simultaneously','Error');
            set(hObject,'String',handles.flicker.imgTime);
            return
        end
        in = round(in/(1000*handles.screens.refreshRate));
        if in == 0 && (handles.flicker.backgroundTime ~= 0 || in ~= 1)
        set(handles.flickerPreviousImgTime,'String',0);
        else
            set(handles.flickerPreviousImgTime,'String',1000*(in-1)*handles.screens.refreshRate);
        end
        set(handles.flickerNextImgTime,'String',1000*(in+1)*handles.screens.refreshRate);
        in = in * handles.screens.refreshRate;
        handles.flicker.imgTime = 1000*in;
        set(hObject,'String',handles.flicker.imgTime);
        if get(handles.flickerTimeConf,'Value'),
            handles.flicker.fps = 1 / (in + str2double(get(handles.flickerBackgroundTime,'String'))/1000);
            handles.flicker.dutyCicle = 100 * handles.flicker.fps * in;
            handles.flicker.time = actualizeTemporalGraph(handles);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerImgTime as text
%        str2double(get(hObject,'String')) returns contents of flickerImgTime as a double


% --- Executes during object creation, after setting all properties.
function flickerImgTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flickerBackgroundTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerBackgroundTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.fps);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.flicker.fps);
  errordlg('Input must be a number and non negative', 'Error')
    else
        if str2double(get(handles.flickerImgTime,'String'))==0 && in == 0,
            errordlg('Both, background time and image time can''t be equal to zero simultaneously','Error');
            set(hObject,'String',handles.flicker.backgroundTime);
            return
        end
        in = round(in/(1000*handles.screens.refreshRate));
        if in == 0 && (handles.flicker.imgTime ~= 0 || in ~= 1)
            set(handles.flickerPreviousBgndTime,'String',0);
        else
            set(handles.flickerPreviousBgndTime,'String',1000*(in-1)*handles.screens.refreshRate);
        end
        set(handles.flickerNextBgndTime,'String',1000*(in+1)*handles.screens.refreshRate);
        in = in*handles.screens.refreshRate;
        handles.flicker.backgroundTime = 1000*in;
        set(hObject,'String',handles.flicker.backgroundTime);
        if get(handles.flickerTimeConf,'Value'),
            handles.flicker.fps = 1 / (in + str2double(get(handles.flickerImgTime,'String'))/1000);
            handles.flicker.dutyCicle = 100 * (1 - handles.flicker.fps * in);
            handles.flicker.time = actualizeTemporalGraph(handles);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerBackgroundTime as text
%        str2double(get(hObject,'String')) returns contents of flickerBackgroundTime as a double


% --- Executes during object creation, after setting all properties.
function flickerBackgroundTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerBackgroundTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flickerFreqConf.
function flickerFreqConf_Callback(hObject, eventdata, handles)
% hObject    handle to flickerFreqConf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if (get(hObject,'Value')==0)
    set(hObject,'Value',1.0);
else
    set(handles.flickerTimeConf,'value',0);
    handles.flicker.fps = str2double(get(handles.flickerFrequency,'String'));
    handles.flicker.dutyCicle = str2double(get(handles.flickerDc,'String'));
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of flickerFreqConf

function [time]=actualizeTemporalGraph(handles)
if handles.beforeStimulus.is
    t = handles.beforeStimulus.time/1000.0;
else
    t = 0;
end
if ~get(handles.flickerRepWithBackground,'Value'),
    time = t + handles.img.files...
        * 1/handles.flicker.fps * (handles.flicker.repetitions+1);
else
    time = t + handles.img.files* 1/handles.flicker.fps;
end
set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
    time),'HH:MM:SS.FFF'));
axes(handles.flickerSignalGraph);
periode = 1000.0/handles.flicker.fps;
t = 0:periode/100.0:periode;
signal = t < handles.flicker.dutyCicle*t(end)/100.0; 
area(t,signal); hold on;
plot(t(round(handles.flicker.dutyCicle)+1),1,'ks','MarkerFaceColor',[0 1 0],'MarkerSize',3);
if handles.flicker.dutyCicle>50
    text(t(round(handles.flicker.dutyCicle)+1)-6-1.85*periode/10.0,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',10.0);
else
    text(t(round(handles.flicker.dutyCicle)+1)+1,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',10.0);
end
ylabel('Signal'),xlabel('Time [ms]'),xlim([0 t(end)]),ylim([0 1.5]); hold off;


% --- Executes on button press in flickerPreviousImgTime.
function flickerPreviousImgTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerPreviousImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.flicker.imgTime = rr*round(in/rr);
if handles.flicker.imgTime ~= 0 && ...
        (handles.flicker.backgroundTime ~= 0 || handles.flicker.imgTime ~= rr)
    set(handles.flickerPreviousImgTime,'String',rr*(round(handles.flicker.imgTime/rr)-1));
end
set(handles.flickerNextImgTime,'String',rr*(round(handles.flicker.imgTime/rr)+1));
set(handles.flickerImgTime,'String',handles.flicker.imgTime);
if(get(handles.flickerTimeConf,'Value'))
    handles.flicker.fps = 1000 / (handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);


% --- Executes on button press in flickerNextImgTime.
function flickerNextImgTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerNextImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.flicker.imgTime = rr*round(in/rr);
set(handles.flickerPreviousImgTime,'String',rr*(round(handles.flicker.imgTime/rr)-1));
set(handles.flickerNextImgTime,'String',rr*(round(handles.flicker.imgTime/rr)+1));
set(handles.flickerImgTime,'String',handles.flicker.imgTime);
if(get(handles.flickerTimeConf,'Value'))
    handles.flicker.fps = 1000 / (handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);

% --- Executes on button press in flickerPreviousBgndTime.
function flickerPreviousBgndTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerPreviousBgndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.flicker.backgroundTime = rr*round(in/rr);
if handles.flicker.backgroundTime ~= 0 && ...
        (handles.flicker.imgTime ~= 0 || handles.flicker.backgroundTime ~= rr)
    set(handles.flickerPreviousBgndTime,'String',rr*(round(handles.flicker.backgroundTime/rr)-1));
end
set(handles.flickerNextBgndTime,'String',rr*(round(handles.flicker.backgroundTime/rr)+1));
set(handles.flickerBackgroundTime,'String',handles.flicker.backgroundTime);
if(get(handles.flickerTimeConf,'Value'))
    handles.flicker.fps = 1000 / (handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);


% --- Executes on button press in flickerNextBgndTime.
function flickerNextBgndTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerNextBgndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.flicker.backgroundTime = rr*round(in/rr);
set(handles.flickerPreviousBgndTime,'String',rr*(round(handles.flicker.backgroundTime/rr)-1));
set(handles.flickerNextBgndTime,'String',rr*(round(handles.flicker.backgroundTime/rr)+1));
set(handles.flickerBackgroundTime,'String',handles.flicker.backgroundTime);
if(get(handles.flickerTimeConf,'Value'))
    handles.flicker.fps = 1000 / (handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
    handles.flicker.time = actualizeTemporalGraph(handles);
end
guidata(hObject,handles);


% --- Executes on button press in imgSetPos.
function imgSetPos_Callback(hObject, eventdata, handles)
% hObject    handle to imgSetPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if strcmp(handles.mode,'White noise'),
    whiteNoisePreview_Callback(hObject, eventdata, handles);
else
    if ismac
        [handles.img.deltaX,handles.img.deltaY] = moveImage(handles.img.deltaX,handles.img.deltaY,...
            handles.screens.selected,imread(fullfile(handles.img.directory,handles.img.nInitial)));
    else
        [handles.img.deltaX,handles.img.deltaY] = moveImageWin(handles.img.deltaX,handles.img.deltaY,...
            handles.screens.selected,imread(fullfile(handles.img.directory,handles.img.nInitial)));
    end
set(handles.imgDeltaX,'String',handles.img.deltaX);
set(handles.imgDeltaY,'String',handles.img.deltaY);
guidata(hObject,handles);
end

function imgDeltaX_Callback(hObject, eventdata, handles)
% hObject    handle to imgDeltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if handles.screens.width<handles.img.size.width,
    errordlg('The stimulus can not be moved because the screen width is grater than the stimulus width.');
    set(hObject,'String',handles.img.deltaX);
    return    
end
if isnan(in)
  set(hObject,'String',handles.img.deltaX);
  errordlg(['Input must be a number between with magnitude lower than the '...
      'half of the screen width less the half of the stimulus size ( -' ...
      num2str((handles.screens.width-handles.img.size.width)/2) ' < deltaX < ' ...
      num2str((handles.screens.width-handles.img.size.width)/2) ' ).'], 'Error');
else if abs(in)>handles.screens.width/2,
  set(hObject,'String',handles.img.deltaX);
  errordlg(['Input must be a number between with magnitude lower than the '...
      'half of the screen width less the half of the stimulus size ( -' ...
      num2str((handles.screens.width-handles.img.size.width)/2) ' < deltaX < ' ...
      num2str((handles.screens.width-handles.img.size.width)/2) ' ).'], 'Error');
    else
        handles.img.deltaX = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of imgDeltaX as text
%        str2double(get(hObject,'String')) returns contents of imgDeltaX as a double


% --- Executes during object creation, after setting all properties.
function imgDeltaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgDeltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imgDeltaY_Callback(hObject, eventdata, handles)
% hObject    handle to imgDeltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if handles.screens.height<handles.img.size.height,
    errordlg('The stimulus can not be moved because the screen height is grater than the stimulus height.');
    set(hObject,'String',handles.img.deltaY);
    return
end
if isnan(in)
  set(hObject,'String',handles.img.deltaY);
  errordlg(['Input must be a number between with magnitude lower than the '...
      'half of the screen height less the half of the stimulus size ( -' ...
      num2str((handles.screens.height-handles.img.size.height)/2) ' < deltaY < ' ...
      num2str((handles.screens.height-handles.img.size.height)/2) ' ).'], 'Error');
else if abs(in)>handles.screens.height/2,
  set(hObject,'String',handles.img.deltaY);
  errordlg(['Input must be a number between with magnitude lower than the '...
      'half of the screen height less the half of the stimulus size ( -' ...
      num2str((handles.screens.height-handles.img.size.height)/2) ' < deltaY < ' ...
      num2str((handles.screens.height-handles.img.size.height)/2) ' ).'], 'Error');
    else
        handles.img.deltaY = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of imgDeltaY as text
%        str2double(get(hObject,'String')) returns contents of imgDeltaY as a double


% --- Executes during object creation, after setting all properties.
function imgDeltaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgDeltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoiseFps_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.fps);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.whitenoise.fps);
  errordlg('Input must be a number and non negative', 'Error')
    else
        in = ceil(1.0/(in*handles.screens.refreshRate));
        handles.whitenoise.fps = 1.0/(in*handles.screens.refreshRate);
        if in == 1
            set(handles.whitenoiseNextFps,'String',1.0/handles.screens.refreshRate);
        else
            set(handles.whitenoiseNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
        end
        set(handles.whitenoisePreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
        set(handles.whitenoiseFps,'String',handles.whitenoise.fps);
        if handles.beforeStimulus.is
            t = handles.beforeStimulus.time/1000.0;
        else
            t = 0;
        end
        handles.whitenoise.time = t + handles.whitenoise.frames...
            * 1/handles.whitenoise.fps;
        set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.whitenoise.time),'HH:MM:SS.FFF'));
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseFps as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseFps as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseFps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoiseBlocks_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseBlocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.blocks);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.whitenoise.blocks);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.whitenoise.blocks = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseBlocks as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseBlocks as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseBlocks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseBlocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in whiteNoiseNextFps.
function whiteNoiseNextFps_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseNextFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.whitenoise.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.whiteNoiseNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.whiteNoiseNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.whiteNoisePreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.whiteNoiseFps,'String',handles.whitenoise.fps);
handles.whitenoise.time = handles.whitenoise.frames...
    * 1/handles.whitenoise.fps;
set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.whitenoise.time),'HH:MM:SS.FFF'));
guidata(hObject,handles);

% --- Executes on button press in whiteNoisePreviousFps.
function whiteNoisePreviousFps_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoisePreviousFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.whitenoise.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.whiteNoiseNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.whiteNoiseNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.whiteNoisePreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.whiteNoiseFps,'String',handles.whitenoise.fps);
handles.whitenoise.time = handles.whitenoise.frames...
    * 1/handles.whitenoise.fps;
set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.whitenoise.time),'HH:MM:SS.FFF'));
guidata(hObject,handles);


function whiteNoisePxsX_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoisePxsX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.pxX);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.whitenoise.pxX);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.whitenoise.pxX = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoisePxsX as text
%        str2double(get(hObject,'String')) returns contents of whiteNoisePxsX as a double


% --- Executes during object creation, after setting all properties.
function whiteNoisePxsX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoisePxsX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoiseFrames_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.frames);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.whitenoise.frames);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.whitenoise.frames = in;
        handles.whitenoise.time = handles.whitenoise.frames...
            * 1/handles.whitenoise.fps;
        set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
            handles.whitenoise.time),'HH:MM:SS.FFF'));
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseFrames as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseFrames as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseFrames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in whiteNoisePreview.
function whiteNoisePreview_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoisePreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
noiseimg =  randi(2,handles.whitenoise.blocks,handles.whitenoise.blocks)-1;
noiseimg = Expand(noiseimg,handles.whitenoise.pxX,handles.whitenoise.pxY);
z = zeros(size(noiseimg));
switch handles.whitenoise.type,
    case 'BW', noiseimg = noiseimg*254;
    case 'BB', noiseimg = cat(3,z,z,noiseimg*254);
    case 'BG', noiseimg = cat(3,z,noiseimg*254,z);
    case 'BC', noiseimg = cat(3,z,noiseimg*254,noiseimg*254);
    case 'BBGC', noiseimg2 =  randi(2,handles.whitenoise.blocks,handles.whitenoise.blocks)-1;
                 noiseimg = cat(3,z,noiseimg*254,254*Expand(noiseimg2,handles.whitenoise.pxX,handles.whitenoise.pxY));
    case 'BY', noiseimg = cat(3,noiseimg*254,noiseimg*254,z);
    case 'BLG', noiseimg = cat(3,z,noiseimg*254,(~noiseimg)*254);
    otherwise, noiseimg = noiseimg*254;
end
size(noiseimg)
if ismac,
    [handles.img.deltaX,handles.img.deltaY] = moveImage(handles.img.deltaX,handles.img.deltaY,...
        handles.screens.selected,noiseimg);
else
    [handles.img.deltaX,handles.img.deltaY] = moveImageWin(handles.img.deltaX,handles.img.deltaY,...
        handles.screens.selected,noiseimg);
end
set(handles.imgDeltaX,'String',handles.img.deltaX);
set(handles.imgDeltaY,'String',handles.img.deltaY);
guidata(hObject,handles);


% --- Executes on button press in onlyStimulusRepWithBackground.
function onlyStimulusRepWithBackground_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusRepWithBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
handles.onlyStimulus.repeatBackground = get(hObject,'Value');
if handles.beforeStimulus.is
    t = handles.beforeStimulus.time/1000.0;
else
    t = 0;
end
if ~handles.onlyStimulus.repeatBackground,
    handles.onlyStimulus.time = t + handles.img.files...
        * 1/handles.onlyStimulus.fps * (handles.onlyStimulus.repetitions+1);
else
    handles.onlyStimulus.time = t + handles.img.files...
        * 1/handles.onlyStimulus.fps;
end
set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.onlyStimulus.time),'HH:MM:SS.FFF'));
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of onlyStimulusRepWithBackground


% --- Executes on button press in flickerRepWithBackground.
function flickerRepWithBackground_Callback(hObject, eventdata, handles)
% hObject    handle to flickerRepWithBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
handles.flicker.repeatBackground = get(hObject,'Value');
if handles.beforeStimulus.is
    t = handles.beforeStimulus.time/1000.0;
else
    t = 0;
end
if ~handles.flicker.repeatBackground
    handles.flicker.time = t + handles.img.files...
        * 1/handles.flicker.fps * (handles.flicker.repetitions+1);
else
    handles.flicker.time = t + handles.img.files * 1/handles.flicker.fps;
end
set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.flicker.time),'HH:MM:SS.FFF'));
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of flickerRepWithBackground



function whiteNoiseSaveImages_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseSaveImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.background.r);
  errordlg('Input must be a number between 0 and the number of frames', 'Error')
else if (in>handles.whitenoise.frames || in<0),
  set(hObject,'String',handles.beforeStimulus.background.r);
  errordlg('Input must be a number between 0 and the number of frames', 'Error')
    else
        handles.whitenoise.saveImages = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseSaveImages as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseSaveImages as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseSaveImages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseSaveImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createRandomSeed.
function createRandomSeed_Callback(hObject, eventdata, handles)
% hObject    handle to createRandomSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rng('shuffle');
s = rng;
uisave('s','seed.mat');

% --- Executes on button press in useSeed.
function useSeed_Callback(hObject, eventdata, handles)
% hObject    handle to useSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
value = get(hObject,'Value');
if value && ~isstruct(handles.whitenoise.possibleSeed),
    [s,n,f] = searchForSeed();
    if ~isstruct(s),
        set(hObject,'Value',0.0);
    else
        handles.whitenoise.seed = s;
        set(handles.seedFile,'String',fullfile(f,n));
    end
else
    if value
        handles.whitenoise.seed = handles.whitenoise.possibleSeed;
    end
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of useSeed



function seedFile_Callback(hObject, eventdata, handles)
% hObject    handle to seedFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if exist(in,'file') && ~isempty(strfind('.mat',in))
    s = load(in);
    if isstruct(s) && isfield(s,'s') && isfield(s.s,'Type') && isfield(s.s,'Seed') && isfield(s.s,'State')
        handles.whitenoise.possibleSeed = s.s;
        rng(s.s);
        if get(handles.useSeed,'Value')
            handles.whitenoise.seed = s.s;
        end
    else
        set(hObject,'String',handles.whitenoise.seedFile);
        errordlg('File has no seed in the correct format. File must have a struct named as ''s'', which should be the seed.','Error');
    end
else
    set(hObject,'String',handles.whitenoise.seedFile);
    errordlg('File has to be a .mat file with the extension in the name','Error');
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of seedFile as text
%        str2double(get(hObject,'String')) returns contents of seedFile as a double


% --- Executes during object creation, after setting all properties.
function seedFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seedFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in seedFileSelect.
function seedFileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to seedFileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
[s,n,f] = searchForSeed();
if isstruct(s)
    handles.whitenoise.possibleSeed = s;
    handles.whitenoise.seedFile = fullfile(f,n);
    set(handles.seedFile,'String',handles.whitenoise.seedFile);
    if get(handles.useSeed,'Value')
        handles.whitenoise.seed = s;
    end
end
guidata(hObject,handles);

function [seed,name,folder]=searchForSeed()
[name,folder] = uigetfile('.mat','Select seed file','seed.mat');
s = load(fullfile(folder,name));
if isstruct(s) && isfield(s,'s') && isfield(s.s,'Type') && isfield(s.s,'Seed') && isfield(s.s,'State')
    seed = s.s;
    rng(seed);
else
    seed = 0;
    errordlg('File has no seed in the correct format. File must have a struct named as ''s'', which should be the seed.','Error');
end


% --- Executes on selection change in noiseMenu.
function noiseMenu_Callback(hObject, eventdata, handles)
% hObject    handle to noiseMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
in = get(hObject,'Value');
switch in,
    case 1, handles.whitenoise.type = 'BW';
    case 2, handles.whitenoise.type = 'BB';
    case 3, handles.whitenoise.type = 'BG';
    case 4, handles.whitenoise.type = 'BC';
    case 5, handles.whitenoise.type = 'BBGC';
    case 6, handles.whitenoise.type = 'BY';
    case 7, handles.whitenoise.type = 'BLG';
    otherwise, handles.whitenoise.type = 'BW';
end
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns noiseMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noiseMenu


% --- Executes during object creation, after setting all properties.
function noiseMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoisePxsY_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoisePxsY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.pxY);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.whitenoise.pxY);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.whitenoise.pxY = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoisePxsY as text
%        str2double(get(hObject,'String')) returns contents of whiteNoisePxsY as a double


% --- Executes during object creation, after setting all properties.
function whiteNoisePxsY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoisePxsY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
