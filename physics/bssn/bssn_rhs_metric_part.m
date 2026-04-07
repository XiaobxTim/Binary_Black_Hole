function rhs = bssn_rhs_metric_part(rhs, state, geom, params, g)

% Minimal BSSN-inspired structure:
% dt phi = -alpha K / 6
rhs.phi = -(1/6) * state.alpha .* state.K;

% dt gamma_tilde_ij = -2 alpha A_tilde_ij
rhs.gxx = -2 * state.alpha .* state.Axx;
rhs.gxy = -2 * state.alpha .* state.Axy;
rhs.gxz = -2 * state.alpha .* state.Axz;
rhs.gyy = -2 * state.alpha .* state.Ayy;
rhs.gyz = -2 * state.alpha .* state.Ayz;
rhs.gzz = -2 * state.alpha .* state.Azz;

end