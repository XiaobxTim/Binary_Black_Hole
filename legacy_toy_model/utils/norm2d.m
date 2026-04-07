function n = norm2d(v)
%NORM2D Euclidean norm for 2D vector

    v = v(:);
    n = sqrt(sum(v.^2));
end