function x = liu_2view_triangulate_inhom(y1,y2,C1,C2)
%
% x = liu_2view_triangulate_inhom(y1, y2, C1, C2)
%
% Given homogeneous image coordinates y1 and y1, and camera matrices C1 and
% C2, this function triangulates the homogeneous coordinates for a 3D point
% x according to the inhomogeneous method.  x are the homogeneous coordinates
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
% where M is a 6x4 matrix given by y1,y2,C1,C2.  Given that x is in
% homogeneous coordinates accoring to x=[x1 x2 x3 1]', this equation can be
% rewritten as an inhomogeneous equation in [x1 x2 x3]:
%
% 0 = M(:,4) + M(:,1:3)*[x1 x2 x3]' = b + A * [x1 x2 x3]';
%
% The 3D coordinates can then by found by solving the corresonding least
% squares problem.
% This method degenerates when x is a point at infinity.
%
% NOTE: x is 1-LAST.
% NOTE: requires vgg on path
%
% Klas Nordberg 2009-11-30

M = [vgg_contreps(y1)*C1;vgg_contreps(y2)*C2];
b = M(:,end);
A = M(:,1:3);
x = vgg_get_homg(-inv(A'*A)*A'*b);

return
