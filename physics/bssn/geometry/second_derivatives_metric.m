function d2 = second_derivatives_metric(state, params, g)

% Compute second derivatives of conformal metric components:
% pure second derivatives:
%   dxx, dyy, dzz
% mixed second derivatives:
%   dxy, dxz, dyz
%
% Output example:
%   d2.gxx.xx, d2.gxx.yy, d2.gxx.zz
%   d2.gxx.xy, d2.gxx.xz, d2.gxx.yz

d2 = struct();

names = {'gxx','gxy','gxz','gyy','gyz','gzz'};

for n = 1:numel(names)
    fname = names{n};
    u = state.(fname);

    ug = add_ghosts(u, g);
    ug = fill_ghosts_scalar(ug, g, params.bc_type);

    % pure second derivatives
    d2.(fname).xx = second_xx(ug, g);
    d2.(fname).yy = second_yy(ug, g);
    d2.(fname).zz = second_zz(ug, g);

    % mixed second derivatives
    d2.(fname).xy = mixed_xy(ug, g, params);
    d2.(fname).xz = mixed_xz(ug, g, params);
    d2.(fname).yz = mixed_yz(ug, g, params);
end

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