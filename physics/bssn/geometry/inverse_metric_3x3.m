function [uxx, uxy, uxz, uyy, uyz, uzz] = inverse_metric_3x3( ...
    gxx, gxy, gxz, gyy, gyz, gzz)

detg = det_metric_3x3(gxx, gxy, gxz, gyy, gyz, gzz);
detg = max(detg, 1e-14);

uxx = (gyy .* gzz - gyz .* gyz) ./ detg;
uxy = (gxz .* gyz - gxy .* gzz) ./ detg;
uxz = (gxy .* gyz - gxz .* gyy) ./ detg;

uyy = (gxx .* gzz - gxz .* gxz) ./ detg;
uyz = (gxy .* gxz - gxx .* gyz) ./ detg;

uzz = (gxx .* gyy - gxy .* gxy) ./ detg;

end