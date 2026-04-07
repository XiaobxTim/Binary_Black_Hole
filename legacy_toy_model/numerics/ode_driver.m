function [t_hist, y_hist, diag] = ode_driver(rhs_handle, y0, params)
%ODE_DRIVER Main time evolution loop

    dt = params.dt;
    t  = params.t0;
    y  = y0;
    step = 0;

    % Conservative allocation
    n_save_max = floor(params.max_steps / params.save_every) + 10;
    t_hist = zeros(n_save_max, 1);
    y_hist = zeros(n_save_max, length(y0));

    save_idx = 1;
    t_hist(save_idx) = t;
    y_hist(save_idx, :) = y(:).';

    tic;

    while true
        [stop_flag, stop_reason, final_sep] = stop_condition(t, y, step, params);
        if stop_flag
            break;
        end

        y = rk4_step(rhs_handle, t, y, dt, params);
        t = t + dt;
        step = step + 1;

        if mod(step, params.save_every) == 0
            save_idx = save_idx + 1;

            % Expand if needed
            if save_idx > size(t_hist, 1)
                t_hist = [t_hist; zeros(n_save_max, 1)]; %#ok<AGROW>
                y_hist = [y_hist; zeros(n_save_max, length(y0))]; %#ok<AGROW>
            end

            t_hist(save_idx) = t;
            y_hist(save_idx, :) = y(:).';
        end
    end

    cpu_time = toc;

    % Make sure the last state is saved
    if t_hist(save_idx) ~= t
        save_idx = save_idx + 1;
        if save_idx > size(t_hist, 1)
            t_hist = [t_hist; 0];
            y_hist = [y_hist; zeros(1, length(y0))];
        end
        t_hist(save_idx) = t;
        y_hist(save_idx, :) = y(:).';
    end

    t_hist = t_hist(1:save_idx);
    y_hist = y_hist(1:save_idx, :);

    diag.num_steps = step;
    diag.final_time = t;
    diag.final_separation = final_sep;
    diag.stop_reason = stop_reason;
    diag.cpu_time = cpu_time;
end