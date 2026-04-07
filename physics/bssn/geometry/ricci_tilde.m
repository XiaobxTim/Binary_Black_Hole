function Ric = ricci_tilde(state, geom, params, g)

% Minimal conformal Ricci prototype.
% This version includes:
%   1) the principal second-derivative term
%   2) symmetrized derivative of contracted conformal connection
%
% It is not yet the full nonlinear Ricci tensor.
% But it is the right next step for Phase 3.

[igxx, igxy, igxz, igyy, igyz, igzz] = inverse_metric_3x3( ...
    state.gxx, state.gxy, state.gxz, ...
    state.gyy, state.gyz, state.gzz);

Gc = contracted_conformal_connection(state, geom.GammaTilde);

% derivatives of contracted Gamma^i
Gxg = add_ghosts(Gc.x, g); Gxg = fill_ghosts_scalar(Gxg, g, params.bc_type);
Gyg = add_ghosts(Gc.y, g); Gyg = fill_ghosts_scalar(Gyg, g, params.bc_type);
Gzg = add_ghosts(Gc.z, g); Gzg = fill_ghosts_scalar(Gzg, g, params.bc_type);

dGx_x = ddx4_g(Gxg, g); dGx_y = ddy4_g(Gxg, g); dGx_z = ddz4_g(Gxg, g);
dGy_x = ddx4_g(Gyg, g); dGy_y = ddy4_g(Gyg, g); dGy_z = ddz4_g(Gyg, g);
dGz_x = ddx4_g(Gzg, g); dGz_y = ddy4_g(Gzg, g); dGz_z = ddz4_g(Gzg, g);

% principal term helper:
% gamma^{kl} d_k d_l g_ij
apply_lapl = @(comp) ...
      igxx .* geom.d2g.(comp).xx ...
    + 2*igxy .* geom.d2g.(comp).xy ...
    + 2*igxz .* geom.d2g.(comp).xz ...
    + igyy .* geom.d2g.(comp).yy ...
    + 2*igyz .* geom.d2g.(comp).yz ...
    + igzz .* geom.d2g.(comp).zz;

Ric = struct();

% xx
Ric.xx = -0.5 * apply_lapl('gxx') ...
         + state.gxx .* dGx_x + state.gxy .* dGy_x + state.gxz .* dGz_x;

% xy
Ric.xy = -0.5 * apply_lapl('gxy') ...
         + 0.5 * ( ...
             state.gxx .* dGx_y + state.gxy .* dGy_y + state.gxz .* dGz_y ...
           + state.gxy .* dGx_x + state.gyy .* dGy_x + state.gyz .* dGz_x );

% xz
Ric.xz = -0.5 * apply_lapl('gxz') ...
         + 0.5 * ( ...
             state.gxx .* dGx_z + state.gxy .* dGy_z + state.gxz .* dGz_z ...
           + state.gxz .* dGx_x + state.gyz .* dGy_x + state.gzz .* dGz_x );

% yy
Ric.yy = -0.5 * apply_lapl('gyy') ...
         + state.gxy .* dGx_y + state.gyy .* dGy_y + state.gyz .* dGz_y;

% yz
Ric.yz = -0.5 * apply_lapl('gyz') ...
         + 0.5 * ( ...
             state.gxy .* dGx_z + state.gyy .* dGy_z + state.gyz .* dGz_z ...
           + state.gxz .* dGx_y + state.gyz .* dGy_y + state.gzz .* dGz_y );

% zz
Ric.zz = -0.5 * apply_lapl('gzz') ...
         + state.gxz .* dGx_z + state.gyz .* dGy_z + state.gzz .* dGz_z;

end