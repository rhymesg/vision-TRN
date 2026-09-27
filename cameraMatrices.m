function [ C1, C2 ] = cameraMatrices( pos_cam1, pos_cam2, f )
%CAMERAMATRICES Summary of this function goes here
%   Detailed explanation goes here

% H = [f 0 0; 0 f 0; 0 0 1]; % 2D perspective transformation from normalized coordinates
H = eye(3);

[C1_n, C2_n] = cameraMatrices_n(pos_cam1, pos_cam2);

C1 = H*C1_n;
C2 = H*C2_n;

end

