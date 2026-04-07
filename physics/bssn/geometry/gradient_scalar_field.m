function grad = gradient_scalar_field(u, params, g)

ug = add_ghosts(u, g);
ug = fill_ghosts_scalar(ug, g, params.bc_type);

grad = struct();
grad.x = ddx4_g(ug, g);
grad.y = ddy4_g(ug, g);
grad.z = ddz4_g(ug, g);

end