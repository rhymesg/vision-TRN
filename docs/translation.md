# Adapting the MATLAB routines

This guide supports readers implementing related geometry in Python, C++, or another language. Start with the [method](method.md) and [source contracts](source-reference.md) for the equations, array shapes, and coordinate conventions.

## Preserve the contract

- Store features and particles as columns, and keep three-component positions distinct from four-component homogeneous points.
- Preserve matrix products, transpose direction, and the order of projection, rotation, depth normalization, and focal scaling.
- Use radians internally and metres for Cartesian positions; do not interpret the paper's geodetic/NED notation as the root code's Cartesian ENU convention without an explicit conversion.
- MATLAB terrain row `i` maps to X coordinate `i*r`; a zero-based array therefore maps index `i0` to `(i0+1)*r`. Preserve the excluded final grid line and zero sentinel when testing equivalence.
- Use column-major reshape for `terrain.txt` and the eight-point vector-to-matrix mapping; a default row-major reshape changes the result.
- In `process_model`, update velocity before position. In the scalar main experiment, position uses the previous velocity; these are separate models.
- Resampling draws independently with replacement, then adds jitter; do not replace it with systematic resampling during an equivalence comparison.

## Numerical operations

The eight-point helper reads column 9 of `V` from `svd(X',0)`. For an 8-by-9 matrix, MATLAB's [legacy zero option](https://www.mathworks.com/help/matlab/ref/double.svd.html) returns the full right-singular basis; an economy SVD in another implementation may omit the null vector.

Match right singular vectors rather than assuming an API returns `V` rather than its transpose. Compare dehomogenized points, residuals, or vector directions instead of raw SVD signs; preserve the source's translation sign selection only when explicitly testing source equivalence.

A redesign that calibrates pixels, enforces essential-matrix singular values, resolves cheirality, guards likelihood underflow, or changes the terrain sentinel must be validated separately from a translation. The [source behavior](implementation-notes.md) records the coordinate, likelihood, and linearization conventions to preserve or derive for the target model.

## Deterministic comparison

Use the fixtures in [example_synthetic.m](../example_synthetic.m):

| Check | Analytic expectation |
|---|---|
| Projection of `[12;24;5]` from `[10;20;25]`, focal length 100 | `[-10;-20;1]` |
| Second camera at `[14;21;26]` | `[200/21;-100/7;1]` |
| Homogeneous reconstruction from normalized rays | Point relative to camera 1 is `[2;4;-20]` |
| Terrain `[10 30;50 90]`, spacing 10, at `(12.5,17.5)` | `38.75` |
| Same terrain at `(20,15)` | `0`, the source's excluded-boundary sentinel |

These are derived fixtures, not measured MATLAB results. For later stochastic comparisons, share explicit random draws and inputs; equal seeds across languages do not imply equal random streams.

Review the [license and citation](../README.md#license) before reusing source, and preserve the [third-party notices](provenance.md#third-party-code).
