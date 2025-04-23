% **************************************************************************************
%                                 Spare-SIM GUI.
% **************************************************************************************
% This software package is It is an universal post-processing framework for 
% fluorescent (or intensity-based) image restoration, including 
% xy (2D), xy-t (2D along t axis), and xy-z (3D) images. 
% It is based on the natural priori knowledge of forward fluorescent 
% imaging model: sparsity and continuity along xy-t(z) axes. 
% **************************************************************************************
% Sparse deconvolution algorithm GUI v1.0.3
% **************************************************************************************
%% It is able to run under Windows 7-10, and should be modified for the Unix-like OS.
% **************************************************************************************
% argmin_g { ||f-b-g ||_2^2 +||gxx||_1+||gxx||_1+||gyy||_1+lamdbaz*||gzz||_1+2*||gxy||_1
%  +2*sqrt(lamdbaz)||gxz||_1+ 2*sqrt(lamdbaz)|||gyz||_1+2*sqrt(lamdbal1)|||g||_1}
% **************************************************************************************
% Written by WeisongZhao @ zhaoweisong950713@163.com
% if any bugs is found, please just email me or put an issue on the github.
% **************************************************************************************
% https://weisongzhao.github.io/Sparse-SIM/
% **************************************************************************************
% It is a part of publication:
% Weisong Zhao et al. Sparse deconvolution improves the resolution of live-cell
% super-resolution fluorescence microscopy , Nature Biotechnology, 40, 606–617 (2022).
% https://doi.org/10.1038/s41587-021-01092-2
% **************************************************************************************
%    Copyright 2018~2021 Weisong Zhao et al.
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the Open Data Commons Open Database License v1.0.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%    Open Data Commons Open Database License for more details.
%
%    You should have received a copy of the 
%    Open Data Commons Open Database License
%    along with this program.  If not, see:
%    <https://opendatacommons.org/licenses/odbl/>.
% **************************************************************************************

function varargout = Sparse_SIM_recon(varargin)
% SPARSE_SIM_RECON MATLAB code for Sparse_SIM_recon.fig
%      SPARSE_SIM_RECON, by itself, creates a new SPARSE_SIM_RECON or raises the existing
%      singleton*.
%
%      H = SPARSE_SIM_RECON returns the handle to a new SPARSE_SIM_RECON or the handle to
%      the existing singleton*.
%
%      SPARSE_SIM_RECON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPARSE_SIM_RECON.M with the given input arguments.
%
%      SPARSE_SIM_RECON('Property','Value',...) creates a new SPARSE_SIM_RECON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sparse_SIM_recon_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sparse_SIM_recon_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sparse_SIM_recon

% Last Modified by GUIDE v2.5 16-Dec-2019 19:40:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Sparse_SIM_recon_OpeningFcn, ...
    'gui_OutputFcn',  @Sparse_SIM_recon_OutputFcn, ...
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
%%
function saveState(handles)

global settingRECON;
fileName = './RUN/recentsetting_SHrecon.mat';

settingRECON.SHitertimes = get(handles.SHitertimes, 'string');
settingRECON.debltimes = get(handles.debltimes, 'string');

settingRECON.fidelity = get(handles.fidelity, 'string');
settingRECON.sparsity = get(handles.sparsity, 'string');
settingRECON.NA = get(handles.NA, 'string');
settingRECON.lambda = get(handles.lambda, 'string');
settingRECON.Pixel = get(handles.Pixel, 'string');
settingRECON.zconti = get(handles.zconti, 'string');

settingRECON.GPUON = get(handles.GPUON, 'Value');
settingRECON.deblurON = get(handles.deblurON, 'Value');

settingRECON.gaininput = get(handles.slider3,'Value' );
settingRECON.RawIMG = [];
settingRECON.RectIMG = [];

% version 0.3.0
settingRECON.ThreeD = get(handles.ThreeD,'Value' );
settingRECON.Background = get(handles.Background,'Value' );
settingRECON.Oversample = get(handles.Oversample,'Value' );
settingRECON.debug = get(handles.debug,'Value' );

if ~exist('./RUN','dir')==1
    save_file('./RUN');
end

save(fileName, 'settingRECON');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadState(handles)
global settingRECON;
settingRECON.RawIMG = zeros(10,10);
settingRECON.ReconIMG = zeros(10,10);
settingRECON.gain = 1;
fileName = './RUN/recentsetting_SHrecon.mat';

if exist(fileName)
    
    load(fileName);
    set(handles.SHitertimes, 'string', settingRECON.SHitertimes);
    set(handles.debltimes, 'string', settingRECON.debltimes);
    
    set(handles.GPUON,'Value',settingRECON.GPUON);
    set(handles.deblurON,'Value',settingRECON.deblurON);
    
    set(handles.fidelity, 'string', settingRECON.fidelity);
    set(handles.sparsity, 'string', settingRECON.sparsity);
    set(handles.NA, 'string', settingRECON.NA);
    set(handles.sparsity, 'string', settingRECON.sparsity);
    set(handles.Pixel, 'string', settingRECON.Pixel);
    set(handles.lambda, 'string', settingRECON.lambda);
    
    set(handles.zconti, 'string', settingRECON.zconti);
    
    set(handles.slider3,'Value', settingRECON.gaininput );
    
    % version 0.3.0
    set(handles.ThreeD,'Value', settingRECON.ThreeD );
    set(handles.Background,'Value', settingRECON.Background );
    set(handles.Oversample,'Value', settingRECON.Oversample );
    set(handles.debug,'Value', settingRECON.debug );
else
    set(handles.SHitertimes, 'string', '100');
    set(handles.debltimes, 'string', '10');
    
    set(handles.GPUON,'Value',0);
    set(handles.deblurON,'Value',1);
    
    set(handles.fidelity, 'string', '150');
    set(handles.sparsity, 'string', '15');
    set(handles.NA, 'string', '1.7');
    set(handles.Pixel, 'string', '32.5');
    set(handles.zconti, 'string', '1');
    set(handles.lambda, 'string', '488');
    
    set(handles.slider3,'Value', 5 );
    
    set(handles.ThreeD,'Value',0);
    set(handles.Background,'Value', 5 );
    set(handles.Oversample,'Value', 3);
    set(handles.debug,'Value', 0);
end
saveState(handles);
settingRECON.inputFilePath = '';
settingRECON.inputFileName = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function readState(handles)
global settingRECON;

settingRECON.SHitertimes = get(handles.SHitertimes, 'string');
settingRECON.debltimes = get(handles.debltimes, 'string');


settingRECON.fidelity = get(handles.fidelity, 'string');
settingRECON.sparsity = get(handles.sparsity, 'string');
settingRECON.NA = get(handles.NA, 'string');
settingRECON.Pixel = get(handles.Pixel, 'string');
settingRECON.zconti = get(handles.zconti, 'string');
settingRECON.lambda = get(handles.lambda, 'string');

settingRECON.GPUON = get(handles.GPUON, 'Value');
settingRECON.deblurON = get(handles.deblurON, 'Value');
settingRECON.gaininput = get(handles.slider3,'Value' );

% version 0.3.0
settingRECON.ThreeD = get(handles.ThreeD,'Value' );
settingRECON.Background = get(handles.Background,'Value' );
settingRECON.Oversample = get(handles.Oversample,'Value' );
settingRECON.debug = get(handles.debug,'Value' );


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function checkState(handles)

global settingRECON;
settingRECON.SHitertimes = get(handles.SHitertimes, 'string');
settingRECON.debltimes = get(handles.debltimes, 'string');

settingRECON.check = 1;


if mod(str2num(settingRECON.SHitertimes),1)>0 || str2num(settingRECON.SHitertimes)<1 ,
    disp(['Iter times should be a positive integer number']);
    settingRECON.check = 0;
end

if mod(str2num(settingRECON.debltimes),1)>0 || str2num(settingRECON.debltimes)<1 ,
    disp(['Iter times should be a positive integer number']);
    settingRECON.check = 0;
end


if ~ (exist([settingRECON.inputFilePath settingRECON.inputFileName])==2),
    disp('Input file is not selected');
    settingRECON.check = 0;
end


if (settingRECON.check>0)
    saveState(handles);
    disp('Sparse-SIM generating, please wait ...');
    Reconstruction(handles);
else
    disp('Retry after changing the variables according to the message !');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% --- Executes just before Sparse_SIM_recon is made visible.
function Sparse_SIM_recon_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sparse_SIM_recon (see VARARGIN)
clear gpuArray
% Choose default command line output for Sparse_SIM_recon
handles.output = hObject;
addpath('./Utils');
addpath('./SHOperation');
addpath('./SHIter');
addpath('./IterativeDeblur');
% Update handles structure
guidata(hObject, handles);

if ~exist('./RUN','dir')==1
    save_file('./RUN');
end

% global settingRECON;
loadState(handles);
% imshow(settingRECON.RawIMG,'Parent', handles.Before);
% imshow(settingRECON.ReconIMG,'Parent', handles.After);
% global beforedis
% global afterdis
% before= settingRECON.RawIMG;
% after= settingRECON.ReconIMG;
% for i=1:size(before,1)
%     for j=1:size(before,2)
%         beforedis=max(before(i,j,:));
%         afterdis=max(after(i,j,:));
%         i
%     end
% end

imshow(imread('LOGO.png'),'Parent', handles.logo);

imshow(zeros(1200,1200,3),'Parent', handles.Before);
imshow(zeros(1200,1200,3),'Parent', handles.After);
% UIWAIT makes Sparse_SIM_recon wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sparse_SIM_recon_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in RUN.
function RUN_Callback(hObject, eventdata, handles)
% hObject    handle to RUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% readState(handles);
% checkState(handles);
readState(handles);
checkState(handles);

% --- Executes on button press in GPUON.
function GPUON_Callback(hObject, eventdata, handles)
% hObject    handle to GPUON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GPUON
global settingRECON;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECON.GPUON = 1;
else
    settingRECON.GPUON = 0;
end




% --- Executes on button press in pushbuttonBrowser.
function pushbuttonBrowser_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;
global flage
flage=0;
[settingRECON.inputFileName, settingRECON.inputFilePath, gfindex] = uigetfile({'*.*',  'All files'}, 'Select data file', '../Data/SHRaw/');
if gfindex==0
    settingRECON.inputFilePath = '';
    settingRECON.inputFileName = '';
end
if exist([settingRECON.inputFilePath settingRECON.inputFileName])==2
    
    if (settingRECON.ThreeD)
        settingRECON.RawIMG=imreadTiff([settingRECON.inputFilePath, settingRECON.inputFileName], (settingRECON.ThreeD));
        zt=size(settingRECON.RawIMG,3);
        settingRECON.ReconIMG=zeros(size(settingRECON.RawIMG));
        beforedisp= settingRECON.RawIMG;
        afterdisp= settingRECON.ReconIMG;
        for i=1:size(settingRECON.RawIMG,1)
            for j=1:size(settingRECON.RawIMG,2)
                displaying(i,j)=max(beforedisp(i,j,:));
            end
        end
        imshow(0.5*settingRECON.gain*(displaying./max(max(displaying))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdisp(:,:,min(2,zt))./max(max(afterdisp(:,:,min(2,zt))))),'color',gray,'Parent', handles.After);
    else
        settingRECON.RawIMG=imreadTiff([settingRECON.inputFilePath, settingRECON.inputFileName]);
        settingRECON.ReconIMG=zeros(size(settingRECON.RawIMG));
        beforedisp= settingRECON.RawIMG;
        afterdisp= settingRECON.ReconIMG;
        zt=size(settingRECON.RawIMG,3);
        imshow(0.5*settingRECON.gain*(beforedisp(:,:,min(2,zt))./max(max(beforedisp(:,:,min(2,zt))))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdisp(:,:,min(2,zt))./max(max(afterdisp(:,:,min(2,zt))))),'color',gray,'Parent', handles.After);
    end
end








function fidelity_Callback(hObject, eventdata, handles)
% hObject    handle to fidelity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fidelity as text
%        str2double(get(hObject,'String')) returns contents of fidelity as a double


% --- Executes during object creation, after setting all properties.
function fidelity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fidelity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zconti_Callback(hObject, eventdata, handles)
% hObject    handle to zconti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zconti as text
%        str2double(get(hObject,'String')) returns contents of zconti as a double


% --- Executes during object creation, after setting all properties.
function zconti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zconti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sparsity_Callback(hObject, eventdata, handles)
% hObject    handle to sparsity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sparsity as text
%        str2double(get(hObject,'String')) returns contents of sparsity as a double


% --- Executes during object creation, after setting all properties.
function sparsity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sparsity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mu_Callback(hObject, eventdata, handles)
% hObject    handle to mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mu as text
%        str2double(get(hObject,'String')) returns contents of mu as a double


% --- Executes during object creation, after setting all properties.
function mu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NA_Callback(hObject, eventdata, handles)
% hObject    handle to NA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NA as text
%        str2double(get(hObject,'String')) returns contents of NA as a double


% --- Executes during object creation, after setting all properties.
function NA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambda_Callback(hObject, eventdata, handles)
% hObject    handle to lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambda as text
%        str2double(get(hObject,'String')) returns contents of lambda as a double


% --- Executes during object creation, after setting all properties.
function lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pixel_Callback(hObject, eventdata, handles)
% hObject    handle to Pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pixel as text
%        str2double(get(hObject,'String')) returns contents of Pixel as a double


% --- Executes during object creation, after setting all properties.
function Pixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function SHitertimes_Callback(hObject, eventdata, handles)
% hObject    handle to shitertimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of shitertimes as text
%        str2double(get(hObject,'String')) returns contents of shitertimes as a double


% --- Executes during object creation, after setting all properties.
function SHitertimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shitertimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function debltimes_Callback(hObject, eventdata, handles)
% hObject    handle to debltimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of debltimes as text
%        str2double(get(hObject,'String')) returns contents of debltimes as a double


% --- Executes during object creation, after setting all properties.
function debltimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to debltimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;
global flage;
global beforedisp;
global afterdisp;
settingRECON.gaininput = get(hObject,'Value');
settingRECON.gain = 2^(settingRECON.gaininput-5);
if settingRECON.ThreeD
    if flage==1
        imshow(0.5*settingRECON.gain*(beforedisp./max(beforedisp(:))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdisp./max(afterdisp(:))),'color',gray,'Parent', handles.After);
    else
        after= settingRECON.ReconIMG;
        before= settingRECON.RawIMG;
        zt=size(before,3);
        afterdis=after(:,:,min(2,zt));
        for i=1:size(before,1)
            for j=1:size(before,2)
                beforedis(i,j)=max(before(i,j,:));
            end
        end
        imshow(0.5*settingRECON.gain*(beforedis./max(beforedis(:))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdis./max(afterdis(:))),'color',gray,'Parent', handles.After);
    end
else
    if flage==1
        imshow(0.5*settingRECON.gain*(beforedisp./max(beforedisp(:))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdisp./max(afterdisp(:))),'color',gray,'Parent', handles.After);
    else
        before= settingRECON.RawIMG;
        after= settingRECON.ReconIMG;
        zt=size(before,3);
        beforedis=before(:,:,min(2,zt));
        afterdis=after(:,:,min(2,zt));
        imshow(0.5*settingRECON.gain*(beforedis./max(beforedis(:))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdis./max(afterdis(:))),'color',gray,'Parent', handles.After);
    end
end


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in Background.
function Background_Callback(hObject, eventdata, handles)
% hObject    handle to Background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;
val=get(hObject,'value');
settingRECON.Background=val;
% Hints: contents = cellstr(get(hObject,'String')) returns Background contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Background


% --- Executes during object creation, after setting all properties.
function Background_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Background.
function deblurON_Callback(hObject, eventdata, handles)
% hObject    handle to Background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;
val=get(hObject,'value');
settingRECON.deblurON=val;
% Hints: contents = cellstr(get(hObject,'String')) returns Background contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Background


% --- Executes during object creation, after setting all properties.
function deblurON_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in Oversample.
function Oversample_Callback(hObject, eventdata, handles)
% hObject    handle to Oversample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;
val=get(hObject,'value');
settingRECON.Oversample=val;
% Hints: contents = cellstr(get(hObject,'String')) returns Oversample contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Oversample


% --- Executes during object creation, after setting all properties.
function Oversample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Oversample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ThreeD.
function ThreeD_Callback(hObject, eventdata, handles)
% hObject    handle to ThreeD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECON.ThreeD = 1;
else
    settingRECON.ThreeD = 0;
end
% Hint: get(hObject,'Value') returns toggle state of ThreeD
global flage;
global beforedisp;
global afterdisp;
if settingRECON.ThreeD
    if flage==1
        imshow(0.5*settingRECON.gain*(beforedisp./max(beforedisp(:))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdisp./max(afterdisp(:))),'color',gray,'Parent', handles.After);
    else
        after= settingRECON.ReconIMG;
        before= settingRECON.RawIMG;
        afterdis=after(:,:,2);
        for i=1:size(before,1)
            for j=1:size(before,2)
                beforedis(i,j)=max(before(i,j,:));
            end
        end
        imshow(0.5*settingRECON.gain*(beforedis./max(beforedis(:))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdis./max(afterdis(:))),'color',gray,'Parent', handles.After);
    end
else
    if flage==1
        imshow(0.5*settingRECON.gain*(beforedisp./max(beforedisp(:))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdisp./max(afterdisp(:))),'color',gray,'Parent', handles.After);
    else
        before= settingRECON.RawIMG;
        after= settingRECON.ReconIMG;
        beforedis=before(:,:,2);
        afterdis=after(:,:,2);
        imshow(0.5*settingRECON.gain*(beforedis./max(beforedis(:))),'color',gray,'Parent', handles.Before);
        imshow(settingRECON.gain*(afterdis./max(afterdis(:))),'color',gray,'Parent', handles.After);
    end
end


% --- Executes on button press in debug.
function debug_Callback(hObject, eventdata, handles)
% hObject    handle to debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECON.debug = 1;
else
    settingRECON.debug = 0;
end
% Hint: get(hObject,'Value') returns toggle state of debug


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Reconstruction(handles)
global settingRECON
warning('off');
addpath('./Utils');
addpath('./SHOperation');
addpath('./SHIter');
addpath('./IterativeDeblur');
load('./RUN/recentsetting_SHrecon.mat');

GPUcompute= settingRECON.GPUON;
deblurON = settingRECON.deblurON;

inputFileName = settingRECON.inputFileName;
inputFilePath = settingRECON.inputFilePath;

SHIter = str2num(settingRECON.SHitertimes);
deblurIter = str2num(settingRECON.debltimes);

fidelity= str2num(settingRECON.fidelity) ;
sparsity=str2num(settingRECON.sparsity) ;
NA=str2num(settingRECON.NA );
lambda=str2num(settingRECON.lambda);
lambda=lambda*10^-9;
Pixel=str2num(settingRECON.Pixel );
Pixel=Pixel*10^-9;
zconti= str2num(settingRECON.zconti);
GAIN=(settingRECON.gain);

Background = (settingRECON.Background);
ThreeD = (settingRECON.ThreeD);
Oversample = (settingRECON.Oversample);
debug = (settingRECON.debug);
if ~exist('./Data','dir')==1
    save_file('./Data');
end
if ~exist('./Data/SHRaw','dir')==1
    save_file('./Data/SHRaw');
end
if ~exist('./Data/SHRaw/mat','dir')==1
    save_file('./Data/SHRaw/mat');
end
if ~exist('./Data/SHReconstructed','dir')==1
    save_file('./Data/SHReconstructed');
end
%%%%%%%%%%%%%%%%%%% Load Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global beforedisp
global afterdisp
% strcmp(inputFileName(end-3:end), '.mat');
% SIMmovie=cell2mat(struct2cell(load([inputFilePath inputFileName])));
SIMmovie=imreadTiff([inputFilePath inputFileName],ThreeD);
SIMmovie=single(SIMmovie);
constant=max(SIMmovie(:));
SIMmovie=SIMmovie./constant;
if size(SIMmovie,3)<3
    flage3=size(SIMmovie,3);
    SIMmovie=padarray(SIMmovie,[0,0,3-size(SIMmovie,3)],'replicate' );
else
    flage3=size(SIMmovie,3);
end

inputFileName_pure=inputFileName(1:end-4);
save (['.\Data\SHRaw\mat\',inputFileName_pure,'.mat'],'SIMmovie');

savePath = ['.\Data\SHReconstructed\' inputFilePath(strfind(inputFilePath, '\Data\SHRaw\') + 19 : end)];
if exist(savePath)==7
    ;
else
    mkdir(savePath);
end

disp('Successfully loaded input data');
if ThreeD
    for i=1:size(SIMmovie,1)
        for j=1:size(SIMmovie,2)
            beforedisp(i,j)=max(SIMmovie(i,j,:));
        end
    end
else
    beforedisp=SIMmovie(:,:,2);
end
imshow(0.5*GAIN*(beforedisp./max(beforedisp(:))),'color',gray,'Parent', handles.Before);
if debug && flage3 > 5
    SIMmovie=SIMmovie(:,:,1:5);
    flage3=5;
else
    ;
end
%%%%%%%%%%%% Check data size  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global VIDEOResolution ;
VIDEOResolution = [size(SIMmovie,1)  size(SIMmovie,2)  size(SIMmovie,3)];
disp(['Data size is ' num2str(VIDEOResolution(1)) ' X ' num2str(VIDEOResolution(2)) ' X ' num2str(VIDEOResolution(3))]);
%%%%%%%%%%%%% RUN Reconstruction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if GPUcompute
    gpu=1;
else
    gpu=0;
end

disp(['Pre-operation...']);

if deblurON
    if Oversample~=3
        psfkernel=kernel(Pixel/2, lambda, NA,0,min(size(SIMmovie,1), size(SIMmovie,2)));
    elseif Oversample==3
        psfkernel=kernel(Pixel, lambda, NA,0,min(size(SIMmovie,1), size(SIMmovie,2)));
    end
end

Time_Str=get_time;
inputFileName(end-3:end)=[];
if ThreeD
    filepath=strcat('Data\SHReconstructed\',Time_Str,inputFileName,'_Volume');
else
    filepath=strcat('Data\SHReconstructed\',Time_Str,inputFileName,'_Video');
end
save_file(filepath);

SIMmovie=SIMmovie./max(SIMmovie(:));
disp(['Background estimation...']);

switch Background
    case 1
        backgrounds = background_estimation(SIMmovie./2);
        imwritestack(constant*backgrounds, [filepath,'\',inputFileName_pure,'_background.tif']);
        SIMmovie = SIMmovie-backgrounds;
    case 2
        backgrounds= background_estimation(SIMmovie./2.5);
        imwritestack(constant*backgrounds, [filepath,'\',inputFileName_pure,'_background.tif']);
        SIMmovie = SIMmovie-backgrounds;
    case 3
        medVal = mean(SIMmovie(:));
        sub_temp = SIMmovie;
        sub_temp(sub_temp > medVal)=medVal;
        backgrounds= background_estimation(sub_temp);
        imwritestack(constant*backgrounds, [filepath,'\',inputFileName_pure,'_background.tif']);
        SIMmovie = SIMmovie-backgrounds;
    case 4
        medVal = mean(SIMmovie(:))./2;
        sub_temp = SIMmovie;
        sub_temp(sub_temp > medVal)=medVal;
        backgrounds = background_estimation(sub_temp);
        imwritestack(constant*backgrounds, [filepath,'\',inputFileName_pure,'_background.tif']);
        SIMmovie = SIMmovie-backgrounds;
    case 5
        medVal = mean(SIMmovie(:))./2.5;
        sub_temp = SIMmovie;
        sub_temp(sub_temp > medVal)=medVal;
        backgrounds = background_estimation(sub_temp);
        imwritestack(constant*backgrounds, [filepath,'\',inputFileName_pure,'_background.tif']);
        SIMmovie = SIMmovie - backgrounds;
    case 6
        ;
end
SIMmovie(SIMmovie < 0)=0;
SIMmovie = SIMmovie./max(SIMmovie(:));
if debug
    ;
elseif  debug==0 && size(SIMmovie,3)>3
    SIMmovie(:,:,3:size(SIMmovie,3)+2) = SIMmovie;
    SIMmovie(:,:,2) = SIMmovie(:,:,4);
    SIMmovie(:,:,1) = SIMmovie(:,:,5);
end

switch Oversample
    case 1
        y=Spatial_Oversample(SIMmovie);
        f=single(y);
    case 2
        y=Fourier_Oversample(SIMmovie);
        f=single(y);
    case 3
        f=single(SIMmovie);
end

disp(['Sparse-SIM reconstruction is ongoing...']);
SHVideo=SparseHessian_core(f,fidelity,zconti,sparsity,SHIter,gpu);
if debug; elseif debug==0 && size(SHVideo,3)>3
    SHVideo=SHVideo(:,:,3:end);
end
SHVideo=SHVideo(:,:,1:flage3);
if GPUcompute
    if deblurON~=3
        % SHguessCPU = gather(SHVideo);
        % SHguessCPU =double(SHguessCPU );
        tic;SHdeblur=Iterative_deblur(SHVideo,psfkernel,deblurIter,deblurON,gpu); time2=toc;
        disp([' Iterative deblur took ' num2str(time2) ' secs']);
        SHdeblurCPU = gather(SHdeblur);
        SHdeblurCPU = SHdeblurCPU./max(SHdeblurCPU(:));
    elseif deblurON==3
        SHguessCPU = gather(SHVideo);
        SHguessCPU = SHguessCPU./max(SHguessCPU(:));
    end
else
    if deblurON~=3
        % SHVideo=double(SHVideo);
        % SHguessCPU = SHVideo./max(SHVideo(:));
        tic;SHdeblur=Iterative_deblur(SHVideo,psfkernel,deblurIter,deblurON,gpu); time2=toc;
        disp([' Iterative deblur took: ' num2str(time2) ' secs']);
        SHdeblurCPU = SHdeblur;
        SHdeblurCPU = SHdeblurCPU./max(SHdeblurCPU(:));
    elseif deblurON==3
        SHguessCPU = SHVideo./max(SHVideo(:));
    end
end
%% display
if deblurON~=3
    save ([filepath,'\SparseSIMresult.mat'],'SHdeblurCPU')
    write_tif(SHdeblurCPU,filepath,inputFileName_pure,ThreeD,Oversample,constant)
    if ThreeD
        for i=1:size(SHdeblurCPU,1)
            for j=1:size(SHdeblurCPU,2)
                afterdisp(i,j)=max(SHdeblurCPU(i,j,:));
            end
        end
        for i=1:size(SIMmovie,1)
            for j=1:size(SIMmovie,2)
                beforedisp(i,j)=max(SIMmovie(i,j,:));
            end
        end
        imshow(GAIN*(afterdisp./max(afterdisp(:))),'color',gray,'Parent', handles.After);
    else
        afterdisp=SHdeblurCPU(:,:,min(2,flage3));
        imshow(GAIN*(afterdisp./max(afterdisp(:))),'color',gray,'Parent', handles.After);
    end
elseif deblurON==3
    save ([filepath,'\SparseSIM_nodeconv.mat'],'SHguessCPU')
    write_tif(SHguessCPU,filepath,inputFileName_pure,ThreeD,Oversample,constant)
    if ThreeD
        for i=1:size(SHguessCPU,1)
            for j=1:size(SHguessCPU,2)
                afterdisp(i,j)=max(SHguessCPU(i,j,:));
            end
        end
        for i=1:size(SIMmovie,1)
            for j=1:size(SIMmovie,2)
                beforedisp(i,j)=max(SIMmovie(i,j,:));
            end
        end
        imshow(GAIN*(afterdisp./max(afterdisp(:))),'color',gray,'Parent', handles.After);
    else
        afterdisp=SHguessCPU(:,:,min(2,flage3));
        imshow(GAIN*(afterdisp./max(afterdisp(:))),'color',gray,'Parent', handles.After);
    end
end
global flage
flage=1;
if ThreeD
    disp(' Volume reconstruction completed.');
else
    disp(' Video reconstruction completed.');
end
