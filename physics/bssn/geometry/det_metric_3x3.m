function detg = det_metric_3x3(gxx, gxy, gxz, gyy, gyz, gzz)

detg = gxx .* (gyy .* gzz - gyz .* gyz) ...
     - gxy .* (gxy .* gzz - gyz .* gxz) ...
     + gxz .* (gxy .* gyz - gyy .* gxz);

end