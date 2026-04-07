function state = gauge_wave_initial_data(params, grid)

X = grid.X;

phi0 = params.amp * sin(params.kx * X);
pi0  = -params.wave_speed * params.amp * params.kx * cos(params.kx * X);

state = struct();
state.phi = phi0;
state.pi  = pi0;

end