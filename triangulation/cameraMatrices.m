function [ C1, C2 ] = cameraMatrices( pos_cam1, pos_cam2, euler1, euler2, f )
%CAMERAMATRICES Summary of this function goes here
%   Detailed explanation goes here

H = [f 0 0; 0 f 0; 0 0 1]; % 2D perspective transformation from normalized coordinates

R1 = eye(3); % from euler angles
R2 = eye(3);

C1_n = [R1 zeros(3,1)];     % normalized camera matrix
C2_n = [R2 -(pos_cam2 - pos_cam1)];
 
C1 = H*C1_n;
C2 = H*C2_n;

end

