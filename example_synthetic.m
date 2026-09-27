% Deterministic checks for the geometry described in docs/method.md.
% Expected values and scope: docs/translation.md; paper citation: README.md#citation.
function example_synthetic
pos1 = [10; 20; 25];
pos2 = [14; 21; 26];
point = [12; 24; 5];
camera = [100; 640; 480; 0; 1];
angles = zeros(3, 1);

[y1, y2] = getImageMeasurement(point, pos1, pos2, angles, angles, camera);
assert(norm(y1 - [-10; -20; 1], inf) < 1e-12);
assert(norm(y2 - [200/21; -100/7; 1], inf) < 1e-12);

[C1, C2] = cameraMatrices_n(pos1, pos2);
ray1 = [y1(1:2)/camera(1); 1];
ray2 = [y2(1:2)/camera(1); 1];
pointH = liu_2view_triangulate_hom(ray1, ray2, C1, C2);
assert(abs(pointH(4)) > 1e-12);
reconstructed = pos1 + pointH(1:3)/pointH(4);
assert(norm(reconstructed - point, inf) < 1e-9);

angles = [0.1; -0.2; 0.3];
rotation = DCM(angles);
assert(norm(rotation * rotation' - eye(3), inf) < 1e-12);
assert(norm(rotation - DCM_I2B(angles(1), angles(2), angles(3)), inf) < 1e-12);
assert(norm(rotation' - DCM_B2I(angles(1), angles(2), angles(3)), inf) < 1e-12);

terrain = [10 30; 50 90];
assert(abs(getFeatureHeight_dted(12.5, 17.5, terrain, 10) - 38.75) < 1e-12);
assert(getFeatureHeight_dted(10, 10, terrain, 10) == 10);
assert(getFeatureHeight_dted(20, 15, terrain, 10) == 0);
assert(getFeatureHeight_dted(5, 15, terrain, 10) == 0);
fprintf('Synthetic geometry checks passed.\n');
end
