function phi_exact = exact_gauge_wave(grid, params, t)

X = grid.X;
phi_exact = params.amp * sin(params.kx * (X - params.wave_speed * t));

end