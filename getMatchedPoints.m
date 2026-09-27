function [ indices ] = getMatchedPoints(pos_cam1, pos_cam2, euler1, euler2, features, camera)
% Youngjoo Kim, 2013.11.29.
%GETMATCHEDPOINTS 
%   Return indices of feature points within both camera footprints.
%
% INPUT
% pos_uav_prev, pos_uav_curr: true positions of uav on navigation frame
% features : 3 by n database of positions of features on navigation frame
% camera : camera model
%
% OUTPUT
% indices : indices of the corresponding feature points in 'features' array

indices = [];
f = camera(1);
nx = camera(2);
ny = camera(3);
AOF_x = 2*atan2(nx/2, f); % angle of field along x-axis
AOF_y = 2*atan2(ny/2, f); % angle of field along y-axis

% get shared region
xmax = min(pos_cam1(1) + tan(AOF_x/2)*pos_cam1(3), pos_cam2(1) + tan(AOF_x/2)*pos_cam2(3));
xmin = max(pos_cam1(1) - tan(AOF_x/2)*pos_cam1(3), pos_cam2(1) - tan(AOF_x/2)*pos_cam2(3));
ymax = min(pos_cam1(2) + tan(AOF_y/2)*pos_cam1(3), pos_cam2(2) + tan(AOF_y/2)*pos_cam2(3));
ymin = max(pos_cam1(2) - tan(AOF_y/2)*pos_cam1(3), pos_cam2(2) - tan(AOF_y/2)*pos_cam2(3));

if (xmax <= xmin || ymax <= ymin)
    disp('Error: no shared region between two images'); 
    return;
end

% search points on the shared region
for k = 1:1:size(features, 2)
    if (features(1,k) < xmax && features(1,k) > xmin && features(2,k) < ymax && features(2,k) > ymin)
        indices = [indices k];
    end
end

if (length(indices) < 5)
    disp('Error: insufficient number of matched points'); 
    return;
end


