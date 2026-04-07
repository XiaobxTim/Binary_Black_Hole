function run_convergence_test(params)

fprintf('=== Running convergence test ===\n');

params.output_dir = make_output_dir(params);
ensure_output_dir(params.output_dir);

res_list = params.conv_resolutions;
num_runs = numel(res_list);

errors = zeros(num_runs, 1);
dx_list = zeros(num_runs, 1);

for ir = 1:num_runs
    fprintf('\n--- Resolution %d / %d ---\n', ir, num_runs);

    p = params_default();

    switch params.conv_compare_case
        case 'gauge_wave'
            p = case_gauge_wave(p);
        case 'scalar_wave'
            p = case_scalar_wave(p);
        otherwise
            error('Unknown conv_compare_case: %s', params.conv_compare_case);
    end

    %% Override by convergence settings
    p.use_ko = params.use_ko;
    p.ko_sigma = params.ko_sigma;
    p.bc_type = params.bc_type;
    p.t_end = params.t_end;
    p.store_slices = false;

    %% quasi-1D: refine only x
    p.Nx = res_list(ir);
    p.Ny = 8;
    p.Nz = 8;

    if strcmp(p.bc_type, 'periodic')
        dx = (p.xmax - p.xmin) / p.Nx;
    else
        dx = (p.xmax - p.xmin) / (p.Nx - 1);
    end
    p.dt = p.cfl * dx / p.wave_speed;

    g = init_grid(p);
    [state, rhs_handle, ~, ~] = setup_case(p, g);

    Nt = floor(p.t_end / p.dt);
    t = 0.0;

    fprintf('N = (%d,%d,%d), dx = %.8e, dt = %.8e, Nt = %d\n', ...
        p.Nx, p.Ny, p.Nz, g.dx, p.dt, Nt);

    for n = 1:Nt
        state = rk4_step(state, t, p.dt, rhs_handle);
        t = t + p.dt;
    end

    %% Exact solution
    switch p.conv_compare_case
        case 'gauge_wave'
            phi_exact = exact_gauge_wave(g, p, t);
        otherwise
            error('Exact solution not implemented for %s', p.conv_compare_case);
    end

    %% Compare only along the center line
    iy = g.iy_mid;
    kz = g.kz_mid;

    num_line = state.phi(:, iy, kz);
    ex_line  = phi_exact(:, iy, kz);
    err_line = num_line - ex_line;

    switch params.conv_norm_type
        case 'L2'
            errors(ir) = sqrt(sum(err_line(:).^2) * g.dx);
        case 'Linf'
            errors(ir) = max(abs(err_line));
        otherwise
            error('Unknown conv_norm_type: %s', params.conv_norm_type);
    end

    dx_list(ir) = g.dx;

    fprintf('Final time = %.8f, error = %.8e\n', t, errors(ir));
end

%% Observed order
orders = nan(num_runs-1, 1);
for i = 1:num_runs-1
    orders(i) = log(errors(i) / errors(i+1)) / log(dx_list(i) / dx_list(i+1));
end

fprintf('\n=== Quasi-1D convergence summary ===\n');
disp(table(res_list(:), dx_list(:), errors(:), ...
    'VariableNames', {'Nx', 'dx', 'Error'}));

if ~isempty(orders)
    disp(table((1:numel(orders))', orders, ...
        'VariableNames', {'PairIndex', 'ObservedOrder'}));
end

%% Plot
figure;
loglog(dx_list, errors, '-o', 'LineWidth', 1.5);
xlabel('\Deltax');
ylabel([params.conv_norm_type ' error (center line)']);
title('Quasi-1D convergence test');
set(gca, 'XGrid', 'on', 'YGrid', 'on', 'ZGrid', 'on');
saveas(gcf, fullfile(params.output_dir, 'convergence_error.png'));

%% Save summary
fid = fopen(fullfile(params.output_dir, 'convergence_summary.txt'), 'w');
fprintf(fid, 'Quasi-1D convergence test summary\n');
fprintf(fid, 'compare_case = %s\n', params.conv_compare_case);
fprintf(fid, 'norm = %s\n', params.conv_norm_type);
fprintf(fid, 'mode = line1d\n\n');

fprintf(fid, '%8s %16s %16s\n', 'Nx', 'dx', 'Error');
for i = 1:num_runs
    fprintf(fid, '%8d %16.8e %16.8e\n', res_list(i), dx_list(i), errors(i));
end

fprintf(fid, '\nObserved orders:\n');
for i = 1:numel(orders)
    fprintf(fid, 'pair %d -> %d : %.6f\n', i, i+1, orders(i));
end
fclose(fid);

fprintf('Convergence outputs saved to: %s\n', params.output_dir);

end