function energy = compute_energy(y_hist, params)
%COMPUTE_ENERGY Compute kinetic, potential, and total energy history

    n = size(y_hist, 1);

    kinetic   = zeros(n, 1);
    potential = zeros(n, 1);
    total     = zeros(n, 1);

    for i = 1:n
        y = y_hist(i, :).';
        state = vec_to_state(y);

        r1 = state.r1;
        r2 = state.r2;
        v1 = state.v1;
        v2 = state.v2;

        rel = r2 - r1;
        dist = norm2d(rel);

        kinetic(i) = 0.5 * params.m1 * dot(v1, v1) + ...
                     0.5 * params.m2 * dot(v2, v2);

        potential(i) = -params.G * params.m1 * params.m2 / max(dist, 1e-12);

        total(i) = kinetic(i) + potential(i);
    end

    E0 = total(1);
    relative_change = (total - E0) / max(abs(E0), 1e-14);

    energy.kinetic = kinetic;
    energy.potential = potential;
    energy.total = total;
    energy.relative_change = relative_change;
end