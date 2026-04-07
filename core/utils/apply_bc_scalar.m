function state = apply_bc_scalar(state, params)

switch params.bc_type
    case 'dirichlet'
        state.phi(1,:,:)   = 0; state.phi(end,:,:)   = 0;
        state.phi(:,1,:)   = 0; state.phi(:,end,:)   = 0;
        state.phi(:,:,1)   = 0; state.phi(:,:,end)   = 0;

        state.pi(1,:,:)    = 0; state.pi(end,:,:)    = 0;
        state.pi(:,1,:)    = 0; state.pi(:,end,:)    = 0;
        state.pi(:,:,1)    = 0; state.pi(:,:,end)    = 0;

    case 'periodic'
        % nothing to do

    otherwise
        error('Unknown bc_type in apply_bc_scalar');
end

end