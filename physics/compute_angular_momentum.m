function angmom = compute_angular_momentum(y_hist, params)
%COMPUTE_ANGULAR_MOMENTUM Compute z-component of angular momentum history

    n = size(y_hist, 1);
    Lz = zeros(n, 1);

    for i = 1:n
        y = y_hist(i, :).';
        state = vec_to_state(y);

        r1 = state.r1;
        r2 = state.r2;
        v1 = state.v1;
        v2 = state.v2;

        L1z = params.m1 * (r1(1) * v1(2) - r1(2) * v1(1));
        L2z = params.m2 * (r2(1) * v2(2) - r2(2) * v2(1));

        Lz(i) = L1z + L2z;
    end

    L0 = Lz(1);
    relative_change = (Lz - L0) / max(abs(L0), 1e-14);

    angmom.Lz = Lz;
    angmom.relative_change = relative_change;
end