function d = compute_scalar_wave_diag(state, grid, params, t)

phi_g = add_ghosts(state.phi, grid);
phi_g = fill_ghosts_scalar(phi_g, grid, params.bc_type);

phix = ddx4_g(phi_g, grid);
phiy = ddy4_g(phi_g, grid);
phiz = ddz4_g(phi_g, grid);

energy_density = 0.5 * ( ...
    state.pi.^2 + params.wave_speed^2 * (phix.^2 + phiy.^2 + phiz.^2) );

energy = sum(energy_density, 'all') * grid.dx * grid.dy * grid.dz;

d = struct();
d.t = t;
d.energy = energy;
d.maxabs = max(abs(state.phi), [], 'all');

end