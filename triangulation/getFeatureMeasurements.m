function [ y1, y2 ] = getFeatureMeasurements( x, pos_cam1, pos_cam2, euler1, euler2, f )
%GETFEATUREMEASUREMENTS Summary of this function goes here
%   Detailed explanation goes here

[C1, C2] = cameraMatrices(pos_cam1, pos_cam2, euler1, euler2, f);

for i = 1:1:length(x(1,:));
    y1(:,i) = C1*[(x(:,i) - pos_cam1); 1];
    %y1(3) = -y1(3); % convert z of image coordinate to downward 
    y1(:,i) = y1(:,i)/y1(3,i);   % image coordinate (pixels)

    y2(:,i) = C2*[(x(:,i) - pos_cam1); 1];
    %y2(3) = -y2(3);
    y2(:,i) = y2(:,i)/y2(3,i);
end

