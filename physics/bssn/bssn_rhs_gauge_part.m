function rhs = bssn_rhs_gauge_part(rhs, state, geom, params, g)

%% -------------------------
% 1. Lapse evolution
%% -------------------------
switch params.gauge_lapse_type
    case 'one_plus_log'
        rhs.alpha = -params.mu_lapse * state.alpha .* state.K;

    otherwise
        error('Unknown gauge_lapse_type: %s', params.gauge_lapse_type);
end

%% -------------------------
% 2. Shift / B evolution
%% -------------------------
switch params.gauge_shift_type
    case 'frozen'
        rhs.betax = 0 * state.betax;
        rhs.betay = 0 * state.betay;
        rhs.betaz = 0 * state.betaz;

        rhs.Bx = 0 * state.Bx;
        rhs.By = 0 * state.By;
        rhs.Bz = 0 * state.Bz;

    case 'gamma_driver_placeholder'
        % Minimal Gamma-driver prototype:
        %   dt beta^i = mu_B * B^i
        %   dt B^i    = mu_G * Gamma^i - eta_B * B^i
        %
        % Here we use the current Gamma^i state as a simple source term.

        rhs.betax = params.mu_B * state.Bx;
        rhs.betay = params.mu_B * state.By;
        rhs.betaz = params.mu_B * state.Bz;

        rhs.Bx = params.mu_G * state.Gx - params.eta_B * state.Bx;
        rhs.By = params.mu_G * state.Gy - params.eta_B * state.By;
        rhs.Bz = params.mu_G * state.Gz - params.eta_B * state.Bz;

    otherwise
        error('Unknown gauge_shift_type: %s', params.gauge_shift_type);
end

end