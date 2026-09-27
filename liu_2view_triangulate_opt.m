function x = liu_2view_triangulate_opt(y1,y2,C1,C2)
%
% x = liu_2view_triangulate_opt(y1, y2, C1, C2)
%

% Given homogeneous image coordinates y1 and y1, and camera matrices C1 and
% C2, this function triangulates the homogeneous coordinates for a 3D point
% x according to the optimal method described by Hartley and Sturm.  x are
% the homogeneous coordinates of the resulting 3D point.
%
% The optimal method implies that two new image coordinates yy1 and yy2 are
% computed which satisfies the epipolar constraint
%
% yy1' * F * yy2 = 0
%
% and the sum of their squared distances to y1 and y2, in the 2D image
% planes, is minimal.  F is the fundamental matrix computed from C1, C2.
% Once yy1 and yy2 are found, any tringulation method will give the same 3D
% point x, and here the homogeneous method is used. 
%
% NOTE: all homogeneous 3D coordinates are of 1-LAST type.
% NOTE: x is not normalized.
% NOTE: requires vgg on path
%
% Klas Nordberg 2009-11-30

[yy1 yy2]=liu_HartleySturm(y1,y2,C1,C2);

% yy1 and yy2 now satisfy yy1'*F1*yy2=0
% and have shortest total squared Euclidean distance to y1, y2
% Use a standard triangulation method to compute x

x = liu_2view_triangulate_hom(yy1, yy2, C1, C2);

return
