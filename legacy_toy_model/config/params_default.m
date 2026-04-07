function params = params_default()
%PARAMS_DEFAULT Default parameters for GW150914-inspired binary black hole demo

    % =========================
    % Case info
    % =========================
    params.case_name = 'GW150914';
    params.description = 'binary black hole evolution demo';

    % =========================
    % Physical parameters
    % =========================
    % Normalized total mass M = 1
    params.m1 = 36 / (36 + 29);
    params.m2 = 29 / (36 + 29);
    params.M  = params.m1 + params.m2;
    params.G  = 1.0;

    % Spins (stored for metadata only in V1)
    params.spin1 = [0.0; 0.0;  0.31];
    params.spin2 = [0.0; 0.0; -0.46];
    params.use_spin = false;

    % =========================
    % Initial positions from the provided GW150914 setup
    % =========================
    params.r1_0 = [0.0;  10.0 * 29.0/(36.0+29.0)];
    params.r2_0 = [0.0; -10.0 * 36.0/(36.0+29.0)];

    % Initial momenta from the provided GW150914 setup
    params.p1_0 = [-0.09530152296974252; -0.00084541526517121];
    params.p2_0 = [+0.09530152296974252; +0.00084541526517121];

    % =========================
    % Time evolution parameters
    % =========================
    params.t0 = 0.0;
    params.t_end = 1500.0;

    % Start with a moderate dt; adjust later if needed
    params.dt = 0.02;
    params.max_steps = 200000;

    % =========================
    % Stop condition parameters
    % =========================
    params.r_merge = 0.30;

    % =========================
    % Output / saving
    % =========================
    params.save_every = 10;
    params.output_root = 'output';

    % =========================
    % Model switch
    % =========================
    params.use_radiation = true;

    % =========================
    % Effective radiation parameters
    % =========================
    params.radiation.gamma0 = 3e-5;
    params.radiation.r0     = 10.0;
    params.radiation.power  = 4.0;
end