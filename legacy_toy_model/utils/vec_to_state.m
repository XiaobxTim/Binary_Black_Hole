function state = vec_to_state(y)
%VEC_TO_STATE Convert 8x1 vector to state struct

    y = y(:);

    state.r1 = y(1:2);
    state.r2 = y(3:4);
    state.v1 = y(5:6);
    state.v2 = y(7:8);
end