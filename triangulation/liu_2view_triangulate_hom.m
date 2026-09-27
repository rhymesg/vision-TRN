function x = liu_2view_triangulate_hom(y1, y2, C1, C2),
%
% x = liu_2view_triangulate_hom(y1, y2, C1, C2)
%
% Given homogeneous image coordinates y1 and y1, and camera matrices C1 and
% C2, this function triangulates the homogeneous coordinates for a 3D point
% x according to the homogeneous method.  x are the homogeneous coordinates
% of the resulting 3D point.
%
% The homogeneous method implies that from the initial equations
%
% y1 ~ C1 * x
% y2 ~ C2 * x
%
% we can form two homogeneous equations accoring to
%
% 0 = vgg_contreps(y1) * C1 * x
% 0 = vgg_contreps(y2) * C2 * x
%
% which in turn can be written as one homogeneous equation in x
%
% 0 = M * x
%
% where M is a 6x4 matrix given by y1,y2,C1,C2.  x is then found as the
% right singualar vector of M of zero (smallest) singular value.
%
% NOTE: x is not normalized.
% NOTE: requires vgg on path
%
% Klas Nordberg 2009-11-30

M = [vgg_contreps(y1)*C1;...
     vgg_contreps(y2)*C2];

[U S V]=svd(M);

x = V(:,end);

return
