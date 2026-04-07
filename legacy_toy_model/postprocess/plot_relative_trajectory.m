function fig = plot_relative_trajectory(y_hist, params)
%PLOT_RELATIVE_TRAJECTORY Plot relative orbit r = r2 - r1

    xrel = y_hist(:,3) - y_hist(:,1);
    yrel = y_hist(:,4) - y_hist(:,2);

    fig = figure('Name', 'Relative Orbit', 'Color', 'w');
    hold on; box on; grid on;

    plot(xrel, yrel, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Relative orbit');
    plot(xrel(1), yrel(1), 'bo', 'MarkerFaceColor', 'b', 'HandleVisibility', 'off');
    plot(xrel(end), yrel(end), 'bs', 'MarkerFaceColor', 'b', 'HandleVisibility', 'off');

    xlabel('x_2 - x_1 [M]');
    ylabel('y_2 - y_1 [M]');
    title(sprintf('Relative Orbit (%s)', params.case_name));
    axis equal;
    legend('Location', 'best');
end