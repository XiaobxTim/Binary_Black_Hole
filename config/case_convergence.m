function params = case_convergence(params)

params.case_name = 'convergence';

params.conv_compare_case = 'gauge_wave';
params.conv_resolutions = [32, 64, 128, 256];
params.conv_norm_type = 'L2';
params.conv_mode = 'line1d';

params.bc_type = 'periodic';

%% turn KO off for clean order measurement
params.use_ko = false;
params.ko_sigma = 0.0;

params.t_end = 0.5;
params.store_slices = false;

params.print_every = 20;
params.plot_every  = 20;

end