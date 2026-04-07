function rhs = bssn_rhs_curvature_part(rhs, state, geom, params, g)

% -------------------------------------------------
% Minimal curvature evolution prototype
%
% dt K      = - Delta alpha
% dt A_tilde_ij  ~=  [ - D_i D_j alpha + alpha * RicciTilde_ij ]^TF
%
% Current simplification:
%   - use plain second partial derivatives of alpha
%   - use conformal Ricci prototype from geometry cache
%   - then take trace-free part with respect to conformal metric
%
% This is not yet the full BSSN curvature sector,
% but it is the right next step beyond placeholder.
% -------------------------------------------------

%% --- second derivatives of alpha ---
alpha_g = add_ghosts(state.alpha, g);
alpha_g = fill_ghosts_scalar(alpha_g, g, params.bc_type);

a_xx = second_xx(alpha_g, g);
a_yy = second_yy(alpha_g, g);
a_zz = second_zz(alpha_g, g);

a_xy = mixed_xy(alpha_g, g, params);
a_xz = mixed_xz(alpha_g, g, params);
a_yz = mixed_yz(alpha_g, g, params);

%% --- K evolution ---
rhs.K = -geom.lap_alpha;

%% --- raw A_ij RHS before trace-free projection ---
Sxx = -a_xx + state.alpha .* geom.RicciTilde.xx;
Sxy = -a_xy + state.alpha .* geom.RicciTilde.xy;
Sxz = -a_xz + state.alpha .* geom.RicciTilde.xz;
Syy = -a_yy + state.alpha .* geom.RicciTilde.yy;
Syz = -a_yz + state.alpha .* geom.RicciTilde.yz;
Szz = -a_zz + state.alpha .* geom.RicciTilde.zz;

%% --- make it trace-free with respect to conformal metric ---
[rhs.Axx, rhs.Axy, rhs.Axz, ...
 rhs.Ayy, rhs.Ayz, rhs.Azz] = trace_free_A( ...
    Sxx, Sxy, Sxz, Syy, Syz, Szz, ...
    state.gxx, state.gxy, state.gxz, ...
    state.gyy, state.gyz, state.gzz);

end

function uxx = second_xx(ug, g)
uxx = ( ...
    -ug(g.i1+2:g.i2+2, g.j1:g.j2, g.k1:g.k2) ...
    +16*ug(g.i1+1:g.i2+1, g.j1:g.j2, g.k1:g.k2) ...
    -30*ug(g.i1:g.i2,     g.j1:g.j2, g.k1:g.k2) ...
    +16*ug(g.i1-1:g.i2-1, g.j1:g.j2, g.k1:g.k2) ...
    -ug(g.i1-2:g.i2-2,    g.j1:g.j2, g.k1:g.k2) ) / (12*g.dx^2);
end

function uyy = second_yy(ug, g)
uyy = ( ...
    -ug(g.i1:g.i2, g.j1+2:g.j2+2, g.k1:g.k2) ...
    +16*ug(g.i1:g.i2, g.j1+1:g.j2+1, g.k1:g.k2) ...
    -30*ug(g.i1:g.i2, g.j1:g.j2,     g.k1:g.k2) ...
    +16*ug(g.i1:g.i2, g.j1-1:g.j2-1, g.k1:g.k2) ...
    -ug(g.i1:g.i2, g.j1-2:g.j2-2,    g.k1:g.k2) ) / (12*g.dy^2);
end

function uzz = second_zz(ug, g)
uzz = ( ...
    -ug(g.i1:g.i2, g.j1:g.j2, g.k1+2:g.k2+2) ...
    +16*ug(g.i1:g.i2, g.j1:g.j2, g.k1+1:g.k2+1) ...
    -30*ug(g.i1:g.i2, g.j1:g.j2, g.k1:g.k2) ...
    +16*ug(g.i1:g.i2, g.j1:g.j2, g.k1-1:g.k2-1) ...
    -ug(g.i1:g.i2, g.j1:g.j2, g.k1-2:g.k2-2) ) / (12*g.dz^2);
end

function uxy = mixed_xy(ug, g, params)
ux = ddx4_g(ug, g);
uxg = add_ghosts(ux, g);
uxg = fill_ghosts_scalar(uxg, g, params.bc_type);
uxy = ddy4_g(uxg, g);
end

function uxz = mixed_xz(ug, g, params)
ux = ddx4_g(ug, g);
uxg = add_ghosts(ux, g);
uxg = fill_ghosts_scalar(uxg, g, params.bc_type);
uxz = ddz4_g(uxg, g);
end

function uyz = mixed_yz(ug, g, params)
uy = ddy4_g(ug, g);
uyg = add_ghosts(uy, g);
uyg = fill_ghosts_scalar(uyg, g, params.bc_type);
uyz = ddz4_g(uyg, g);
end