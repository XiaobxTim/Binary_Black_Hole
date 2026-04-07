function output_dir = make_output_dir(params)

timestamp = datestr(now, 'yyyymmdd_HHMMSS');
output_dir = fullfile(params.output_root, [params.case_name '_' timestamp]);

if ~exist(params.output_root, 'dir')
    mkdir(params.output_root);
end

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

end