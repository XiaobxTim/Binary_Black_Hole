function ug = fill_ghosts_scalar(ug, g, bc_type)

nxg = size(ug, 1);
nyg = size(ug, 2);
nzg = size(ug, 3);

ixL1 = 1;  ixL2 = 2;  ix0 = 3;      ix1 = nxg-2; ixR1 = nxg-1; ixR2 = nxg;
iyL1 = 1;  iyL2 = 2;  iy0 = 3;      iy1 = nyg-2; iyR1 = nyg-1; iyR2 = nyg;
izL1 = 1;  izL2 = 2;  iz0 = 3;      iz1 = nzg-2; izR1 = nzg-1; izR2 = nzg;

switch bc_type
    case 'periodic'
        ug(ixL1,:,:) = ug(ix1-1,:,:);
        ug(ixL2,:,:) = ug(ix1,:,:);
        ug(ixR1,:,:) = ug(ix0,:,:);
        ug(ixR2,:,:) = ug(ix0+1,:,:);

        ug(:,iyL1,:) = ug(:,iy1-1,:);
        ug(:,iyL2,:) = ug(:,iy1,:);
        ug(:,iyR1,:) = ug(:,iy0,:);
        ug(:,iyR2,:) = ug(:,iy0+1,:);

        ug(:,:,izL1) = ug(:,:,iz1-1);
        ug(:,:,izL2) = ug(:,:,iz1);
        ug(:,:,izR1) = ug(:,:,iz0);
        ug(:,:,izR2) = ug(:,:,iz0+1);

    case 'copy'
        ug(ixL1,:,:) = ug(ix0,:,:);
        ug(ixL2,:,:) = ug(ix0,:,:);
        ug(ixR1,:,:) = ug(ix1,:,:);
        ug(ixR2,:,:) = ug(ix1,:,:);

        ug(:,iyL1,:) = ug(:,iy0,:);
        ug(:,iyL2,:) = ug(:,iy0,:);
        ug(:,iyR1,:) = ug(:,iy1,:);
        ug(:,iyR2,:) = ug(:,iy1,:);

        ug(:,:,izL1) = ug(:,:,iz0);
        ug(:,:,izL2) = ug(:,:,iz0);
        ug(:,:,izR1) = ug(:,:,iz1);
        ug(:,:,izR2) = ug(:,:,iz1);

    otherwise
        error('Unknown bc_type in fill_ghosts_scalar');
end

end