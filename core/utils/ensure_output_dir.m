function ensure_output_dir(output_dir)

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

end