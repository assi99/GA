function visualize_drone_and_propellers(stl_file, prop_coords, cog)
    figure;
    view_stl(stl_file); hold on;

    % Determine propeller Z height (just above surface)
    base_z = cog(3);        % Use COG Z as reference
    z_offset = 0.02;        % Raise props slightly above drone surface
    thrust_length = 0.05;   % Length of thrust arrows

    % Plot P1 - Red
    scatter3(prop_coords(1,1), prop_coords(1,2), base_z + z_offset, ...
        80, 'r', 'filled', 'DisplayName', 'P1');

    % Plot P2 - Green
    scatter3(prop_coords(2,1), prop_coords(2,2), base_z + z_offset, ...
        80, 'g', 'filled', 'DisplayName', 'P2');

    % Plot P3 - Blue
    scatter3(prop_coords(3,1), prop_coords(3,2), base_z + z_offset, ...
        80, 'b', 'filled', 'DisplayName', 'P3');
    
    % Plot COG - Black X
    plot3(cog(1), cog(2), cog(3), 'kx', ...
        'MarkerSize', 12, 'LineWidth', 2, 'DisplayName', 'COG');

    title('3D Propeller Placement');
    xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
    legend('Location', 'bestoutside');
    grid on; axis equal;
    view(3);
    camlight; lighting gouraud;
end
