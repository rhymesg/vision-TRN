# Vision-based terrain-referenced navigation

This reference maps the [associated publication](../README.md#citation) to the MATLAB routines and distinguishes the published estimator from the supplied experiments.

## Feature-height observation

Given matched homogeneous pixels $y_1,y_2$, camera positions $p_1,p_2$, focal length $f$, and attitudes, the source follows this sequence:

1. Divide the first two pixel components by $f$ and rotate each ray with `DCM(euler)'` into the common frame.
2. Normalize each ray by its third component.
3. Form $C_1=[I\;0]$ and $C_2=[I\;-(p_2-p_1)]$ in [cameraMatrices_n.m](../cameraMatrices_n.m), corresponding to Eq. (13).
4. Reconstruct a homogeneous point with [liu_2view_triangulate_opt.m](../liu_2view_triangulate_opt.m); [estimateFeaturePosition.m](../estimateFeaturePosition.m) divides by its fourth component and adds $p_1$ (Eq. (12)).
5. Compare the estimated height with the bilinearly interpolated terrain height: $d_i=|\hat z_i-\mathrm{DEM}(\hat x_i,\hat y_i)|$ (Eqs. (15)-(16)).

The paper uses a position/attitude likelihood proportional to $\exp(-\gamma\sum_i d_i)$ in Eq. (17), plus a barometric altitude observation in Eqs. (18)-(19). The root main script does not connect these routines or implement those observations; `test_triangulation_2.m` explores the elevation residual separately.

The optimal triangulation helper calls the bundled Hartley-Sturm correction and then homogeneous triangulation. The latter solves the stacked cross-product equations $[\,[y_1]_\times C_1;[y_2]_\times C_2\,]X=0$ using the last right singular vector; see [source contracts](source-reference.md) and [geometry conventions](implementation-notes.md#geometry).

## Translation and velocity

The paper estimates an essential matrix from calibrated correspondences, decomposes it in Eqs. (20)-(23), and compares the recovered translation direction with normalized velocity in Eqs. (24)-(25). Translation determines direction, not metric speed or baseline magnitude.

[getTranslation_8point.m](../getTranslation_8point.m) constructs one design row per correspondence:

$$[u_1u_2,\;u_1v_2,\;u_1,\;v_1u_2,\;v_1v_2,\;v_1,\;u_2,\;v_2,\;1].$$

It reshapes the ninth right singular vector in MATLAB column-major order into a matrix satisfying $x_2^T E x_1=0$, then performs another SVD. A row-major reshape would transpose that matrix and reverse the epipolar convention. The helper uses these source conventions:

- The calibration matrix is constructed but never applied; callers must supply normalized coordinates for an essential-matrix interpretation.
- SVD uses the fitted matrix directly; an essential-matrix formulation constrains its singular values to `(s,s,0)`.
- Translation matrices use `V1`, whereas paper Eq. (21) uses `U`.
- It selects the candidate with the greater first component and returns its vector at the computed scale.

For the paper's velocity observation, follow the calibrated decomposition and angular likelihood in Eqs. (20)–(25).

## Estimator scope

The paper describes a 15-state error model with inertial sensor errors and particle filtering with effective-sample-size resampling. [process_model.m](../process_model.m) exposes a separate nine-state Cartesian propagation helper; [main_visionTRN.m](../main_visionTRN.m) instead propagates and resamples three scalar particle populations at every measurement update.

The paper's Table 1 uses 30 m DEM spacing, 100 Hz IMU sampling, 1 Hz camera updates, and 12/20/40 features. Use those settings for the paper's experiment; [implementation notes](implementation-notes.md#scalar-experiment) describe the separate scalar source experiment.

Use [example_synthetic.m](../example_synthetic.m) for a small deterministic geometry check, then consult the [running guide](running.md) for the independent legacy experiments and [translation guide](translation.md) for adaptation.
