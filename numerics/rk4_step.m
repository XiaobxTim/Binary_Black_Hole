function y_next = rk4_step(f, t, y, dt, params)
%RK4_STEP One RK4 integration step

    k1 = f(t,         y,             params);
    k2 = f(t + dt/2, y + dt/2 * k1, params);
    k3 = f(t + dt/2, y + dt/2 * k2, params);
    k4 = f(t + dt,   y + dt    * k3, params);

    y_next = y + dt/6 * (k1 + 2*k2 + 2*k3 + k4);
end