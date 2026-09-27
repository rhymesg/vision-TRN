# Source provenance and attribution

This reference identifies the source snapshot and its reuse constraints. Publication citation is maintained in the [README](../README.md#citation) and [CITATION.cff](../CITATION.cff).

## Snapshot

- Source archive: `MATLAB_visionTRN_new-20260927T101024Z-1-001.zip`, directory `MATLAB_visionTRN_new/`.
- Archive SHA-256: `65842d853ee086200cb3a19b9408ebe3b3da3adfdfa56c21916ec2e9524007b9`.
- `getMatchedPoints.m` identifies Youngjoo Kim in its original header; this is the basis for the software author metadata, not an assertion of authorship over bundled utilities.
- The routines address components of the associated publication; their differences from the complete estimator are mapped in [method.md](method.md).
- Original code, terrain text, triangulation utilities, and result artifacts retain their layout. Added source comments link the method and citation, and Korean comments in two root files are encoded as UTF-8. `getMatchedPoints` initializes empty outputs and iterates over feature columns, including short feature arrays.
- The JVM crash log and MATLAB editor backup are excluded. User-provided reference material belongs in ignored `/ref/`; no reference files are tracked.

## Third-party code

| Material | Attribution present in source | Terms supplied |
|---|---|---|
| [fundfromcameras.m](../fundfromcameras.m) and its triangulation copy | Peter Kovesi, 2009 | File contains an explicit permission grant and notice-retention condition |
| Root and `triangulation/` `liu_*` routines | Klas Nordberg, 2009 | Attribution present; no general redistribution license identified in the supplied files |
| [vgg_contreps.m](../vgg_contreps.m), `triangulation/allfns/`, and its ZIP | VGG collection, with individual author headers in several files | No collection-wide license identified in the archive |
| `terrain.txt` and `result/` | Supplied with the research archive | Dataset/result redistribution terms not specified |

Preserve the original notices. The permission in `fundfromcameras.m` does not license the surrounding project or other bundled files; the publisher's article terms do not establish a software license.

Confirm project and third-party permissions before distributing the collection. The SRTM experiment uses the [data requirements](running.md#main-experiment).
