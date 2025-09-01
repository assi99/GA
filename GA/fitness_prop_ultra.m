function score = fitness_prop_ultra(idx, prop_positions, cog)
    global idx_log
    idx_log{end+1} = idx;

    P1 = prop_positions{1}(idx(1), :);
    P2 = prop_positions{2}(idx(2), :);
    P3 = [P2(1), -P2(2)];
    COG = cog(1:2);

    % Geometry and structure
    d_total = norm(P1 - COG) + norm(P2 - COG) + norm(P3 - COG);
    symmetry_penalty = abs(P2(1) - P3(1)) + abs(P2(2) + P3(2));
    spacing = [norm(P1 - P2), norm(P1 - P3), norm(P2 - P3)];
    cluster_penalty = 1 / (mean(spacing) + 1e-6);
    tri_std = std(spacing);
    area = polyarea([P1(1), P2(1), P3(1)], [P1(2), P2(2), P3(2)]);

    % COG and centroid alignment
    centroid = mean([P1; P2; P3]);
    cog_centroid_offset = norm(centroid - COG);

    % Torque / Moment
    tq1 = cross([P1 - COG, 0], [0 0 1]);
    tq2 = cross([P2 - COG, 0], [0 0 -1]);
    tq3 = cross([P3 - COG, 0], [0 0 1]);
    tq_sum = tq1 + tq2 + tq3;
    torque_magnitude = norm(tq_sum);
    moment_1D = (P1(1) - COG(1)) - (P2(1) - COG(1)) + (P3(1) - COG(1));

    % Inertia approximations
    Ix = sum([(P1(2)-COG(2))^2, (P2(2)-COG(2))^2, (P3(2)-COG(2))^2]);
    Iy = sum([(P1(1)-COG(1))^2, (P2(1)-COG(1))^2, (P3(1)-COG(1))^2]);
    inertia_penalty = abs(Ix - Iy) + 0.05*(Ix + Iy);

    % Arm length
    arm_lengths = vecnorm([P1; P2; P3] - COG, 2, 2);
    longest_arm = max(arm_lengths);

    % Control proxy
    ctrl_efficiency = area / (Ix + Iy + 1e-6);

    % Y skew of P1 VS others
    skew_penalty = std([P1(2), P2(2), P3(2)]);

    % Yaw torque alignment
    yaw_torque_penalty = abs((P1(1)-COG(1)) - (P2(1)-COG(1)) + (P3(1)-COG(1)));

    % Drag risk (X-spread from COG)
    drag_risk_x_spread = std([P1(1), P2(1), P3(1)]);

    % Propellers are too close
    min_spacing = min(spacing);
    overlap_penalty = max(0, 0.3 - min_spacing);  % penalize if props are closer than 0.3m

    % Final weighted score
    score = ...
        1.5 * d_total + ...
        2.0 * symmetry_penalty + ...
        1.2 * cluster_penalty + ...
        2.5 * torque_magnitude + ...
        1.5 * abs(moment_1D) + ...
        1.0 * tri_std + ...
        - 1.0 * area + ...
        1.5 * cog_centroid_offset + ...
        2.0 * inertia_penalty + ...
        1.5 * longest_arm + ...
        - 0.8 * ctrl_efficiency + ...
        1.2 * yaw_torque_penalty + ...
        1.2 * skew_penalty + ...
        1.0 * drag_risk_x_spread + ...
        2.0 * overlap_penalty;
end
