function geom = build_bssn_geometry_cache(state, params, g)

geom = struct();

%% Basic conformal metric quantities
geom.detg = det_metric_3x3( ...
    state.gxx, state.gxy, state.gxz, ...
    state.gyy, state.gyz, state.gzz);

[geom.igxx, geom.igxy, geom.igxz, ...
 geom.igyy, geom.igyz, geom.igzz] = inverse_metric_3x3( ...
    state.gxx, state.gxy, state.gxz, ...
    state.gyy, state.gyz, state.gzz);

%% trace of A with respect to conformal metric
geom.trA = geom.igxx .* state.Axx ...
         + 2*geom.igxy .* state.Axy ...
         + 2*geom.igxz .* state.Axz ...
         + geom.igyy .* state.Ayy ...
         + 2*geom.igyz .* state.Ayz ...
         + geom.igzz .* state.Azz;

%% Scalar field derivatives
alpha_g = add_ghosts(state.alpha, g);
phi_g   = add_ghosts(state.phi, g);

alpha_g = fill_ghosts_scalar(alpha_g, g, params.bc_type);
phi_g   = fill_ghosts_scalar(phi_g,   g, params.bc_type);

geom.dalpha_x = ddx4_g(alpha_g, g);
geom.dalpha_y = ddy4_g(alpha_g, g);
geom.dalpha_z = ddz4_g(alpha_g, g);

geom.dphi_x = ddx4_g(phi_g, g);
geom.dphi_y = ddy4_g(phi_g, g);
geom.dphi_z = ddz4_g(phi_g, g);

geom.lap_alpha = laplacian4_g(alpha_g, g);

%% Metric derivatives and Christoffel symbols
geom.d1g = first_derivatives_metric(state, params, g);
geom.d2g = second_derivatives_metric(state, params, g);
geom.GammaTilde = christoffel_tilde(state, geom.d1g, params, g);

geom.GammaContr = contracted_conformal_connection(state, geom.GammaTilde);
geom.RicciTilde = ricci_tilde(state, geom, params, g);

%% Additional fields for RHS pieces
geom.gradK = gradient_scalar_field(state.K, params, g);
geom.Aup = contract_A_upper(state);

end