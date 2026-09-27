function [ C1_n, C2_n ] = cameraMatrices_n( pos_cam1, pos_cam2 )
%CAMERAMATRICES_N Summary of this function goes here
%   Detailed explanation goes here

C1_n = [eye(3) zeros(3,1)];     % normalized camera matrix
C2_n = [eye(3) -(pos_cam2 - pos_cam1)];

end

