# Implementation notes

These notes describe limitations visible in the supplied source. The [method guide](method.md) distinguishes publication equations from the experiments; none of the numerical behavior below has been changed.

## Scalar experiment

- `main_visionTRN.m` does not call the camera projection, feature triangulation, translation, or nine-state process helpers. It estimates only scalar X position, roll, and X velocity using separate particle populations.
- Measurements and likelihoods access `X_true` directly, including a Gaussian position factor centred on true position; errors cannot be interpreted as sensor-only navigation accuracy.
- `x_meas` already contains absolute truth coordinates, but predicted terrain queries add particle X and true Y again. This shifts the queried region and can invoke the zero-height out-of-bounds sentinel.
- The velocity residual draws noise using `att_std_est` while its likelihood uses `vel_std_est`; the exponent and prefactor also use different scales.
- Weight normalization has no guard for zero or nonfinite sums. If a resampling lookup is empty, the code selects particle 1.
- Position trials are filtered by final error before RMS computation; no accepted trial leaves `res_monte_X_*` undefined. Setting `monte_step` to 1 skips statistics that the plotting code still needs.
- `stderr` computes RMS error, and the plotted velocity statistic adds `V_bias`. Preserve these choices when comparing historical outputs, and resolve them before scientific validation.

## Geometry

- `getImageMeasurement` neither applies its pixel noise/rounding settings nor checks visibility; `getMatchedPoints` approximates overlap using altitude and image dimensions while ignoring orientation and terrain height.
- `getTranslation_8point` has the [calibration, decomposition, sign, and normalization differences](method.md#translation-and-velocity) described in the method guide.
- `liu_HartleySturm` uses `real(roots(g))`, taking real parts of complex polynomial roots. `fundfromcameras` constructs the convention `y2' * F * y1 = 0`, while the correction routine declares `y1' * F * y2 = 0` and passes the matrix without a transpose; general stereo reconstruction needs validation across that boundary.
- `process_model` updates attitude nonlinearly, but its returned `F` has a zero attitude block; it is not a verified linearization of that state update or the paper's 15-state error model.
- Zero baseline/depth, small homogeneous denominators, degenerate rays, and the Euler-rate singularity have no explicit guards.
- `triangulation/` contains alternative versions of root functions. Recursive path setup can silently select incompatible interfaces.

## Example coverage

[example_synthetic.m](../example_synthetic.m) checks the root projection and homogeneous triangulation using exact rays, a rotation inverse, a nonsymmetric terrain interpolation fixture, and the terrain sentinel. It does not exercise Hartley-Sturm correction, eight-point translation, stochastic filtering, or a publication experiment.

Expected values come from analytic geometry; the tolerances are smoke-check thresholds for these small double-precision fixtures, not scientific error bounds. MATLAB and Octave were unavailable during preparation, so runtime compatibility remains unverified.
