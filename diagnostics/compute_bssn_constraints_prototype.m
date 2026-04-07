function cons = compute_bssn_constraints_prototype(state, geom, params, g)

% -------------------------------------------------
% Prototype BSSN constraints
%
% Hamiltonian prototype:
%   H ~ Rtilde - Aij A^ij + (2/3) K^2
%
% Momentum prototype:
%   Mi ~ d_j A^{ij} - (2/3) d^i K
%
% This is not yet the full conformal-BSSN constraint system,
% but it is a strong next diagnostic step.
% -------------------------------------------------

cons = struct();

%% ---- Ricci scalar from RicciTilde ----
igxx = geom.igxx; igxy = geom.igxy; igxz = geom.igxz;
igyy = geom.igyy; igyz = geom.igyz; igzz = geom.igzz;

Rtilde = igxx .* geom.RicciTilde.xx ...
       + 2*igxy .* geom.RicciTilde.xy ...
       + 2*igxz .* geom.RicciTilde.xz ...
       + igyy .* geom.RicciTilde.yy ...
       + 2*igyz .* geom.RicciTilde.yz ...
       + igzz .* geom.RicciTilde.zz;

%% ---- Aij A^ij ----
Aup = geom.Aup;

A2 = state.Axx .* Aup.xx ...
   + 2*state.Axy .* Aup.xy ...
   + 2*state.Axz .* Aup.xz ...
   + state.Ayy .* Aup.yy ...
   + 2*state.Ayz .* Aup.yz ...
   + state.Azz .* Aup.zz;

%% ---- Hamiltonian prototype ----
cons.H = Rtilde - A2 + (2/3) * state.K.^2;

%% ---- Momentum prototype ----
% Need divergence of A^{ij}
Axx_g = add_ghosts(Aup.xx, g); Axx_g = fill_ghosts_scalar(Axx_g, g, params.bc_type);
Axy_g = add_ghosts(Aup.xy, g); Axy_g = fill_ghosts_scalar(Axy_g, g, params.bc_type);
Axz_g = add_ghosts(Aup.xz, g); Axz_g = fill_ghosts_scalar(Axz_g, g, params.bc_type);
Ayy_g = add_ghosts(Aup.yy, g); Ayy_g = fill_ghosts_scalar(Ayy_g, g, params.bc_type);
Ayz_g = add_ghosts(Aup.yz, g); Ayz_g = fill_ghosts_scalar(Ayz_g, g, params.bc_type);
Azz_g = add_ghosts(Aup.zz, g); Azz_g = fill_ghosts_scalar(Azz_g, g, params.bc_type);

dAxx_dx = ddx4_g(Axx_g, g);
dAxy_dy = ddy4_g(Axy_g, g);
dAxz_dz = ddz4_g(Axz_g, g);

dAxy_dx = ddx4_g(Axy_g, g);
dAyy_dy = ddy4_g(Ayy_g, g);
dAyz_dz = ddz4_g(Ayz_g, g);

dAxz_dx = ddx4_g(Axz_g, g);
dAyz_dy = ddy4_g(Ayz_g, g);
dAzz_dz = ddz4_g(Azz_g, g);

% raised gradient of K
dKx = geom.gradK.x;
dKy = geom.gradK.y;
dKz = geom.gradK.z;

gradKx_up = igxx .* dKx + igxy .* dKy + igxz .* dKz;
gradKy_up = igxy .* dKx + igyy .* dKy + igyz .* dKz;
gradKz_up = igxz .* dKx + igyz .* dKy + igzz .* dKz;

cons.Mx = dAxx_dx + dAxy_dy + dAxz_dz - (2/3) * gradKx_up;
cons.My = dAxy_dx + dAyy_dy + dAyz_dz - (2/3) * gradKy_up;
cons.Mz = dAxz_dx + dAyz_dy + dAzz_dz - (2/3) * gradKz_up;

end