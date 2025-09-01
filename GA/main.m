clear; clc;

% STL file
stl_file = 'solution1STLfile.stl';

% Center of Gravity (COG)
cog = [-0.2297, 9.98e-05, -0.0234];
cog_xy = cog(1:2);

% Propeller positions
prop1_list = [
    0.500, 0.00;
   -0.900, 0.00
];
prop2_list = [
    0.070, 0.20;
    0.040, 0.35;
   -0.030, 0.30;
   -0.070, 0.35;
   -0.150, 0.45;
   -0.200, 0.50;
   -0.255, 0.55;
   -0.300, 0.65;
   -0.350, 0.70;
   -0.400, 0.75
];
prop_positions = {prop1_list, prop2_list};

% Compute fitness for all valid combinations
scores = zeros(2, 10);
global idx_log
idx_log = {};

for i = 1:2
    for j = 1:10
        idx = [i, j];
        score = fitness_prop_ultra(idx, prop_positions, cog);
        scores(i, j) = score;
    end
end

[min_val, linear_idx] = min(scores(:));
[best_i, best_j] = ind2sub(size(scores), linear_idx);
best_idx = [best_i, best_j];

% Extract best positions
p1 = prop1_list(best_idx(1), :);
p2 = prop2_list(best_idx(2), :);
p3 = [p2(1), -p2(2)];
prop_coords = [p1; p2; p3];

fprintf('\n Best Configuration (Ultra Fitness):\n');
fprintf('P1: (%.2f, %.2f)\n', p1(1), p1(2));
fprintf('P2: (%.2f, %.2f)\n', p2(1), p2(2));
fprintf('P3: (%.2f, %.2f)\n', p3(1), p3(2));
fprintf('Score: %.4f\n', min_val);

visualize_drone_and_propellers(stl_file, prop_coords, cog);
visualize_all_configurations(stl_file, prop_positions, idx_log, cog_xy);
