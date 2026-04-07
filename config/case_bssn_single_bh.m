function params = case_bssn_single_bh(params)

params.case_name = 'bssn_single_bh';

% domain
params.xmin = -8.0; params.xmax = 8.0;
params.ymin = -8.0; params.ymax = 8.0;
params.zmin = -8.0; params.zmax = 8.0;

params.Nx = 64;
params.Ny = 64;
params.Nz = 64;

% 注意：单黑洞不能再用 periodic
params.bc_type = 'copy';   % 先用最简单外边界；后面再换 radiative

dx = (params.xmax - params.xmin) / (params.Nx - 1);
params.dt = 0.20 * params.cfl * dx;
params.t_end = 2.0;

params.store_slices = true;
params.use_ko = false;
params.ko_sigma = 0.0;

params.print_every = 5;
params.plot_every  = 2;

% BH parameters
params.bh_mass = 1.0;
params.bh_eps  = 0.05 * dx;   % puncture regularization for numerics

% gauge
params.gauge_lapse_type = 'one_plus_log';

params.gauge_shift_type = 'gamma_driver_placeholder';

params.mu_lapse = 2.0;
params.mu_B = 0.75;
params.eta_B = 1.0;
params.mu_G = 2.0;

end