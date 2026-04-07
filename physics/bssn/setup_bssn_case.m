function [state, rhs_handle, diag_handle, post_handle] = setup_bssn_case(params, g)

switch params.case_name
    case 'bssn_flat_test'
        state = bssn_flat_initial_data(params, g);

    case 'bssn_lapse_perturb'
        state = bssn_lapse_perturb_initial_data(params, g);

    case 'bssn_lapse_perturb_gamma_driver'
        state = bssn_lapse_perturb_initial_data(params, g);

    case 'bssn_single_bh'
        state = bssn_single_bh_puncture_initial_data(params, g);

    otherwise
        error('Unknown BSSN case: %s', params.case_name);
end

rhs_handle  = @(state, t) bssn_rhs_skeleton(state, t, params, g);
diag_handle = @(state, g, params, t) compute_bssn_basic_diag(state, g, params, t);
post_handle = @(state, g, params, t) bssn_postprocess_single_bh(state, g, params, t);

end

function bssn_postprocess_single_bh(state, g, params, t)

k = g.kz_mid;

figure;
imagesc(g.x, g.y, state.alpha(:,:,k).');
axis xy equal tight; colorbar;
xlabel('x'); ylabel('y');
title(sprintf('%s: alpha(z=0), t = %.3f', params.case_name, t), 'Interpreter', 'none');
saveas(gcf, fullfile(params.output_dir, 'alpha_z0.png'));

figure;
imagesc(g.x, g.y, state.phi(:,:,k).');
axis xy equal tight; colorbar;
xlabel('x'); ylabel('y');
title(sprintf('%s: phi(z=0), t = %.3f', params.case_name, t), 'Interpreter', 'none');
saveas(gcf, fullfile(params.output_dir, 'phi_z0.png'));

psi = exp(state.phi(:,:,k));
figure;
imagesc(g.x, g.y, psi.');
axis xy equal tight; colorbar;
xlabel('x'); ylabel('y');
title(sprintf('%s: psi(z=0), t = %.3f', params.case_name, t), 'Interpreter', 'none');
saveas(gcf, fullfile(params.output_dir, 'psi_z0.png'));

end