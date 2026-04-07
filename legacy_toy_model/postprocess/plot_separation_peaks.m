function fig = plot_separation_peaks(t_hist, y_hist, params)
%PLOT_SEPARATION_PEAKS Plot separation and local maxima

    n = size(y_hist, 1);
    sep = zeros(n, 1);

    for i = 1:n
        dx = y_hist(i,3) - y_hist(i,1);
        dy = y_hist(i,4) - y_hist(i,2);
        sep(i) = sqrt(dx^2 + dy^2);
    end

    peak_idx = [];
    for i = 2:n-1
        if sep(i) > sep(i-1) && sep(i) > sep(i+1)
            peak_idx(end+1) = i; %#ok<AGROW>
        end
    end

    fig = figure('Name', 'Separation Peaks', 'Color', 'w');
    hold on; box on; grid on;

    plot(t_hist, sep, 'b-', 'LineWidth', 1.2, 'DisplayName', 'Separation');
    if ~isempty(peak_idx)
        plot(t_hist(peak_idx), sep(peak_idx), 'ro', ...
            'MarkerFaceColor', 'r', 'DisplayName', 'Local maxima');
    end

    xlabel('Time [M]');
    ylabel('|r_2-r_1| [M]');
    title(sprintf('Separation with Local Maxima (%s)', params.case_name));
    legend('Location', 'best');
end