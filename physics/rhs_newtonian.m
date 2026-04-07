function dy = rhs_newtonian(~, y, params)
%RHS_NEWTONIAN Newtonian two-body RHS for binary black hole toy model

    state = vec_to_state(y);

    r1 = state.r1;
    r2 = state.r2;
    v1 = state.v1;
    v2 = state.v2;

    rel = r2 - r1;
    dist = norm2d(rel);

    % Avoid singularity
    eps_reg = 1e-12;
    dist3 = (dist^3 + eps_reg);

    a1 = params.G * params.m2 * rel / dist3;
    a2 = -params.G * params.m1 * rel / dist3;

    dy = [
        v1(1);
        v1(2);
        v2(1);
        v2(2);
        a1(1);
        a1(2);
        a2(1);
        a2(2)
    ];
end