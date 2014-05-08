function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%gui
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 06-May-2014 17:13:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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
 
% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;
handles.serial = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.str = get(handles.run_button,'String');

if(strcmp(handles.str, 'Run'))
    clear global snapshots;
    
    %setup our serial connection
    set(handles.run_button,'String','Stop');
    handles.exit = 'no';
    handles.serial = serial('/dev/tty.GripIt-9D37-RNI-SPP', 'BaudRate', 115200);
    handles.snapshots = [];
    guidata(hObject,handles);
    s = handles.serial;
    fopen(s);
    
    %save data variable
    data = [];
    count = 1;
    
    %totaled force line
    forceLine = zeros(1,70);

    %input array
    x = zeros(16,16);
    tail = zeros(6,1);
    
    %setup our colormap view
    colormap('jet')
    h = pcolor(handles.axes,x);
    caxis(handles.axes,[0,85]);
    colorbar('peer',handles.axes);
    set(h, 'EdgeColor', 'none');

    %integrated force plot
    force = plot(handles.axes2,forceLine);
    %calibartion number
    cali = 0;
    
    %set the maxForce to zero
    maxForce = 0;
    set(handles.maxForce, 'String', '0');

    
    while 1
        %read in our data values
        try
            tmp = fscanf(s,'%d:%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,;');
            if tmp(1)==0
                tmp = [tmp;tail];
                %             for m = 1:size(tmp,1)
                %                 if tmp(m) ~= 0
                %                     tmp(m) = tmp(m)/1024.0*5.0
                %                     tmp(m) = ((5.0-tmp(m))/tmp(m));
                %                 end
                %             end
                x =[tmp(2:length(tmp)) x(:,2:16)];
                for i=1:15
                    try
                        tmp2 = fscanf(s,'%d:%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,;');
                        if tmp2(1)~=15
                            tmp2 = [tmp2;tail];
                            %                         for n = 1:size(tmp2,1)
                            %                             if tmp2(n) ~= 0
                            %                                 tmp2(n) = tmp2(n)/1024.0*5.0
                            %                                 tmp2(n) = ((5.0-tmp2(n))/tmp2(n));
                            %                             end
                            %                         end
                            x =[x(:,1:i) tmp2(2:length(tmp2)) x(:,i+2:16)];
                            %x(i+1) = tmp2(2:length(tmp2));
                        else
                        end
                    end
                end
            end
        end
        
        %set a zeroing calibration here
        if(cali == 0)
          cali = x;
        end
        
        l =[1:16];
        w =[1:16];
        %TODO take the wierd row and average the row above and below
        %x = x - cali;
        
        %flip our array
        x = flipud(x);
        %do our calculations here
        %find our resistance for the force sensor
        calc = 4700 .* ((3.3./((3.3.*x)./1024)) - 1);
        %turn this into Pounds per Square Inch based on the sensitronics graph
        calc = 6760.26 ./ (calc.^(1000/1127));
        %calc = calc .* (160 / 6);
        %convert inf to zero (caused by division by zero)
        calc(~isfinite(calc)) = 0;
        %set x to calc
        %%
        % NOTE: 
        % - Each element in the matrix corresponds to an area of 0.0062 square inches
        % - The conversion factor [17] is unitless, and accounts for
        % differences from the provided calibration curve and the actual
        % behavior of the pressur sensing cells.
        %%
        x = calc.*17;
        
        %area of each sensing location in square inches
        areaSens1 = 0.0062;
        
        data(:,:,count) = x;
        count = count + 1;
        
        set(h,'CData',x);
        
        %Calculate the total force being applied on the sensor
        xForce = 0;
        
        for i = 1:length(l)
            for j = 1:length(w)
                xForce = xForce + areaSens1.*x(i,j);
            end
        end
        
        %if we have a new max force, set the label and variable
        if xForce > maxForce
           set(handles.maxForce, 'String', num2str(xForce));
           maxForce = xForce;
        end
        
        %display it in a beautiful line graph
        forceLine = circshift(forceLine,[0,1]);
        forceLine(1) = xForce;
        set(force,'Ydata', forceLine);
        
        %draw everything before the next loop iteration
        drawnow;
        handles.data = data;
        guidata(hObject,handles);
    end
else
    set(handles.run_button,'String','Run');
    guidata(hObject,handles);
    fclose(handles.serial);
    delete(handles.serial);
    handles.serial = 0;
    handles.exit = 'yes';
    guidata(hObject,handles);
end



% --- Executes on button press in save_date.
function save_date_Callback(hObject, eventdata, handles)
% hObject    handle to save_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles,'data'))
    try
        [file,path] = uiputfile('*.dat','Save Grip Data', strcat(date,'grip_data'));
        %fileID = fopen(file,'w');
        dlmwrite(strcat(path,file),handles.data);
        %fclose(fileID);
    end
else
    msgbox('There is no data to save yet')
end


% --- Executes on button press in shapshot.
function shapshot_Callback(hObject, eventdata, handles)
% hObject    handle to shapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global snapshots;
if(isfield(handles,'data'))
    snapshots = handles.snapshots;
    snapshots(:,:,end+1) = handles.data(:,:,end);
    disp(handles.data(:,:,end));
    handles.snapshots = snapshots;
    guidata(hObject,handles);
end
