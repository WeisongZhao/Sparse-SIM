function progressbar(varargin)

persistent progfig progdata lastupdate

if nargin > 0
    input = varargin;
    ninput = nargin;
else
    
    input = {0};
    ninput = 1;
end

if input{1} == 1
    if ishandle(progfig)
        delete(progfig)
    end
    clear progfig progdata lastupdate 
    drawnow
    return
end

resetflag = false;

if ischar(input{1})
    resetflag = true;
end

if input{1} == 0

    if all([input{:}] == 0) && (length([input{:}]) == ninput)
        resetflag = true;
    end
end

if ninput > length(progdata)
    resetflag = true;
end

if resetflag
    if ishandle(progfig)
        delete(progfig) % Close progress bar
    end
    progfig = [];
    progdata = []; % Forget obsolete data
end

if ishandle(progfig)
else 

    height = 0.06;
    width = height * 5;
    hpad = 0.02;
    vpad = 0.25;
    

    nbars = max(ninput, length(progdata));
    

    heightfactor = (1 - vpad) * nbars + vpad;
    height = height * heightfactor;
    vpad = vpad / heightfactor;
    

    left = (1 - width) / 2;
    bottom = (1 - height) / 2;
    progfig = figure(...
        'Units', 'normalized',...
        'Position', [left bottom width height],...
        'NumberTitle', 'off',...
        'Resize', 'off',...
        'MenuBar', 'none' );
    

    left = hpad;
    width = 1 - 2*hpad;
    vpadtotal = vpad * (nbars + 1);
    height = (1 - vpadtotal) / nbars;
    for ndx = 1:nbars

        bottom = vpad + (vpad + height) * (nbars - ndx);
        progdata(ndx).progaxes = axes( ...
            'Position', [left bottom width height], ...
            'XLim', [0 1], ...
            'YLim', [0 1], ...
            'Box', 'on', ...
            'ytick', [], ...
            'xtick', [] );
        progdata(ndx).progpatch = patch( ...
            'XData', [0 0 0 0], ...
            'YData', [0 0 1 1] );
        progdata(ndx).progtext = text(0.99, 0.5, '', ...
            'HorizontalAlignment', 'Right', ...
            'FontUnits', 'Normalized', ...
            'FontSize', 0.8,'color','k' );
        progdata(ndx).proglabel = text(0.01, 0.5, '', ...
            'HorizontalAlignment', 'Left', ...
            'FontUnits', 'Normalized', ...
            'FontSize', 0.8 ,'color','k');
        if ischar(input{ndx})
            set(progdata(ndx).proglabel, 'String', input{ndx})
            input{ndx} = 0;
        end
        
        
        set(progdata(ndx).progaxes, 'ButtonDownFcn', {@Definecolor, progdata(ndx).progpatch})
        set(progdata(ndx).progpatch, 'ButtonDownFcn', {@Definecolor, progdata(ndx).progpatch})
        set(progdata(ndx).progtext, 'ButtonDownFcn', {@Definecolor, progdata(ndx).progpatch})
        set(progdata(ndx).proglabel, 'ButtonDownFcn', {@Definecolor, progdata(ndx).progpatch})
        

        Definecolor([], [], progdata(ndx).progpatch)
        

        if ~isfield(progdata(ndx), 'starttime') || isempty(progdata(ndx).starttime)
            progdata(ndx).starttime = clock;
        end
    end
    
    
    lastupdate = clock - 1;
    
end

for ndx = 1:ninput
    if ~isempty(input{ndx})
        progdata(ndx).fractiondone = input{ndx};
        progdata(ndx).clock = clock;
    end
end

myclock = clock;
if abs(myclock(6) - lastupdate(6)) < 0.01 
    return
end

for ndx = 1:length(progdata)
    set(progdata(ndx).progpatch, 'XData', ...
        [0, progdata(ndx).fractiondone, progdata(ndx).fractiondone, 0])
end

if length(progdata) > 1
    for ndx = 1:length(progdata)
        set(progdata(ndx).progtext, 'String', ...
            sprintf('%1d%%', floor(100*progdata(ndx).fractiondone)))
    end
end

if progdata(1).fractiondone > 0
    runtime = etime(progdata(1).clock, progdata(1).starttime);
    timeleft = runtime / progdata(1).fractiondone - runtime;
    timeleftstr = sec2timestr(timeleft);
    titlebarstr = sprintf('Status: %2d%%    %s remaining', ...
        floor(100*progdata(1).fractiondone), timeleftstr);
else
    titlebarstr = ' Status: 0%';
end
set(progfig, 'Name', titlebarstr)

drawnow

lastupdate = clock;
% ------------------------------------------------------------------------------
function Definecolor(h, e, progpatch) 
thiscolor = [0.5,0.5,1];
set(progpatch, 'FaceColor', thiscolor)
% ------------------------------------------------------------------------------
function timestr = sec2timestr(sec)


w = floor(sec/604800); % Weeks
sec = sec - w*604800;
d = floor(sec/86400); % Days
sec = sec - d*86400;
h = floor(sec/3600); % Hours
sec = sec - h*3600;
m = floor(sec/60); % Minutes
sec = sec - m*60;
s = floor(sec); % Seconds


if w > 0
    if w > 9
        timestr = sprintf('%d week', w);
    else
        timestr = sprintf('%d week, %d day', w, d);
    end
elseif d > 0
    if d > 9
        timestr = sprintf('%d day', d);
    else
        timestr = sprintf('%d day, %d hr', d, h);
    end
elseif h > 0
    if h > 9
        timestr = sprintf('%d hr', h);
    else
        timestr = sprintf('%d hr, %d min', h, m);
    end
elseif m > 0
    if m > 9
        timestr = sprintf('%d min', m);
    else
        timestr = sprintf('%d min, %d sec', m, s);
    end
else
    timestr = sprintf('%d sec', s);
end