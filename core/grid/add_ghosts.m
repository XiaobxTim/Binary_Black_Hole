function ug = add_ghosts(u, grid)

ug = zeros(grid.Nxg, grid.Nyg, grid.Nzg);
ug(grid.i1:grid.i2, grid.j1:grid.j2, grid.k1:grid.k2) = u;

end