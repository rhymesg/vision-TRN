# Archived triangulation variants

This folder contains an older standalone two-view experiment, alternative triangulation functions, and bundled VGG utilities. Its functions overlap with the [root implementation](../docs/source-reference.md) but have different signatures and behavior.

- `cameraMatrices.m` accepts Euler arguments but uses identity rotations and applies focal scaling internally.
- `estimateFeaturePosition.m` accepts a scalar focal length; the root function instead accepts a five-element camera model.
- `liu_2view_triangulate_*` contains homogeneous, inhomogeneous, midpoint, and optimal variants.
- `allfns/` and `allfns.zip` contain the VGG utility collection and example media, including a historical compiled DLL; they are not needed by the root synthetic example.

From a fresh MATLAB session started at the repository root, run the standalone print-only experiment:

```bash
matlab -batch "cd('triangulation'); addpath('allfns/vgg_numerics'); test_triangulation"
```

It prints `x_est` and `feature_true` for comparison without assertions; runtime behavior remains unverified. Do not add this folder recursively to the path used by root scripts; preserve [bundled notices](../docs/provenance.md#third-party-code).
