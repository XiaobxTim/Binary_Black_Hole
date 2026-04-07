function plot_scalar_slice(state, grid, params, t)

phi_mid = state.phi(:,:,grid.kz_mid);

figure;
imagesc(grid.x, grid.y, phi_mid.');
axis xy equal tight;
xlabel('x');
ylabel('y');
title(sprintf('%s: \\phi(x,y,z=0), t = %.3f', params.case_name, t), ...
    'Interpreter', 'tex');
colorbar;

saveas(gcf, fullfile(params.output_dir, 'final_slice.png'));

end