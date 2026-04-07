function state_new = rk4_step(state, t, dt, rhs_handle)

k1 = rhs_handle(state, t);
k2 = rhs_handle(state_add(state, k1, dt/2), t + dt/2);
k3 = rhs_handle(state_add(state, k2, dt/2), t + dt/2);
k4 = rhs_handle(state_add(state, k3, dt),   t + dt);

state_new = state;
fields = fieldnames(state);

for i = 1:numel(fields)
    f = fields{i};
    state_new.(f) = state.(f) + dt/6 * ...
        (k1.(f) + 2*k2.(f) + 2*k3.(f) + k4.(f));
end

end

function out = state_add(a, b, alpha)

out = a;
fields = fieldnames(a);

for i = 1:numel(fields)
    f = fields{i};
    out.(f) = a.(f) + alpha * b.(f);
end

end