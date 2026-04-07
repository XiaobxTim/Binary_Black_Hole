function rhs = bssn_rhs_placeholder(state, ~, params, g)

rhs = init_bssn_state(g);

% Everything remains constant in the flat test.
% This is intentional for Phase 3 framework validation.

end