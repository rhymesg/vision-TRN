function [ y1, y2 ] = getImageMeasurement( x, pos_cam1, pos_cam2, euler1, euler2, camera )
%GETFEATUREMEASUREMENTS Summary of this function goes here
%   Detailed explanation goes here

f = camera(1);
subpixel = camera(5);

[C1, C2] = cameraMatrices_n(pos_cam1, pos_cam2);

R1 = DCM(euler1); % from euler angles
R2 = DCM(euler2);

y1 = C1*[(x - pos_cam1); 1];
y1 = R1*y1;       % inertial to camera frame
y1 = y1/y1(3);  
y1(1:2) = y1(1:2) * f;  % image coordinate (pixels)

y2 = C2*[(x - pos_cam1); 1];
y2 = R2*y2;
y2 = y2/y2(3);
y2(1:2) = y2(1:2) * f;  % image coordinate (pixels)


