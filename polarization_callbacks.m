function polarization_callbacks(callback_name, varargin)
    switch callback_name
        case 'pause'
            pause_callback(varargin{:});
        case 'stop'
            stop_callback(varargin{:});
        case 'faster'
            faster_callback(varargin{:});
        case 'slower'
            slower_callback(varargin{:});
        case 'reset_view'
            reset_view_callback(varargin{:});
    end
end

function pause_callback(src, evt)
    if evalin('base', 'stop_animation')
        assignin('base', 'restart_animation', true);
        assignin('base', 'stop_animation', false);
        set(src, 'String', 'Pause');
        return;
    end
    
    is_paused = evalin('base', 'is_paused');
    is_paused = ~is_paused;
    assignin('base', 'is_paused', is_paused);
    
    if is_paused
        set(src, 'String', 'Play');
    else
        set(src, 'String', 'Pause');
    end
end

function stop_callback(src, evt)
    assignin('base', 'stop_animation', true);
end

function faster_callback(src, evt)
    v = evalin('base', 'speed_mult');
    v = max(0.05, v * 0.5);
    assignin('base', 'speed_mult', v);
end

function slower_callback(src, evt)
    v = evalin('base', 'speed_mult');
    v = min(8, v * 2);
    assignin('base', 'speed_mult', v);
end


function reset_view_callback(src, evt)
    view(45, 30);
end