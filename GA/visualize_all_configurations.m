function visualize_all_configurations(stl_file, prop_positions, idx_log, cog_xy)
    figure; hold on; axis equal;
    view_stl(stl_file); hold on;

    % Colors for P1, P2, P3 (match 3D view)
    color_p1 = [1, 0, 0];   % red
    color_p2 = [0, 0.6, 0]; % green
    color_p3 = [0, 0.4, 1]; % blue

    % Plot all evaluated propeller positions
    for k = 1:length(idx_log)
        idx = idx_log{k};
        p1 = prop_positions{1}(idx(1), :);
        p2 = prop_positions{2}(idx(2), :);
        p3 = [p2(1), -p2(2)];

        scatter(p1(1), p1(2), 20, color_p1, 'filled');  % P1 - red
        scatter(p2(1), p2(2), 20, color_p2, 'filled');  % P2 - green
        scatter(p3(1), p3(2), 20, color_p3, 'filled');  % P3 - blue
    end

    % Plot COG
    scatter(cog_xy(1), cog_xy(2), 50, 'k', 'x', 'LineWidth', 2);  % black X

    % Title and axis labels
    title('All Evaluated Propeller Placements');
    xlabel('X (m)');
    ylabel('Y (m)');

    % Set correct legend order and names
    legend({'P1','P2','P3','COG'}, 'Location', 'northeastoutside');

    grid on;
end
