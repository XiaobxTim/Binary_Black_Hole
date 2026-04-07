function state = bssn_single_bh_puncture_initial_data(params, g)

state = init_bssn_state(g);

[X, Y, Z] = ndgrid(g.x, g.y, g.z);

M   = params.bh_mass;
eps = params.bh_eps;

r = sqrt(X.^2 + Y.^2 + Z.^2 + eps^2);

% conformal factor psi and phi = ln(psi)
psi = 1.0 + M ./ (2.0 * r);
state.phi = log(psi);

% conformal metric = identity
state.gxx(:) = 1.0;
state.gxy(:) = 0.0;
state.gxz(:) = 0.0;
state.gyy(:) = 1.0;
state.gyz(:) = 0.0;
state.gzz(:) = 1.0;

% time-symmetric initial data
state.K(:)   = 0.0;
state.Axx(:) = 0.0;
state.Axy(:) = 0.0;
state.Axz(:) = 0.0;
state.Ayy(:) = 0.0;
state.Ayz(:) = 0.0;
state.Azz(:) = 0.0;

state.Gx(:) = 0.0;
state.Gy(:) = 0.0;
state.Gz(:) = 0.0;

% pre-collapsed lapse
state.alpha = psi.^(-2);

% zero shift / driver aux
state.betax(:) = 0.0;
state.betay(:) = 0.0;
state.betaz(:) = 0.0;

state.Bx(:) = 0.0;
state.By(:) = 0.0;
state.Bz(:) = 0.0;

state = enforce_bssn_algebraic_constraints(state, params);

end