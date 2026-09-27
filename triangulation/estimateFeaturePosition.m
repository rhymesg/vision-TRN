function [ x ] = estimateFeaturePosition( y1, y2, pos_cam1, pos_cam2, euler1, euler2, f )
%ESTIMATEFEATUREPOSITION Summary of this function goes here
%   Detailed explanation goes here

[C1, C2] = cameraMatrices(pos_cam1, pos_cam2, euler1, euler2, f);

for i = 1:1:length(y1(1,:));
    x_c = liu_2view_triangulate_opt(y1,y2,C1,C2);
    x(:,i) = pos_cam1 + x_c(1:3)/x_c(4);
end

