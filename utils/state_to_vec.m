function y = state_to_vec(state)
%STATE_TO_VEC Convert state struct to 8x1 vector

    y = [
        state.r1(1);
        state.r1(2);
        state.r2(1);
        state.r2(2);
        state.v1(1);
        state.v1(2);
        state.v2(1);
        state.v2(2)
    ];
end