function ug = fill_ghosts_scalar(ug, grid, bc_type)

ng = grid.ng;
i1 = grid.i1; i2 = grid.i2;
j1 = grid.j1; j2 = grid.j2;
k1 = grid.k1; k2 = grid.k2;

switch bc_type
    case 'periodic'
        % x
        ug(1:ng, :, :) = ug(i2-ng+1:i2, :, :);
        ug(i2+1:end, :, :) = ug(i1:i1+ng-1, :, :);

        % y
        ug(:, 1:ng, :) = ug(:, j2-ng+1:j2, :);
        ug(:, j2+1:end, :) = ug(:, j1:j1+ng-1, :);

        % z
        ug(:, :, 1:ng) = ug(:, :, k2-ng+1:k2);
        ug(:, :, k2+1:end) = ug(:, :, k1:k1+ng-1);

    case 'dirichlet'
        ug(1:ng,:,:) = 0;
        ug(i2+1:end,:,:) = 0;
        ug(:,1:ng,:) = 0;
        ug(:,j2+1:end,:) = 0;
        ug(:,:,1:ng) = 0;
        ug(:,:,k2+1:end) = 0;

    otherwise
        error('Unknown bc_type in fill_ghosts_scalar');
end

end