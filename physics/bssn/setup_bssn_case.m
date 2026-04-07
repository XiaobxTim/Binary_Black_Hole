function [state, rhs_handle, diag_handle, post_handle] = setup_bssn_case(params, g)

switch params.case_name
    case 'bssn_flat_test'
        state = bssn_flat_initial_data(params, g);

    case 'bssn_lapse_perturb'
        state = bssn_lapse_perturb_initial_data(params, g);

    case 'bssn_lapse_perturb_gamma_driver'
        state = bssn_lapse_perturb_initial_data(params, g);

    otherwise
        error('Unknown BSSN case: %s', params.case_name);
end

rhs_handle  = @(state, t) bssn_rhs_skeleton(state, t, params, g);
diag_handle = @(state, g, params, t) compute_bssn_basic_diag(state, g, params, t);
post_handle = @(state, g, params, t) bssn_postprocess_placeholder(state, g, params, t);

end

function bssn_postprocess_placeholder(state, g, params, t)

alpha_mid = state.alpha(:,:,g.kz_mid);

figure;
imagesc(g.x, g.y, alpha_mid.');
axis xy equal tight;
xlabel('x');
ylabel('y');
title(sprintf('%s: \\alpha(x,y,z=0), t = %.3f', params.case_name, t), ...
    'Interpreter', 'tex');
colorbar;

saveas(gcf, fullfile(params.output_dir, 'alpha_slice.png'));

end