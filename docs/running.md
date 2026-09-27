# Running and data

This guide describes inputs, commands, and outputs for the supplied MATLAB experiments. Begin with the data-free [synthetic example](../README.md#usage).

## Main experiment

- Place `SRTM_N35_to_39_E127_to_129.mat` in the repository root, containing a numeric elevation matrix named `SRTM_N35_to_39_E127_to_129`.
- The file is not supplied. Its geographic conversion, datum, provenance, and redistribution terms are not recorded; the code directly treats matrix indices as a local grid using `resolution` in `main_visionTRN.m`.
- Consult the [terrain contract](source-reference.md#terrain-indexing) when preparing a compatible matrix; the bundled `terrain.txt` is not a substitute for this MAT file.
- Inspect `TIME`, `dt_ins`, `dt`, `resolution`, `monte_step`, `num_samples`, and the noise settings at the top of [main_visionTRN.m](../main_visionTRN.m).
- Run the seeded [README command](../README.md#usage) from the root. The script clears workspace variables but does not reset the random generator.
- The script saves its workspace to `result.mat`, replacing an existing file, and creates a three-panel error plot.
- Main outputs include `monte_X_est/err`, `monte_A_est/err`, and `monte_V_est/err`, with trials as rows and times as columns; their units are metres, radians, and metres/second respectively.
- Position statistics retain only trials satisfying the final-error threshold; attitude and velocity statistics retain all trials. See [interpretation and failure cases](implementation-notes.md#scalar-experiment).

## Legacy geometry experiments

`loadTerrainAndFeatureMap(resolution, ff)` reads the first 120-by-120 numeric grid from [terrain.txt](../terrain.txt) in MATLAB column-major order, tiles it to 240-by-240, and samples features at the integer stride `ff`. The text file's geographical origin and reuse terms are not documented.

| Script | Prerequisites | Output and status |
|---|---|---|
| [test_triangulation.m](../test_triangulation.m) | `terrain.txt` | Pose-error plots; currently calls the loader without required `ff` and needs that caller input resolved |
| [test_triangulation_2.m](../test_triangulation_2.m) | `terrain.txt`, Statistics and Machine Learning Toolbox | Residual histograms and normal fits; camera noise settings are not applied by the projection helper |
| [test_h_err.m](../test_h_err.m) | Base MATLAB | Surface-height/look-angle plots and random histograms |
| [triangulation/test_triangulation.m](../triangulation/test_triangulation.m) | Separate working folder | Prints one reconstructed point; see [folder setup](../triangulation/README.md) |

The `test_` scripts are exploratory scripts without assertions, not an automated test suite. Their plots and the archived [result files](../result/README.md) have not been regenerated.

## Reproducibility

Record the source archive identifier from [provenance](provenance.md), MATLAB/toolbox versions, data checksum and grid convention, changed parameters, and RNG seed with each result. No reference Monte Carlo seed, numeric output baseline, supported release, or paper-reproduction command is available for this snapshot.
