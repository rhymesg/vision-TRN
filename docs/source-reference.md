# Source contracts

This reference describes the root MATLAB functions as implemented. The [method guide](method.md) supplies publication context; the [translation guide](translation.md) explains language-sensitive details.

## Coordinates and arrays

- Positions are real `3 x 1` columns in a shared Cartesian frame, measured in metres; the root experiment labels its axes east, north, up.
- Euler angles are `[roll; pitch; yaw]` in radians. `DCM(euler)` and `DCM_I2B` rotate into the body/camera frame; `DCM_B2I` is the transpose.
- Image points are homogeneous `[u; v; 1]` columns, with principal point at zero and focal length in pixels. There is no lens distortion model.
- `camera = [f; nx; ny; pixel_err_std; subpixel]`; `getImageMeasurement` uses `f`, reads but does not apply `subpixel`, and adds no pixel noise.
- The projection functions do not enforce positive camera depth or visibility. The synthetic example retains their signed-depth convention.

| Function | Inputs and output | Important behavior |
|---|---|---|
| `cameraMatrices_n` | Two positions → two `3 x 4` projection matrices | Coordinates are relative to camera 1; second translation is `-(p2-p1)` |
| `getImageMeasurement` | One feature, two poses, camera vector → two `3 x 1` image points | Rotates, divides by depth, then scales first two components by `f` |
| `estimateFeaturePosition` | Two image points, two poses, camera → one `3 x 1` position | Undoes focal scaling and rotations, triangulates, adds camera 1 position |
| `getFeatureHeight_dted` | Scalar `X,Y`, `M x N` terrain, scalar resolution → height | Row index is X; column index is Y; outside the interpolable domain returns zero |
| `getTranslation_8point` | Two arrays with at least two rows and `n` matching columns, `n`, camera → `3 x 1` vector | Use at least eight nondegenerate correspondences; no count/rank validation, calibration, or output normalization |
| `getMatchedPoints` | Two poses, `3 x N` feature positions, camera → feature indices | Axis-aligned footprint overlap ignores attitudes and feature heights; not image feature detection |
| `process_model` | Nine-state column, `3 x 1` acceleration and body rates, timestep → state, `9 x 9 F`, `9 x 6 L` | State is position/velocity/Euler angles; position uses newly updated velocity; no gravity term |
| `generateSamples` | Mean/std columns of equal length, count → samples as columns | Uses Gaussian `randn` samples; main passes scalar means/stds |
| `stderr` | Trials as rows, time samples as columns → one RMS-error row | Computes `sqrt(mean(error.^2))`, not standard error or centered standard deviation |

## Terrain indexing

For positive spacing `r`, valid interpolation inputs satisfy `r <= X < M*r` and `r <= Y < N*r`. Sample `(i,j)` is at `(i*r,j*r)`, not `((i-1)*r,(j-1)*r)`; the final grid line is excluded by the cell search.

For a cell, define `a=(X-i*r)/r` and `b=(Y-j*r)/r`. The returned height is `(1-a)*(1-b)*Q11 + (1-a)*b*Q12 + a*(1-b)*Q21 + a*b*Q22`.

## Error behavior

The helpers generally assume correctly sized finite inputs. Zero projection depth, coincident cameras, points at infinity, degenerate correspondences, or Euler pitch near ±pi/2 can produce nonfinite or unstable results without a dedicated diagnostic.

`getMatchedPoints` prints a message and returns early when fewer than five matches are found; its no-overlap branch can return without assigning the output. That threshold does not satisfy the eight-point method's correspondence requirement.
