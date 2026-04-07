function render_black_hole_cinematic(alpha_slices, phi_slices, grid, params)

video_file = fullfile(params.output_dir, 'black_hole_cinematic.mp4');
v = VideoWriter(video_file, 'MPEG-4');
v.FrameRate = 18;
v.Quality = 100;
open(v);

x = grid.x;
y = grid.y;
[X, Y] = meshgrid(x, y);

ns = size(alpha_slices, 3);

fig = figure('Color', 'k', 'Position', [100, 100, 960, 720], 'Visible', 'off');

for i = 1:ns
    alpha_now = alpha_slices(:,:,i).';
    phi_now   = phi_slices(:,:,i).';
    psi_now   = exp(phi_now);

    psi_lo = prctile(psi_now(:), 2);
    psi_hi = prctile(psi_now(:), 99);
    psi_clip = min(max(psi_now, psi_lo), psi_hi);
    psi_norm = (psi_clip - min(psi_clip(:))) / (max(psi_clip(:)) - min(psi_clip(:)) + 1e-12);

    alpha_clip = min(max(alpha_now, 0), 1);
    dark_core = 1 - alpha_clip;

    [~, idx_min] = min(alpha_now(:));
    [row0, col0] = ind2sub(size(alpha_now), idx_min);
    xc = x(col0);
    yc = y(row0);

    R = sqrt((X - xc).^2 + (Y - yc).^2);

    ring_r0 = 0.8 + 0.2 * mean(dark_core(:));
    ring_sigma = 0.18;
    glow_ring = exp(-((R - ring_r0).^2) / (2 * ring_sigma^2));

    img = 0.55 * psi_norm + 0.45 * glow_ring;
    img = img .* (1 - 0.85 * dark_core.^1.2);

    Rall = sqrt((X - mean(x)).^2 + (Y - mean(y)).^2);
    vignette = exp(-(Rall / (0.95 * max(abs(x)))) .^ 2);
    img = img .* (0.65 + 0.35 * vignette);

    img = img .^ 0.85;
    img = min(max(img, 0), 1);

    clf(fig);
    ax = axes(fig);
    hold(ax, 'on');
    set(ax, 'Color', 'k');

    imagesc(x, y, img, 'Parent', ax);
    axis(ax, 'xy');
    axis(ax, 'equal');
    axis(ax, 'tight');

    colormap(ax, blackhole_colormap());

    contour(ax, x, y, psi_now, 8, ...
        'LineColor', [1.0, 0.85, 0.35], ...
        'LineWidth', 0.7);

    contour(ax, x, y, alpha_now, [0.05 0.1 0.2 0.4 0.7], ...
        'LineColor', [0.6, 0.85, 1.0], ...
        'LineWidth', 0.8);

    plot(ax, xc, yc, 'wo', 'MarkerSize', 4, 'LineWidth', 1.0);

    xlabel(ax, 'x', 'Color', 'w', 'FontSize', 12);
    ylabel(ax, 'y', 'Color', 'w', 'FontSize', 12);
    title(ax, 'Single Black Hole Evolution (BSSN z=0 slice)', ...
        'Color', 'w', 'FontSize', 16, 'FontWeight', 'bold');

    ax.XColor = [0.9 0.9 0.9];
    ax.YColor = [0.9 0.9 0.9];
    ax.LineWidth = 1.0;
    box(ax, 'on');

    if isfield(params, 'plot_every') && isfield(params, 'dt')
        t_now = (i - 1) * params.plot_every * params.dt;
    else
        t_now = i - 1;
    end

    text(ax, 0.98, 0.05, sprintf('t = %.3f', t_now), ...
        'Units', 'normalized', ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'bottom', ...
        'Color', 'w', ...
        'FontSize', 14, ...
        'FontWeight', 'bold', ...
        'BackgroundColor', [0 0 0], ...
        'Margin', 6);

    text(ax, 0.02, 0.95, 'Numerical Relativity Prototype', ...
        'Units', 'normalized', ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'top', ...
        'Color', [1.0 0.85 0.35], ...
        'FontSize', 13, ...
        'FontWeight', 'bold');

    drawnow;

    frame = getframe(fig);
    writeVideo(v, frame);
end

close(v);
close(fig);

fprintf('Saved cinematic animation: %s\n', video_file);

end

function cmap = blackhole_colormap()

n = 256;
t = linspace(0, 1, n)';

r = 0.03 + 1.20 * t.^1.8;
g = 0.02 + 0.55 * t.^1.4;
b = 0.08 + 0.75 * (1 - t).^1.2;

cmap = [r g b];
cmap = min(max(cmap, 0), 1);

end