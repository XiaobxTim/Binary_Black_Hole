function cd = compute_bssn_constraint_diag(state, geom, params, g)

cons = compute_bssn_constraints_prototype(state, geom, params, g);

cd = struct();

cd.ham_max = max(abs(cons.H), [], 'all');
cd.ham_l2  = sqrt(sum(cons.H(:).^2) * g.dx * g.dy * g.dz);

mom_mag = sqrt(cons.Mx.^2 + cons.My.^2 + cons.Mz.^2);
cd.mom_max = max(mom_mag, [], 'all');
cd.mom_l2  = sqrt(sum(mom_mag(:).^2) * g.dx * g.dy * g.dz);

end