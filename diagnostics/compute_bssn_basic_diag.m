function d = compute_bssn_basic_diag(state, g, params, t)

geom = build_bssn_geometry_cache(state, params, g);

detg = geom.detg;

[guxx, guxy, guxz, guyy, guyz, guzz] = deal( ...
    geom.igxx, geom.igxy, geom.igxz, geom.igyy, geom.igyz, geom.igzz);

trA = guxx .* state.Axx ...
    + 2*guxy .* state.Axy ...
    + 2*guxz .* state.Axz ...
    + guyy .* state.Ayy ...
    + 2*guyz .* state.Ayz ...
    + guzz .* state.Azz;

fields = fieldnames(state);
has_naninf = false;

for i = 1:numel(fields)
    f = fields{i};
    arr = state.(f);
    if any(~isfinite(arr(:)))
        has_naninf = true;
        break;
    end
end

maxA = max([
    max(abs(state.Axx), [], 'all'), ...
    max(abs(state.Axy), [], 'all'), ...
    max(abs(state.Axz), [], 'all'), ...
    max(abs(state.Ayy), [], 'all'), ...
    max(abs(state.Ayz), [], 'all'), ...
    max(abs(state.Azz), [], 'all')
]);

maxG = max([
    max(abs(state.Gx), [], 'all'), ...
    max(abs(state.Gy), [], 'all'), ...
    max(abs(state.Gz), [], 'all')
]);

maxBeta = max([
    max(abs(state.betax), [], 'all'), ...
    max(abs(state.betay), [], 'all'), ...
    max(abs(state.betaz), [], 'all')
]);

maxB = max([
    max(abs(state.Bx), [], 'all'), ...
    max(abs(state.By), [], 'all'), ...
    max(abs(state.Bz), [], 'all')
]);

cdiag = compute_bssn_constraint_diag(state, geom, params, g);

d = struct();
d.t = t;
d.detg_err = max(abs(detg(:) - 1.0));
d.trA_err  = max(abs(trA(:)));
d.alpha_min = min(state.alpha(:));
d.alpha_max = max(state.alpha(:));
d.maxK = max(abs(state.K), [], 'all');
d.maxA = maxA;
d.maxG = maxG;
d.maxBeta = maxBeta;
d.maxB = maxB;

d.ham_max = cdiag.ham_max;
d.ham_l2  = cdiag.ham_l2;
d.mom_max = cdiag.mom_max;
d.mom_l2  = cdiag.mom_l2;

d.has_naninf = double(has_naninf);

end