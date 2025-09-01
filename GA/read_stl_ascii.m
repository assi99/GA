function [F, V] = read_stl_ascii(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open STL file.');
    end

    v = [];  % Vertices
    f = [];  % Faces
    i = 0;

    while ~feof(fid)
        tline = fgetl(fid);
        if contains(tline, 'vertex')
            nums = sscanf(tline, ' vertex %f %f %f');
            v = [v; nums'];
        elseif contains(tline, 'endfacet')
            i = i + 1;
            f = [f; (i-1)*3+1 (i-1)*3+2 (i-1)*3+3];
        end
    end
    fclose(fid);
    V = v;
    F = f;
end
