function state = scalar_wave_initial_data(params, grid)

X = grid.X;
Y = grid.Y;
Z = grid.Z;

r2 = (X - params.x0).^2 + (Y - params.y0).^2 + (Z - params.z0).^2;
envelope = params.amp * exp(-r2 / (2 * params.sigma^2));
phase    = params.kx * X + params.ky * Y + params.kz * Z;

phi0 = envelope .* cos(phase);

% 初始朝 +x 传播
dphix = envelope .* (-params.kx .* sin(phase)) ...
      + cos(phase) .* envelope .* (-(X - params.x0) / (params.sigma^2));

pi0 = -params.wave_speed * dphix;

state = struct();
state.phi = phi0;
state.pi  = pi0;

end