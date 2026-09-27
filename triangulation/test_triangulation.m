clc;
clear;


pos_cam1 = [10; 10; 20];
pos_cam2 = [12; 10; 20];
pos_feat = [10; 15; 2];
f = 700;

[y1, y2] = getFeatureMeasurements(pos_feat, pos_cam1, pos_cam2, 0, 0, f);

%% triangulation
x_est = estimateFeaturePosition(y1, y2, pos_cam1, pos_cam2, 0, 0, f)
feature_true = pos_feat

% 
% liu_2view_triangulate_opt(y1,y2,C1,C2);
% 
%  pos_diff_prev = pos_feature - pos_uav_prev;
%     pos_diff_prev(3) = -pos_diff_prev(3);
%     x1(:,k) = C*pos_diff_prev;
%     x1(:,k) = x1(:,k)/x1(3,k) + normrnd(0, pixel_err_std);
%     x1(3,k) = 1;
% 
%     pos_diff_curr = pos_feature - pos_uav_curr;
%     pos_diff_curr(3) = -pos_diff_curr(3);
%     x2(:,k) = C*pos_diff_curr;
%     x2(:,k) = x2(:,k)/x2(3,k) + normrnd(0, pixel_err_std);
%     x2(3,k) = 1;
%     