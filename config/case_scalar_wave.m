function params = case_scalar_wave(params)

params.case_name = 'scalar_wave';

params.xmin = -10.0; params.xmax = 10.0;
params.ymin = -10.0; params.ymax = 10.0;
params.zmin = -10.0; params.zmax = 10.0;

params.Nx = 80;
params.Ny = 80;
params.Nz = 80;

params.wave_speed = 1.0;
params.amp   = 1.0;
params.sigma = 1.2;
params.x0 = -3.0;
params.y0 =  0.0;
params.z0 =  0.0;
params.kx = 2.0;
params.ky = 0.0;
params.kz = 0.0;

params.bc_type = 'periodic';

if strcmp(params.bc_type, 'periodic')
    dx = (params.xmax - params.xmin) / params.Nx;
else
    dx = (params.xmax - params.xmin) / (params.Nx - 1);
end

params.dt = params.cfl * dx / params.wave_speed;
params.t_end = 8.0;

params.use_ko = true;
params.ko_sigma = 0.02;

params.store_slices = true;

end