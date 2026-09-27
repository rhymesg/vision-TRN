# Implementation notes

Source behavior for the [vision navigation routines](../README.md). The [method guide](method.md) connects these components to the publication, and the [source contracts](source-reference.md) define their arrays and coordinates.

## Scalar experiment

[main_visionTRN.m](../main_visionTRN.m) propagates separate particle populations for X position, roll, and X velocity. It constructs measurements from `X_true`, including a Gaussian position factor centered on truth; use its plots to study this simulation's behavior.

Terrain queries add particle X and true Y to `x_meas`, which already contains absolute coordinates. The velocity residual samples noise with `att_std_est`, while its likelihood uses `vel_std_est`; retain these explicit conventions when comparing historical outputs.

Weight normalization requires positive finite totals. Position statistics retain trials selected by final error, so configure more than one trial and ensure the accepted-trial arrays are populated before plotting. `stderr` computes RMS error, and the velocity plot adds `V_bias` to that statistic.

## Geometry

The root projection uses focal length and signed camera depth. Footprint matching approximates image overlap with altitude and image dimensions; it returns an empty index list for disjoint footprints and accepts feature arrays with any number of columns.

Hartley-Sturm correction takes real parts of polynomial roots. `fundfromcameras` uses `y2' * F * y1 = 0`, while the correction routine declares `y1' * F * y2 = 0`; align matrix conventions when adapting that boundary. The synthetic example exercises homogeneous triangulation directly.

The nine-state process helper updates attitude nonlinearly and returns a matrix with a zero attitude block. For an estimator linearization, derive the Jacobian of the selected state model. Use positive baseline, nonzero projection depth and homogeneous denominator, and Euler angles away from the pitch singularity.

Keep the repository root on the MATLAB path for these interfaces; `triangulation/` contains separate historical variants.

## Example coverage

[example_synthetic.m](../example_synthetic.m) checks image projection, homogeneous triangulation, rotation inversion, a nonsymmetric terrain interpolation fixture, the terrain sentinel, and footprint matching. Expected values come from analytical geometry.
