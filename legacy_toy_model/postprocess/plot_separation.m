function fig = plot_separation(t_hist, y_hist, params)
%PLOT_SEPARATION Plot BH separation versus time

    n = size(y_hist, 1);
    sep = zeros(n, 1);

    for i = 1:n
        y = y_hist(i, :).';
        state = vec_to_state(y);
        sep(i) = norm2d(state.r2 - state.r1);
    end

    fig = figure('Name', 'Black Hole Separation', 'Color', 'w');
    plot(t_hist, sep, 'b-', 'LineWidth', 1.5);
    grid on; box on;

    xlabel('Time [M]');
    ylabel('Separation |\itr_2-r_1| [M]');
    title(sprintf('Black Hole Separation vs Time (%s)', params.case_name));
end