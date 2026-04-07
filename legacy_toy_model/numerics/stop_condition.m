function [stop_flag, stop_reason, final_sep] = stop_condition(t, y, step, params)
%STOP_CONDITION Determine whether simulation should stop

    stop_flag = false;
    stop_reason = 'running';

    if any(~isfinite(y))
        stop_flag = true;
        stop_reason = 'non-finite state encountered';
        final_sep = NaN;
        return;
    end

    state = vec_to_state(y);
    final_sep = norm2d(state.r2 - state.r1);

    if final_sep <= params.r_merge
        stop_flag = true;
        stop_reason = 'black holes reached merge threshold';
        return;
    end

    if t >= params.t_end
        stop_flag = true;
        stop_reason = 'reached final time';
        return;
    end

    if step >= params.max_steps
        stop_flag = true;
        stop_reason = 'reached max_steps';
        return;
    end
end