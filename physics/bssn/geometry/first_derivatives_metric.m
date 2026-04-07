function d1 = first_derivatives_metric(state, params, g)

% Compute first derivatives of conformal metric components:
% gxx, gxy, gxz, gyy, gyz, gzz
%
% Output structure fields:
%   d1.gxx.x, d1.gxx.y, d1.gxx.z
%   ...
%   d1.gzz.x, d1.gzz.y, d1.gzz.z

d1 = struct();

names = {'gxx','gxy','gxz','gyy','gyz','gzz'};

for n = 1:numel(names)
    fname = names{n};
    u = state.(fname);

    ug = add_ghosts(u, g);
    ug = fill_ghosts_scalar(ug, g, params.bc_type);

    d1.(fname).x = ddx4_g(ug, g);
    d1.(fname).y = ddy4_g(ug, g);
    d1.(fname).z = ddz4_g(ug, g);
end

end