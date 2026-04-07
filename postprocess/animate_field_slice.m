function animate_field_slice(field_slices, grid, params, video_name, title_name)

video_file = fullfile(params.output_dir, [video_name, '.mp4']);
v = VideoWriter(video_file, 'MPEG-4');
v.FrameRate = 10;
open(v);

fig = figure('Visible', 'off');
ns = size(field_slices, 3);

for i = 1:ns
    imagesc(grid.x, grid.y, field_slices(:,:,i).');
    axis xy equal tight;
    xlabel('x');
    ylabel('y');
    title(sprintf('%s (%d / %d)', title_name, i, ns), ...
        'Interpreter', 'none');
    colorbar;
    drawnow;

    frame = getframe(fig);
    writeVideo(v, frame);
end

close(v);
close(fig);

fprintf('Saved animation: %s\n', video_file);

end