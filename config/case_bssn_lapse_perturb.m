function params = case_bssn_lapse_perturb(params)

params.case_name = 'bssn_lapse_perturb';

params.xmin = -1.0; params.xmax = 1.0;
params.ymin = -1.0; params.ymax = 1.0;
params.zmin = -1.0; params.zmax = 1.0;

params.Nx = 32;
params.Ny = 32;
params.Nz = 32;

params.bc_type = 'periodic';

if strcmp(params.bc_type, 'periodic')
    dx = (params.xmax - params.xmin) / params.Nx;
else
    dx = (params.xmax - params.xmin) / (params.Nx - 1);
end

params.dt = 0.5 * params.cfl * dx;
params.t_end = 0.20;

params.store_slices = false;
params.use_ko = false;
params.ko_sigma = 0.0;

params.print_every = 2;
params.plot_every  = 2;

% perturbation parameters
params.alpha_pert_amp = 1e-4;
params.alpha_pert_sigma = 0.20;

params.gauge_lapse_type = 'one_plus_log';
params.gauge_shift_type = 'frozen';
params.mu_lapse = 2.0;

end