function rhs = scalar_wave_rhs(state, ~, params, grid)

phi_g = add_ghosts(state.phi, grid);
pi_g  = add_ghosts(state.pi,  grid);

phi_g = fill_ghosts_scalar(phi_g, grid, params.bc_type);
pi_g  = fill_ghosts_scalar(pi_g,  grid, params.bc_type);

rhs = struct();
rhs.phi = strip_ghosts(pi_g, grid);
rhs.pi  = params.wave_speed^2 * laplacian4_g(phi_g, grid);

if params.use_ko
    rhs.phi = rhs.phi + ko_dissipation_3d(phi_g, grid, params.ko_sigma);
    rhs.pi  = rhs.pi  + ko_dissipation_3d(pi_g,  grid, params.ko_sigma);
end

end