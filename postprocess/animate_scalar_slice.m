function animate_scalar_slice(phi_slices, grid, params)

video_file = fullfile(params.output_dir, 'scalar_wave_slice.mp4');
v = VideoWriter(video_file, 'MPEG-4');
v.FrameRate = 10;
open(v);

fig = figure;
ns = size(phi_slices, 3);

for i = 1:ns
    imagesc(grid.x, grid.y, phi_slices(:,:,i).');
    axis xy equal tight;
    xlabel('x');
    ylabel('y');
    title(sprintf('%s slice (%d / %d)', params.case_name, i, ns), ...
        'Interpreter', 'none');
    colorbar;
    drawnow;

    frame = getframe(fig);
    writeVideo(v, frame);
end

close(v);
close(fig);

end