function [ x ] = estimateFeaturePosition( y1, y2, pos_cam1, pos_cam2, euler1, euler2, camera )
% Two-view feature reconstruction; https://doi.org/10.1177/0954410017690548
% Method and citation: docs/method.md and README.md#citation.

f = camera(1);

[C1_n, C2_n] = cameraMatrices_n(pos_cam1, pos_cam2);

R1 = DCM(euler1); % inertial to camera frame
R2 = DCM(euler2); 

y1(1:2) = y1(1:2)/f;
y2(1:2) = y2(1:2)/f;

y1 = R1'*y1;    % camera to inertial frame
y2 = R2'*y2;

y1 = y1/y1(3);
y2 = y2/y2(3);

x_c = liu_2view_triangulate_opt(y1,y2,C1_n,C2_n);
x_c = x_c(1:3)/x_c(4);
x = pos_cam1 + x_c;


% 
% C1 = R1'*C1;
% C2 = R2'*C2;

% H = [f 0 0; 0 f 0; 0 0 1]; % 2D perspective transformation from normalized coordinates
% 
% R1 = DCM(euler1); % inertial to camera frame
% R2 = DCM(euler2); 
% 
% C1_n = [R1' zeros(3,1)];     % normalized camera matrix
% C2_n = [DCM(euler1-euler2)' -(pos_cam2 - pos_cam1)];
%  
% C1 = H*C1_n;
% C2 = H*C2_n;


% C1 = R1*H*C1_n;
% C2 = R2*H*C2_n;


% for i = 1:1:length(y1(1,:));
%     x_c = liu_2view_triangulate_opt(y1,y2,C1,C2)
%     x(:,i) = pos_cam1 + R1'*x_c(1:3)/x_c(4);
% end

