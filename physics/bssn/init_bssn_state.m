function state = init_bssn_state(g)

z = zeros(g.Nx, g.Ny, g.Nz);

state = struct();

%% conformal factor and conformal metric
state.phi = z;

state.gxx = z; state.gxy = z; state.gxz = z;
state.gyy = z; state.gyz = z; state.gzz = z;

%% trace-free extrinsic curvature
state.Axx = z; state.Axy = z; state.Axz = z;
state.Ayy = z; state.Ayz = z; state.Azz = z;

%% trace K
state.K = z;

%% conformal connection functions
state.Gx = z; state.Gy = z; state.Gz = z;

%% lapse
state.alpha = z;

%% shift
state.betax = z; state.betay = z; state.betaz = z;

%% Gamma-driver auxiliary
state.Bx = z; state.By = z; state.Bz = z;

end