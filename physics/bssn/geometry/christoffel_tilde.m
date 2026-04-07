function Gamma = christoffel_tilde(state, d1, params, g)

% Compute conformal Christoffel symbols:
%   Gamma^i_{jk}
%
% Output:
%   Gamma.xxx = Gamma^x_xx
%   Gamma.xxy = Gamma^x_xy
%   ...
%   Gamma.zzz = Gamma^z_zz
%
% Symmetry in lower indices is used, but we store all 18 independent entries:
% x: xx, xy, xz, yy, yz, zz
% y: xx, xy, xz, yy, yz, zz
% z: xx, xy, xz, yy, yz, zz

[igxx, igxy, igxz, igyy, igyz, igzz] = inverse_metric_3x3( ...
    state.gxx, state.gxy, state.gxz, ...
    state.gyy, state.gyz, state.gzz);

% Helper for d_j g_lk
dg = @(comp, dir) d1.(comp).(dir);

% Lowered metric components map:
% (1,1)->gxx, (1,2)->gxy, (1,3)->gxz,
% (2,2)->gyy, (2,3)->gyz, (3,3)->gzz

Gamma = struct();

Gamma.xxx = gamma_component(1,1,1, igxx, igxy, igxz, dg);
Gamma.xxy = gamma_component(1,1,2, igxx, igxy, igxz, dg);
Gamma.xxz = gamma_component(1,1,3, igxx, igxy, igxz, dg);
Gamma.xyy = gamma_component(1,2,2, igxx, igxy, igxz, dg);
Gamma.xyz = gamma_component(1,2,3, igxx, igxy, igxz, dg);
Gamma.xzz = gamma_component(1,3,3, igxx, igxy, igxz, dg);

Gamma.yxx = gamma_component(2,1,1, igxy, igyy, igyz, dg);
Gamma.yxy = gamma_component(2,1,2, igxy, igyy, igyz, dg);
Gamma.yxz = gamma_component(2,1,3, igxy, igyy, igyz, dg);
Gamma.yyy = gamma_component(2,2,2, igxy, igyy, igyz, dg);
Gamma.yyz = gamma_component(2,2,3, igxy, igyy, igyz, dg);
Gamma.yzz = gamma_component(2,3,3, igxy, igyy, igyz, dg);

Gamma.zxx = gamma_component(3,1,1, igxz, igyz, igzz, dg);
Gamma.zxy = gamma_component(3,1,2, igxz, igyz, igzz, dg);
Gamma.zxz = gamma_component(3,1,3, igxz, igyz, igzz, dg);
Gamma.zyy = gamma_component(3,2,2, igxz, igyz, igzz, dg);
Gamma.zyz = gamma_component(3,2,3, igxz, igyz, igzz, dg);
Gamma.zzz = gamma_component(3,3,3, igxz, igyz, igzz, dg);

end

function G = gamma_component(i, j, k, gi1, gi2, gi3, dg)
% i = upper index in {1,2,3}
% j,k = lower indices in {1,2,3}
% gi1,gi2,gi3 are gamma^{i1}, gamma^{i2}, gamma^{i3}
%
% G = 1/2 gamma^{il}( d_j g_lk + d_k g_lj - d_l g_jk )

term_l1 = partial_metric(1, k, dir_char(j), dg) + ...
          partial_metric(1, j, dir_char(k), dg) - ...
          partial_metric(j, k, 'x', dg);

term_l2 = partial_metric(2, k, dir_char(j), dg) + ...
          partial_metric(2, j, dir_char(k), dg) - ...
          partial_metric(j, k, 'y', dg);

term_l3 = partial_metric(3, k, dir_char(j), dg) + ...
          partial_metric(3, j, dir_char(k), dg) - ...
          partial_metric(j, k, 'z', dg);

G = 0.5 * (gi1 .* term_l1 + gi2 .* term_l2 + gi3 .* term_l3);

end

function val = partial_metric(a, b, dirc, dg)
% returns d_(dirc) g_(ab)
comp = metric_name(a, b);
val = dg(comp, dirc);
end

function c = dir_char(idx)
switch idx
    case 1
        c = 'x';
    case 2
        c = 'y';
    case 3
        c = 'z';
    otherwise
        error('Invalid direction index');
end
end

function name = metric_name(a, b)
i = min(a,b);
j = max(a,b);

if i == 1 && j == 1
    name = 'gxx';
elseif i == 1 && j == 2
    name = 'gxy';
elseif i == 1 && j == 3
    name = 'gxz';
elseif i == 2 && j == 2
    name = 'gyy';
elseif i == 2 && j == 3
    name = 'gyz';
elseif i == 3 && j == 3
    name = 'gzz';
else
    error('Invalid metric index pair');
end
end