function rhs = bssn_rhs_connection_part(rhs, state, geom, params, g)

% -------------------------------------------------
% Minimal nontrivial Gamma^i evolution prototype:
%
% dt Gamma^i ~ -2 A^{ij} d_j alpha
%              + 2 alpha ( Gamma^i_jk A^{jk}
%                          - (2/3) gamma^{ij} d_j K )
%
% This is not the full BSSN Gamma-driver / full Gamma evolution.
% It is a clean next step beyond a zero placeholder.
% -------------------------------------------------

alpha = state.alpha;

igxx = geom.igxx; igxy = geom.igxy; igxz = geom.igxz;
igyy = geom.igyy; igyz = geom.igyz; igzz = geom.igzz;

Aup = geom.Aup;

dax = geom.dalpha_x;
day = geom.dalpha_y;
daz = geom.dalpha_z;

dKx = geom.gradK.x;
dKy = geom.gradK.y;
dKz = geom.gradK.z;

G = geom.GammaTilde;

%% ---- first term: -2 A^{ij} d_j alpha ----
T1x = -2 * (Aup.xx .* dax + Aup.xy .* day + Aup.xz .* daz);
T1y = -2 * (Aup.xy .* dax + Aup.yy .* day + Aup.yz .* daz);
T1z = -2 * (Aup.xz .* dax + Aup.yz .* day + Aup.zz .* daz);

%% ---- second term: 2 alpha * Gamma^i_jk A^{jk} ----
GammaA_x = G.xxx .* Aup.xx + 2*G.xxy .* Aup.xy + 2*G.xxz .* Aup.xz ...
         + G.xyy .* Aup.yy + 2*G.xyz .* Aup.yz + G.xzz .* Aup.zz;

GammaA_y = G.yxx .* Aup.xx + 2*G.yxy .* Aup.xy + 2*G.yxz .* Aup.xz ...
         + G.yyy .* Aup.yy + 2*G.yyz .* Aup.yz + G.yzz .* Aup.zz;

GammaA_z = G.zxx .* Aup.xx + 2*G.zxy .* Aup.xy + 2*G.zxz .* Aup.xz ...
         + G.zyy .* Aup.yy + 2*G.zyz .* Aup.yz + G.zzz .* Aup.zz;

%% ---- third term: -(4/3) alpha gamma^{ij} d_j K ----
gradK_x = igxx .* dKx + igxy .* dKy + igxz .* dKz;
gradK_y = igxy .* dKx + igyy .* dKy + igyz .* dKz;
gradK_z = igxz .* dKx + igyz .* dKy + igzz .* dKz;

T3x = -(4/3) * alpha .* gradK_x;
T3y = -(4/3) * alpha .* gradK_y;
T3z = -(4/3) * alpha .* gradK_z;

%% ---- combine ----
rhs.Gx = T1x + 2 * alpha .* GammaA_x + T3x;
rhs.Gy = T1y + 2 * alpha .* GammaA_y + T3y;
rhs.Gz = T1z + 2 * alpha .* GammaA_z + T3z;

end