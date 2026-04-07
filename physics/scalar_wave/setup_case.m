function [state, rhs_handle, diag_handle, post_handle] = setup_case(params, grid)

switch params.case_name
    case 'scalar_wave'
        state = scalar_wave_initial_data(params, grid);
        rhs_handle = @(state, t) scalar_wave_rhs(state, t, params, grid);

    case 'gauge_wave'
        state = gauge_wave_initial_data(params, grid);
        rhs_handle = @(state, t) scalar_wave_rhs(state, t, params, grid);

    otherwise
        error('Unknown case_name in setup_case');
end

diag_handle = @(state, grid, params, t) compute_scalar_wave_diag(state, grid, params, t);
post_handle = @(state, grid, params, t) plot_scalar_slice(state, grid, params, t);

end