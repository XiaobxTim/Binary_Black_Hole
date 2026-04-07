clear; clc; close all;

% =========================
% Add paths
% =========================
addpath('config', 'physics', 'numerics', 'postprocess', 'utils');

% =========================
% Load parameters
% =========================
params = params_default();

% =========================
% Create output folders
% =========================
if ~exist('output', 'dir')
    mkdir('output');
end
if ~exist(fullfile('output','figures'), 'dir')
    mkdir(fullfile('output','figures'));
end
if ~exist(fullfile('output','data'), 'dir')
    mkdir(fullfile('output','data'));
end
if ~exist(fullfile('output','video'), 'dir')
    mkdir(fullfile('output','video'));
end

% =========================
% Initialize GW150914 system
% =========================
[y0, meta] = init_binary_system(params);

fprintf('=== Binary Black Hole MATLAB Demo ===\n');
fprintf('Case: %s\n', params.case_name);
fprintf('Initial separation = %.6f\n', meta.initial_separation);
fprintf('m1 = %.6f, m2 = %.6f\n', params.m1, params.m2);

% =========================
% Select RHS
% =========================
if params.use_radiation
    rhs_handle = @rhs_pn_radiation;
else
    rhs_handle = @rhs_newtonian;
end

% =========================
% Run time evolution
% =========================
[t_hist, y_hist, diag] = ode_driver(rhs_handle, y0, params);

fprintf('Simulation finished.\n');
fprintf('Stop reason      : %s\n', diag.stop_reason);
fprintf('Saved steps      : %d\n', length(t_hist));
fprintf('Actual end time  : %.6f\n', diag.final_time);
fprintf('Final separation : %.6f\n', diag.final_separation);
fprintf('CPU time         : %.6f s\n', diag.cpu_time);

% =========================
% Diagnostics
% =========================
energy = compute_energy(y_hist, params);
angmom = compute_angular_momentum(y_hist, params);

fprintf('Initial total energy      : %.12e\n', energy.total(1));
fprintf('Final total energy        : %.12e\n', energy.total(end));
fprintf('Final relative E change   : %.12e\n', energy.relative_change(end));
fprintf('Max |relative E change|   : %.12e\n', max(abs(energy.relative_change)));

fprintf('Initial angular momentum  : %.12e\n', angmom.Lz(1));
fprintf('Final angular momentum    : %.12e\n', angmom.Lz(end));
fprintf('Final relative Lz change  : %.12e\n', angmom.relative_change(end));
fprintf('Max |relative Lz change|  : %.12e\n', max(abs(angmom.relative_change)));

% =========================
% Plots
% =========================
fig_traj = plot_trajectory(t_hist, y_hist, params);
fig_sep = plot_separation(t_hist, y_hist, params);
fig_sep_peaks = plot_separation_peaks(t_hist, y_hist, params);
fig_rel = plot_relative_trajectory(y_hist, params);
figs_energy = plot_energy(t_hist, energy, params);

% =========================
% Save figures
% =========================
saveas(fig_traj, fullfile('output','figures','BH_Trajectory_XY.png'));
saveas(fig_sep, fullfile('output','figures','Separation_vs_Time.png'));
saveas(fig_sep_peaks, fullfile('output','figures','Separation_Peaks.png'));
saveas(fig_rel, fullfile('output','figures','Relative_Orbit.png'));
saveas(figs_energy.fig_total, fullfile('output','figures','Total_Energy_vs_Time.png'));
saveas(figs_energy.fig_change, fullfile('output','figures','Relative_Energy_Change.png'));

% =========================
% Save data
% =========================
save(fullfile('output','data','gw150914_minimal.mat'), ...
    't_hist', 'y_hist', 'params', 'meta', 'diag', 'energy', 'angmom');

fprintf('Results saved to output/data and output/figures.\n');