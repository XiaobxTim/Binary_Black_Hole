function state = bssn_lapse_perturb_initial_data(params, g)

state = init_bssn_state(g);

%% Flat conformal background
state.phi(:) = 0.0;

state.gxx(:) = 1.0;
state.gxy(:) = 0.0;
state.gxz(:) = 0.0;
state.gyy(:) = 1.0;
state.gyz(:) = 0.0;
state.gzz(:) = 1.0;

state.Axx(:) = 0.0;
state.Axy(:) = 0.0;
state.Axz(:) = 0.0;
state.Ayy(:) = 0.0;
state.Ayz(:) = 0.0;
state.Azz(:) = 0.0;

state.K(:) = 0.0;

state.Gx(:) = 0.0;
state.Gy(:) = 0.0;
state.Gz(:) = 0.0;

%% Lapse perturbation
r2 = g.X.^2 + g.Y.^2 + g.Z.^2;
state.alpha = 1.0 + params.alpha_pert_amp * exp(-r2 / (2 * params.alpha_pert_sigma^2));

%% Shift / driver
state.betax(:) = 0.0;
state.betay(:) = 0.0;
state.betaz(:) = 0.0;

state.Bx(:) = 0.0;
state.By(:) = 0.0;
state.Bz(:) = 0.0;

state = enforce_bssn_algebraic_constraints(state, params);

end