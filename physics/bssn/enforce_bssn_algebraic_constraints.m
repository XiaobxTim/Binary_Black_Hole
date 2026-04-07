function state = enforce_bssn_algebraic_constraints(state, params)

% determinant normalization of conformal metric
detg = det_metric_3x3(state.gxx, state.gxy, state.gxz, ...
                      state.gyy, state.gyz, state.gzz);

% avoid bad values
detg = max(detg, 1e-14);

scale = detg.^(-1/3);

state.gxx = state.gxx .* scale;
state.gxy = state.gxy .* scale;
state.gxz = state.gxz .* scale;
state.gyy = state.gyy .* scale;
state.gyz = state.gyz .* scale;
state.gzz = state.gzz .* scale;

% make A trace-free with respect to conformal metric
[state.Axx, state.Axy, state.Axz, ...
 state.Ayy, state.Ayz, state.Azz] = trace_free_A( ...
    state.Axx, state.Axy, state.Axz, ...
    state.Ayy, state.Ayz, state.Azz, ...
    state.gxx, state.gxy, state.gxz, ...
    state.gyy, state.gyz, state.gzz);

end