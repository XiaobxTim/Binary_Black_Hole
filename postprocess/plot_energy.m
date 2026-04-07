function figs = plot_energy(t_hist, energy, params)
%PLOT_ENERGY Plot total energy and relative energy change

    figs = struct();

    figs.fig_total = figure('Name', 'Total Energy', 'Color', 'w');
    plot(t_hist, energy.total, 'm-', 'LineWidth', 1.5);
    grid on; box on;
    xlabel('Time [M]');
    ylabel('Total Energy');
    title(sprintf('Total Energy vs Time (%s)', params.case_name));

    figs.fig_change = figure('Name', 'Relative Energy Change', 'Color', 'w');
    plot(t_hist, energy.relative_change, 'k-', 'LineWidth', 1.5);
    grid on; box on;
    xlabel('Time [M]');
    ylabel('\Delta E / |E_0|');
    title(sprintf('Relative Energy Change vs Time (%s)', params.case_name));
end