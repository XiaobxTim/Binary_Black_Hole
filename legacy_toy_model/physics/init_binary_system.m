function [y0, meta] = init_binary_system(params)
%INIT_BINARY_SYSTEM Initialize the GW150914 binary black hole state
% State vector:
% y = [x1; y1; x2; y2; vx1; vy1; vx2; vy2]

    r1 = params.r1_0(:);
    r2 = params.r2_0(:);

    % In this simplified model, use v = p / m
    v1 = params.p1_0(:) / params.m1;
    v2 = params.p2_0(:) / params.m2;

    state.r1 = r1;
    state.r2 = r2;
    state.v1 = v1;
    state.v2 = v2;

    y0 = state_to_vec(state);

    rel_r = r2 - r1;
    rel_v = v2 - v1;

    meta.initial_separation = norm2d(rel_r);
    meta.initial_relative_speed = norm2d(rel_v);
    meta.initial_center_of_mass = (params.m1 * r1 + params.m2 * r2) / (params.m1 + params.m2);
    meta.initial_total_momentum = params.m1 * v1 + params.m2 * v2;
    meta.spin1 = params.spin1;
    meta.spin2 = params.spin2;
end