function params = case_gauge_wave(params)

params.case_name = 'gauge_wave';

%% Quasi-1D periodic domain
params.xmin = -1.0; params.xmax = 1.0;
params.ymin = -0.1; params.ymax = 0.1;
params.zmin = -0.1; params.zmax = 0.1;

params.Nx = 96;
params.Ny = 8;
params.Nz = 8;

params.wave_speed = 1.0;
params.amp = 1.0e-3;

%% One clean periodic mode over the domain
Lx = params.xmax - params.xmin;
params.kx = 2*pi / Lx;   % = pi for [-1,1]
params.ky = 0.0;
params.kz = 0.0;

%% Unused by this case, kept for compatibility
params.sigma = 0.25;
params.x0 = 0.0;
params.y0 = 0.0;
params.z0 = 0.0;

params.bc_type = 'periodic';

if strcmp(params.bc_type, 'periodic')
    dx = (params.xmax - params.xmin) / params.Nx;
else
    dx = (params.xmax - params.xmin) / (params.Nx - 1);
end

params.dt = params.cfl * dx / params.wave_speed;
params.t_end = 0.5;

%% For convergence, turn KO off first
params.use_ko = false;
params.ko_sigma = 0.0;

params.store_slices = true;

end