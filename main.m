clear; clc; close all;

%% =========================
% Add paths
%% =========================
addpath('config');
addpath('core/grid', 'core/numerics', 'core/io', 'core/utils');
addpath('physics/scalar_wave');
addpath('physics/bssn', 'physics/bssn/geometry');
addpath('diagnostics');
addpath('postprocess');

%% =========================
% 1. Load default params
%% =========================
params = params_default();

%% =========================
% 2. Select case
%% =========================
params.case_name = 'bssn_lapse_perturb_gamma_driver';
% params.case_name = 'bssn_lapse_perturb';
% params.case_name = 'bssn_flat_test';
% params.case_name = 'scalar_wave';
% params.case_name = 'gauge_wave';
% params.case_name = 'convergence';

switch params.case_name
    case 'scalar_wave'
        params = case_scalar_wave(params);

    case 'gauge_wave'
        params = case_gauge_wave(params);

    case 'convergence'
        params = case_convergence(params);

    case 'bssn_flat_test'
        params = case_bssn_flat_test(params);

    case 'bssn_lapse_perturb'
        params = case_bssn_lapse_perturb(params);

    case 'bssn_lapse_perturb_gamma_driver'
        params = case_bssn_lapse_perturb_gamma_driver(params);

    otherwise
        error('Unknown case_name: %s', params.case_name);
end

is_bssn_case = strcmp(params.case_name, 'bssn_flat_test') || ...
               strcmp(params.case_name, 'bssn_lapse_perturb') || ...
               strcmp(params.case_name, 'bssn_lapse_perturb_gamma_driver');

%% =========================
% 3. Special mode: convergence
%% =========================
if strcmp(params.case_name, 'convergence')
    run_convergence_test(params);
    return;
end

%% =========================
% 4. Init grid
%% =========================
g = init_grid(params);

%% =========================
% 5. Prepare output
%% =========================
params.output_dir = make_output_dir(params);

%% =========================
% 6. Setup case
%% =========================
if is_bssn_case
    [state, rhs_handle, diag_handle, post_handle] = setup_bssn_case(params, g);
else
    [state, rhs_handle, diag_handle, post_handle] = setup_case(params, g);
end

%% =========================
% 7. Time integration
%% =========================
Nt = floor(params.t_end / params.dt);
t  = 0.0;

diag.time = zeros(Nt+1, 1);

if is_bssn_case
    diag.detg_err   = zeros(Nt+1, 1);
    diag.trA_err    = zeros(Nt+1, 1);
    diag.alpha_min  = zeros(Nt+1, 1);
    diag.alpha_max  = zeros(Nt+1, 1);
    diag.maxK       = zeros(Nt+1, 1);
    diag.maxA       = zeros(Nt+1, 1);
    diag.maxG       = zeros(Nt+1, 1);
    diag.maxBeta    = zeros(Nt+1, 1);
    diag.maxB       = zeros(Nt+1, 1);
    diag.has_naninf = zeros(Nt+1, 1);
    diag.ham_max = zeros(Nt+1, 1);
    diag.ham_l2  = zeros(Nt+1, 1);
    diag.mom_max = zeros(Nt+1, 1);
    diag.mom_l2  = zeros(Nt+1, 1);
else
    diag.energy = zeros(Nt+1, 1);
    diag.maxabs = zeros(Nt+1, 1);

    if params.store_slices
        phi_slices = zeros(g.Nx, g.Ny, floor(Nt / params.plot_every) + 1);
        slice_id = 1;
        phi_slices(:,:,slice_id) = state.phi(:,:,g.kz_mid);
    end
end

d0 = diag_handle(state, g, params, t);
diag.time(1) = t;

if is_bssn_case
    diag.detg_err(1)   = d0.detg_err;
    diag.trA_err(1)    = d0.trA_err;
    diag.alpha_min(1)  = d0.alpha_min;
    diag.alpha_max(1)  = d0.alpha_max;
    diag.maxK(1)       = d0.maxK;
    diag.maxA(1)       = d0.maxA;
    diag.maxG(1)       = d0.maxG;
    diag.maxBeta(1)    = d0.maxBeta;
    diag.maxB(1)       = d0.maxB;
    diag.has_naninf(1) = d0.has_naninf;
    diag.ham_max(1) = d0.ham_max;
    diag.ham_l2(1)  = d0.ham_l2;
    diag.mom_max(1) = d0.mom_max;
    diag.mom_l2(1)  = d0.mom_l2;
else
    diag.energy(1) = d0.energy;
    diag.maxabs(1) = d0.maxabs;
end

fprintf('Start evolution: case = %s, Nt = %d, dt = %.4e\n', ...
    params.case_name, Nt, params.dt);

for n = 1:Nt
    state = rk4_step(state, t, params.dt, rhs_handle);
    t = t + params.dt;

    if is_bssn_case
        state = enforce_bssn_algebraic_constraints(state, params);
    end

    d = diag_handle(state, g, params, t);
    diag.time(n+1) = t;

    if is_bssn_case
        diag.detg_err(n+1)   = d.detg_err;
        diag.trA_err(n+1)    = d.trA_err;
        diag.alpha_min(n+1)  = d.alpha_min;
        diag.alpha_max(n+1)  = d.alpha_max;
        diag.maxK(n+1)       = d.maxK;
        diag.maxA(n+1)       = d.maxA;
        diag.maxG(n+1)       = d.maxG;
        diag.maxBeta(n+1)    = d.maxBeta;
        diag.maxB(n+1)       = d.maxB;
        diag.has_naninf(n+1) = d.has_naninf;
        diag.ham_max(n+1) = d.ham_max;
        diag.ham_l2(n+1)  = d.ham_l2;
        diag.mom_max(n+1) = d.mom_max;
        diag.mom_l2(n+1)  = d.mom_l2;

        if mod(n, params.print_every) == 0
            fprintf(['step = %6d / %6d, t = %10.4f, detg_err = %.3e, trA_err = %.3e, ' ...
                'ham = %.3e, mom = %.3e, maxK = %.3e, maxA = %.3e, maxG = %.3e, ' ...
                'maxBeta = %.3e, maxB = %.3e, alpha[min,max] = [%.6f, %.6f], naninf = %d\n'], ...
            n, Nt, t, d.detg_err, d.trA_err, d.ham_max, d.mom_max, ...
            d.maxK, d.maxA, d.maxG, d.maxBeta, d.maxB, ...
            d.alpha_min, d.alpha_max, d.has_naninf);
        end
    else
        diag.energy(n+1) = d.energy;
        diag.maxabs(n+1) = d.maxabs;

        if mod(n, params.print_every) == 0
            fprintf('step = %6d / %6d, t = %10.4f, max|phi| = %.6e, E = %.6e\n', ...
                n, Nt, t, d.maxabs, d.energy);
        end

        if params.store_slices && mod(n, params.plot_every) == 0
            slice_id = slice_id + 1;
            phi_slices(:,:,slice_id) = state.phi(:,:,g.kz_mid);
        end
    end
end

fprintf('Evolution done.\n');

%% =========================
% 8. Diagnostics plots
%% =========================
if is_bssn_case
    figure;
    plot(diag.time, diag.detg_err, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('max |det(\gamma~)-1|');
    title([params.case_name ': determinant constraint'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'detg_err_vs_time.png'));

    figure;
    plot(diag.time, diag.trA_err, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('max |tr(A~)|');
    title([params.case_name ': trace-free constraint'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'trA_err_vs_time.png'));

    figure;
    plot(diag.time, diag.alpha_min, 'LineWidth', 1.5); hold on;
    plot(diag.time, diag.alpha_max, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('\alpha');
    title([params.case_name ': lapse range'], 'Interpreter', 'none');
    legend('\alpha_{min}', '\alpha_{max}', 'Location', 'best');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'alpha_range_vs_time.png'));

    figure;
    plot(diag.time, diag.maxK, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('max |K|');
    title([params.case_name ': max |K|'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'maxK_vs_time.png'));

    figure;
    plot(diag.time, diag.maxA, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('max |A~|');
    title([params.case_name ': max |A~|'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'maxA_vs_time.png'));

    figure;
    plot(diag.time, diag.maxG, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('max |\Gamma~|');
    title([params.case_name ': max |\Gamma~|'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'maxG_vs_time.png'));

    figure;
    plot(diag.time, diag.maxBeta, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('max |\beta|');
    title([params.case_name ': max |\beta|'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'maxBeta_vs_time.png'));

    figure;
    plot(diag.time, diag.maxB, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('max |B|');
    title([params.case_name ': max |B|'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'maxB_vs_time.png'));

    figure;
    plot(diag.time, diag.ham_max, 'LineWidth', 1.5);
    xlabel('t'); ylabel('max |H|');
    title([params.case_name ': Hamiltonian constraint (max)'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'ham_max_vs_time.png'));

    figure;
    plot(diag.time, diag.ham_l2, 'LineWidth', 1.5);
    xlabel('t'); ylabel('L2(H)');
    title([params.case_name ': Hamiltonian constraint (L2)'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'ham_l2_vs_time.png'));

    figure;
    plot(diag.time, diag.mom_max, 'LineWidth', 1.5);
    xlabel('t'); ylabel('max |M|');
    title([params.case_name ': Momentum constraint (max)'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'mom_max_vs_time.png'));

    figure;
    plot(diag.time, diag.mom_l2, 'LineWidth', 1.5);
    xlabel('t'); ylabel('L2(M)');
    title([params.case_name ': Momentum constraint (L2)'], 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'mom_l2_vs_time.png'));
else
    figure;
    plot(diag.time, diag.energy, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('Energy');
    title(sprintf('%s: Energy vs Time', params.case_name), 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'energy_vs_time.png'));

    figure;
    plot(diag.time, diag.maxabs, 'LineWidth', 1.5);
    xlabel('t');
    ylabel('max |phi|');
    title(sprintf('%s: Max Norm vs Time', params.case_name), 'Interpreter', 'none');
    grid on;
    saveas(gcf, fullfile(params.output_dir, 'maxabs_vs_time.png'));
end

%% =========================
% 9. Final plot / postprocess
%% =========================
post_handle(state, g, params, t);

%% =========================
% 10. Animation
%% =========================
if ~is_bssn_case
    if params.store_slices
        animate_scalar_slice(phi_slices, g, params);
    end
end

%% =========================
% 11. Save outputs
%% =========================
save(fullfile(params.output_dir, 'run_data.mat'), ...
    'params', 'g', 'diag', 'state', '-v7.3');

fprintf('All outputs saved to: %s\n', params.output_dir);