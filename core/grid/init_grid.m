function g = init_grid(params)

g = struct();

g.Nx = params.Nx;
g.Ny = params.Ny;
g.Nz = params.Nz;
g.ng = params.ng;

%% Grid coordinates
if strcmp(params.bc_type, 'periodic')
    % periodic grid: DO NOT include the right endpoint
    g.dx = (params.xmax - params.xmin) / params.Nx;
    g.dy = (params.ymax - params.ymin) / params.Ny;
    g.dz = (params.zmax - params.zmin) / params.Nz;

    g.x = params.xmin + (0:params.Nx-1) * g.dx;
    g.y = params.ymin + (0:params.Ny-1) * g.dy;
    g.z = params.zmin + (0:params.Nz-1) * g.dz;
else
    % non-periodic grid: include both endpoints
    g.x = linspace(params.xmin, params.xmax, params.Nx);
    g.y = linspace(params.ymin, params.ymax, params.Ny);
    g.z = linspace(params.zmin, params.zmax, params.Nz);

    g.dx = g.x(2) - g.x(1);
    g.dy = g.y(2) - g.y(1);
    g.dz = g.z(2) - g.z(1);
end

%% Physical region indices inside ghosted arrays
g.i1 = g.ng + 1;
g.i2 = g.ng + g.Nx;
g.j1 = g.ng + 1;
g.j2 = g.ng + g.Ny;
g.k1 = g.ng + 1;
g.k2 = g.ng + g.Nz;

%% Ghosted sizes
g.Nxg = g.Nx + 2*g.ng;
g.Nyg = g.Ny + 2*g.ng;
g.Nzg = g.Nz + 2*g.ng;

%% Mesh
[X, Y, Z] = ndgrid(g.x, g.y, g.z);
g.X = X;
g.Y = Y;
g.Z = Z;

%% Mid indices in physical region
g.ix_mid = round(g.Nx / 2);
g.iy_mid = round(g.Ny / 2);
g.kz_mid = round(g.Nz / 2);

end