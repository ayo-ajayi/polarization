if exist('OCTAVE_VERSION', 'builtin')
    disp('Running in Octave');
    disp('Rotation works better when paused.');
    graphics_toolkit('qt');
else
    disp('Running in MATLAB');
end

A = 1; %amplitude ratio of Ey to Ex
psi = pi / 2; %phase difference between Ey and Ex
omega = 2 * pi;
x_dot = 1;
y_dot = 1;
t = linspace(0, 10, 2000);
Ex = x_dot * cos(omega * t);
Ey = y_dot * A * cos(omega * t - psi);

fig = figure;
set(fig, 'Position', [100, 100, 600, 500]);

ax = gca;
set(ax, 'Position', [0.18 0.17 0.65 0.65]);
rotate3d on;
view(45, 30);

fig_pos = get(fig, 'Position');
button_y = 10;

is_paused = false;
speed_mult = 1;
stop_animation = false;
restart_animation = false;

btn_pause = uicontrol('Style', 'pushbutton', 'String', 'Pause', ...
    'Position', [10 button_y 60 25], ...
    'Callback', @(src, evt) polarization_callbacks('pause', src, evt));

btn_stop = uicontrol('Style', 'pushbutton', 'String', 'Stop', ...
    'Position', [75 button_y 60 25], ...
    'Callback', @(src, evt) polarization_callbacks('stop', src, evt));

btn_faster = uicontrol('Style', 'pushbutton', 'String', 'Faster', ...
    'Position', [140 button_y 60 25], ...
    'Callback', @(src, evt) polarization_callbacks('faster', src, evt));

btn_slower = uicontrol('Style', 'pushbutton', 'String', 'Slower', ...
    'Position', [205 button_y 60 25], ...
    'Callback', @(src, evt) polarization_callbacks('slower', src, evt));

btn_reset_view = uicontrol('Style', 'pushbutton', 'String', 'Reset View', ...
    'Position', [270 button_y 70 25], ...
    'Callback', @(src, evt) polarization_callbacks('reset_view', src, evt));

while true

    if ~ishandle(fig)
        break;
    end

    restart_animation = false;
    stop_animation = false;
    is_paused = false;

    while ishandle(fig) &&~stop_animation

        for i = 1:10:length(t)

            if ~ishandle(fig)
                break;
            end

            if stop_animation
                [az, el] = view();
                delete(get(gca, 'children'));

                hold on;

                plot3([0 max(t)], [0 0], [0 0], 'k:', 'LineWidth', 1);
                plot3([0 0], [min(Ey) max(Ey)], [0 0], 'k-', 'LineWidth', 1);
                plot3([0 0], [0 0], [min(Ex) max(Ex)], 'k-', 'LineWidth', 1);

                plot3(t, Ey, Ex, 'g-', 'LineWidth', 2.5);
                plot3(zeros(1, length(t)), Ey, Ex, 'm-', 'LineWidth', 1.5);
                plot3(t, zeros(1, length(t)), Ex, 'r-', 'LineWidth', 1);
                plot3(t, Ey, zeros(1, length(t)), 'b-', 'LineWidth', 1);

                plot3(t(end), 0, Ex(end), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
                plot3(t(end), Ey(end), 0, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
                plot3(0, Ey(end), Ex(end), 'mo', 'MarkerSize', 6, 'MarkerFaceColor', 'm');
                plot3(t(end), Ey(end), Ex(end), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

                plot3([t(end) t(end)], [0 Ey(end)], [0 Ex(end)], 'g--', 'LineWidth', 1);

                arrow_length = t(end);
                head_size = 0.15;
                plot3([0 arrow_length], [0 0], [0 0], '-', 'Color', [1 0.5 0], 'LineWidth', 2.5);
                plot3([arrow_length, arrow_length - head_size], [0, 0], [0, head_size / 2], '-', 'Color', [1 0.5 0], 'LineWidth', 2.5);
                plot3([arrow_length, arrow_length - head_size], [0, 0], [0, -head_size / 2], '-', 'Color', [1 0.5 0], 'LineWidth', 2.5);

                hold off;

                grid on;
                xlabel('Time (s)');
                ylabel('E_y');
                zlabel('E_x');
                title(['A = ', num2str(A), ', \psi = ', num2str(psi), ' rad (Complete)']);

                view(az, el);
                axis([0 max(t) min(Ey) max(Ey) min(Ex) max(Ex)]);
                drawnow;

                set(btn_pause, 'String', 'Restart');

                break;
            end

            while is_paused && ishandle(fig) &&~stop_animation
                pause(0.1);
            end

            [az, el] = view();
            delete(get(gca, 'children'));

            hold on;

            plot3([0 max(t)], [0 0], [0 0], 'k:', 'LineWidth', 1);
            plot3([0 0], [min(Ey) max(Ey)], [0 0], 'k-', 'LineWidth', 1);
            plot3([0 0], [0 0], [min(Ex) max(Ex)], 'k-', 'LineWidth', 1);

            plot3(t(1:i), Ey(1:i), Ex(1:i), 'g-', 'LineWidth', 2.5);
            plot3(zeros(1, i), Ey(1:i), Ex(1:i), 'm-', 'LineWidth', 1.5);
            plot3(t(1:i), zeros(1, i), Ex(1:i), 'r-', 'LineWidth', 1);
            plot3(t(1:i), Ey(1:i), zeros(1, i), 'b-', 'LineWidth', 1);

            plot3(t(i), 0, Ex(i), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
            plot3(t(i), Ey(i), 0, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
            plot3(0, Ey(i), Ex(i), 'mo', 'MarkerSize', 6, 'MarkerFaceColor', 'm');
            plot3(t(i), Ey(i), Ex(i), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

            plot3([t(i) t(i)], [0 Ey(i)], [0 Ex(i)], 'g--', 'LineWidth', 1);

            arrow_length = t(i);
            head_size = 0.15;
            plot3([0 arrow_length], [0 0], [0 0], '-', 'Color', [1 0.5 0], 'LineWidth', 2.5);
            plot3([arrow_length, arrow_length - head_size], [0, 0], [0, head_size / 2], '-', 'Color', [1 0.5 0], 'LineWidth', 2.5);
            plot3([arrow_length, arrow_length - head_size], [0, 0], [0, -head_size / 2], '-', 'Color', [1 0.5 0], 'LineWidth', 2.5);

            hold off;

            grid on;
            xlabel('Time (s)');
            ylabel('E_y');
            zlabel('E_x');
            title(['A = ', num2str(A), ', \psi = ', num2str(psi), ' rad']);

            view(az, el);

            axis([0 max(t) min(Ey) max(Ey) min(Ex) max(Ex)]);
            drawnow;
            pause(0.01 * speed_mult);
        end

        if ~ishandle(fig)
            break;
        end

        if ishandle(btn_pause)
            set(btn_pause, 'String', 'Restart');
        end

        stop_animation = true;
    end

    if ishandle(fig) &&~restart_animation
        disp('Animation stopped. Click Restart to play again or close the window to exit.');

        while ishandle(fig) &&~restart_animation
            pause(0.1);
        end

    end

    if ~ishandle(fig) ||~restart_animation
        break;
    end

end

clearvars;

disp('Done!');
