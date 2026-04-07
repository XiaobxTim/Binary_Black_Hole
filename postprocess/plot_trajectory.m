function fig = plot_trajectory(t_hist, y_hist, params)
%PLOT_TRAJECTORY Plot BH1 and BH2 trajectories in XY plane

    %#ok<*NASGU>
    x1 = y_hist(:, 1);
    y1 = y_hist(:, 2);
    x2 = y_hist(:, 3);
    y2 = y_hist(:, 4);

    fig = figure('Name', 'Black Hole Trajectory', 'Color', 'w');
    hold on; box on; grid on;

    plot(x1, y1, 'r-', 'LineWidth', 1.5, 'DisplayName', 'BH1');
    plot(x2, y2, 'g-', 'LineWidth', 1.5, 'DisplayName', 'BH2');

    % Mark start points
    plot(x1(1), y1(1), 'ro', 'MarkerFaceColor', 'r', 'HandleVisibility', 'off');
    plot(x2(1), y2(1), 'go', 'MarkerFaceColor', 'g', 'HandleVisibility', 'off');

    % Mark end points
    plot(x1(end), y1(end), 'rs', 'MarkerFaceColor', 'r', 'HandleVisibility', 'off');
    plot(x2(end), y2(end), 'gs', 'MarkerFaceColor', 'g', 'HandleVisibility', 'off');

    xlabel('X [M]');
    ylabel('Y [M]');
    title(sprintf('Black Hole Trajectory (%s)', params.case_name));
    legend('Location', 'best');
    axis equal;

    % Add small padding
    allx = [x1; x2];
    ally = [y1; y2];
    xmin = min(allx); xmax = max(allx);
    ymin = min(ally); ymax = max(ally);
    dx = xmax - xmin; dy = ymax - ymin;
    if dx == 0, dx = 1; end
    if dy == 0, dy = 1; end
    xlim([xmin - 0.05*dx, xmax + 0.05*dx]);
    ylim([ymin - 0.05*dy, ymax + 0.05*dy]);

    text(0.02, 0.98, sprintf('Saved points: %d\nFinal t = %.2f', length(t_hist), t_hist(end)), ...
        'Units', 'normalized', 'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'top', 'FontSize', 10, ...
        'BackgroundColor', 'white', 'EdgeColor', [0.8 0.8 0.8]);
end