function rhs = bssn_rhs_skeleton(state, t, params, g)

rhs = init_bssn_state(g);

geom = build_bssn_geometry_cache(state, params, g);

rhs = bssn_rhs_metric_part(rhs, state, geom, params, g);
rhs = bssn_rhs_curvature_part(rhs, state, geom, params, g);
rhs = bssn_rhs_connection_part(rhs, state, geom, params, g);
rhs = bssn_rhs_gauge_part(rhs, state, geom, params, g);

end