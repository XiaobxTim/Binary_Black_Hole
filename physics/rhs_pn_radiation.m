function dy = rhs_pn_radiation(~, y, params)
%RHS_PN_RADIATION
% Newtonian gravity + tangential-dominant damping + weak radial damping

    state = vec_to_state(y);

    r1 = state.r1;
    r2 = state.r2;
    v1 = state.v1;
    v2 = state.v2;

    rel = r2 - r1;
    dist = norm2d(rel);

    % -------------------------
    % Newtonian gravity
    % -------------------------
    eps_reg = 1e-12;
    dist3 = dist^3 + eps_reg;

    a1_newton = params.G * params.m2 * rel / dist3;
    a2_newton = -params.G * params.m1 * rel / dist3;

    % -------------------------
    % Relative velocity decomposition
    % -------------------------
    er = rel / max(dist, 1e-12);
    vrel = v2 - v1;

    vr_rel = dot(vrel, er) * er;   % radial part
    vt_rel = vrel - vr_rel;        % tangential part

    % -------------------------
    % Effective damping strength
    % -------------------------
    gamma0 = params.radiation.gamma0;
    r0     = params.radiation.r0;
    power  = params.radiation.power;

    gamma = gamma0 * (r0 / max(dist, 1e-12))^power;

    % tangential-dominant damping
    gamma_t = gamma;
    gamma_r = 0.15 * gamma;

    % relative damping acceleration
    a_rel_damp = -gamma_t * vt_rel - gamma_r * vr_rel;

    % distribute to two bodies in COM-consistent way
    mtot = params.m1 + params.m2;
    a1_damp = -(params.m2 / mtot) * a_rel_damp;
    a2_damp = +(params.m1 / mtot) * a_rel_damp;

    % -------------------------
    % total acceleration
    % -------------------------
    a1 = a1_newton + a1_damp;
    a2 = a2_newton + a2_damp;

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