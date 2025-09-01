function view_stl(filename)
    try
        [F, V] = read_stl_ascii(filename);  % <- use custom ASCII loader
        if isempty(F) || isempty(V)
            warning('STL file is empty or invalid. Skipping STL plot.');
            return;
        end
        patch('Faces', F, 'Vertices', V, ...
              'FaceColor', [0.8 0.8 1.0], ...
              'EdgeColor', 'none', ...
              'FaceAlpha', 0.3);
        axis equal;
        xlabel('X'); ylabel('Y'); zlabel('Z');
        camlight; lighting gouraud;
    catch ME
        warning('STL file could not be loaded: %s', ME.message);
    end
end
