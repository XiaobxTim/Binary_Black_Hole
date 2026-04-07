function params = params_default()

params = struct();

%% Case
params.case_name = 'scalar_wave';

%% Domain
params.xmin = -10.0; params.xmax = 10.0;
params.ymin = -10.0; params.ymax = 10.0;
params.zmin = -10.0; params.zmax = 10.0;

params.Nx = 64;
params.Ny = 64;
params.Nz = 64;

%% Ghost zones
params.ng = 3;

%% Time
params.cfl   = 0.20;
params.t_end = 8.0;
params.dt    = [];

%% Boundary
params.bc_type = 'periodic';

%% KO dissipation
params.use_ko   = true;
params.ko_sigma = 0.02;

%% Wave parameters
params.wave_speed = 1.0;
params.amp   = 1.0;
params.sigma = 1.2;
params.x0 = -3.0;
params.y0 =  0.0;
params.z0 =  0.0;
params.kx = 2.0;
params.ky = 0.0;
params.kz = 0.0;

%% Output
params.output_root = 'output';
params.output_dir  = '';
params.print_every = 10;
params.plot_every  = 5;
params.store_slices = true;

%% Convergence settings
params.conv_resolutions = [24, 48, 96];
params.conv_compare_case = 'gauge_wave';
params.conv_norm_type = 'L2';

%% BSSN gauge parameters
params.gauge_lapse_type = 'one_plus_log';
params.gauge_shift_type = 'frozen';

% 1+log coefficient:
% dt alpha = -mu_lapse * alpha * K
params.mu_lapse = 2.0;

% Gamma-driver prototype parameters (reserved for later)
params.eta_B = 1.0;
params.mu_B  = 0.75;
params.mu_G = 1.0;

end