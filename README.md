# vision-TRN

## Overview

MATLAB research routines for vision-based terrain-referenced navigation (TRN): two-view ground-feature triangulation, digital elevation model (DEM) interpolation, camera translation estimation, and a scalar particle-filter experiment.

Canonical repository: [rhymesg/vision-TRN](https://github.com/rhymesg/vision-TRN).

The routines relate to [Kim and Bang's vision-based navigation paper](#citation). The camera and terrain helpers expose useful parts of the method, but `main_visionTRN.m` runs separate scalar position, roll, and velocity experiments with truth-based measurements; it does not implement the paper's complete navigation filter.

Start with the [method and equation map](docs/method.md), [source contracts](docs/source-reference.md), or [Python/C++ adaptation guide](docs/translation.md). This repository provides MATLAB source; no Python or C++ port is included.

The associated navigation research has a [granted Korean patent](#related-patent).

## Installation

Clone the repository:

```bash
git clone https://github.com/rhymesg/vision-TRN.git
```

Enter its root:

```bash
cd vision-TRN
```

Use MATLAB with the `matlab` executable on your shell path; the [batch option](https://www.mathworks.com/help/matlab/ref/matlabmacos.html) requires R2019a or later.

The synthetic example uses base MATLAB only. The legacy simulation uses Statistics and Machine Learning Toolbox for [`normrnd`](https://www.mathworks.com/help/stats/normrnd.html), and `test_triangulation_2.m` also uses `fitdist`.

No MATLAB release or operating system has been validated for this snapshot. Keep the root as MATLAB's current folder; do not recursively add `triangulation/`, which contains functions with conflicting names and signatures.

## Usage

Run the deterministic example without terrain files, toolboxes, figures, or file writes:

```bash
matlab -batch "example_synthetic"
```

Expected completion: `Synthetic geometry checks passed.` It checks analytic image projection, homogeneous triangulation, rotation inversion, and terrain interpolation, including the out-of-bounds sentinel.

For the scalar particle-filter experiment, first supply the external MAT file described in the [running and data guide](docs/running.md):

```bash
matlab -batch "rng(0, 'twister'); main_visionTRN"
```

The script creates plots and overwrites `result.mat`. Its [implementation limitations](docs/implementation-notes.md) affect both interpretation and execution.

## Development

Use the synthetic command after modifying the geometry helpers. Its expected values are analytically derived; the MATLAB example has not been executed in this environment and does not reproduce the paper's results.

When reporting a problem to the maintainer, include the source revision or archive identifier, MATLAB/toolbox versions, command, random seed, input shapes, and error output. Use the [GitHub repository](https://github.com/rhymesg/vision-TRN) for project updates and contributions; [repository metadata](docs/repository-metadata.md) contains a proposed description and topics.

## Algorithms and source

| Capability | Entry point | Reference |
|---|---|---|
| Two-view feature reconstruction | [estimateFeaturePosition.m](estimateFeaturePosition.m), [cameraMatrices_n.m](cameraMatrices_n.m) | [Paper Eqs. (12)-(14)](docs/method.md#feature-height-observation) |
| Pinhole image projection | [getImageMeasurement.m](getImageMeasurement.m) | [Array and coordinate contracts](docs/source-reference.md) |
| DEM bilinear interpolation | [getFeatureHeight_dted.m](getFeatureHeight_dted.m) | [Paper Eqs. (15)-(16)](docs/method.md#feature-height-observation) |
| Eight-point translation experiment | [getTranslation_8point.m](getTranslation_8point.m) | [Paper/code differences](docs/method.md#translation-and-velocity) |
| Scalar particle filtering | [main_visionTRN.m](main_visionTRN.m), [stderr.m](stderr.m) | [Experiment limitations](docs/implementation-notes.md#scalar-experiment) |
| Archived triangulation variants and plots | [triangulation/](triangulation/README.md), [result/](result/README.md) | Historical supporting material |

## Citation

Please cite the paper when using this method:

> Youngjoo Kim and Hyochoong Bang. “Vision-based navigation for unmanned aircraft using ground feature points and terrain elevation data.” *Proceedings of the Institution of Mechanical Engineers, Part G: Journal of Aerospace Engineering*, 232(7), 1334-1346, 2018. [doi:10.1177/0954410017690548](https://doi.org/10.1177/0954410017690548).

The [publisher record](https://journals.sagepub.com/doi/10.1177/0954410017690548) dates online publication to 2 February 2017 and the journal issue to June 2018. [CITATION.cff](CITATION.cff) supplies the preferred paper citation; [provenance](docs/provenance.md) identifies this source snapshot and bundled third-party code.

## Related patent

Related granted Korean patent for the navigation research: [KR101737950B1 — Vision-based navigation solution estimation system and method in terrain referenced navigation](https://patents.google.com/patent/KR101737950B1/en). The [method reference](docs/method.md) distinguishes the supplied routines from the complete navigation estimator.

## License

No project-wide software license is supplied. Reuse permissions require confirmation from the respective rights holders; preserve the [third-party notices](docs/provenance.md#third-party-code) already present in the source.
