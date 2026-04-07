function D = ko_dissipation_3d(ug, grid, sigma)

Dx = ko_dissipation_1d(ug, grid.dx, grid, 1);
Dy = ko_dissipation_1d(ug, grid.dy, grid, 2);
Dz = ko_dissipation_1d(ug, grid.dz, grid, 3);

D = -sigma * (Dx + Dy + Dz);

end