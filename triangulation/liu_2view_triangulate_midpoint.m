function x = liu_2view_triangulate_midpoint(y1,y2,C1,C2),
%
% x = liu_2view_triangulate_midpoint(y1, y2, C1, C2)
%

% Given homogeneous image coordinates y1 and y1, and camera matrices C1 and
% C2, this function triangulates the homogeneous coordinates for a 3D point
% x according to the min-point method.  x are the homogeneous coordinates
% of the resulting 3D point.
%
% The mid-point method implies that the 3D point x is found lying at the
% center of the line which is the shortest line that can be drawn from the
% projection lines of the image points y1 and y2.
%
% NOTE: all homogeneous 3D coordinates are of 1-LAST type.
% NOTE: x is not normalized.
% NOTE: requires vgg on path
%
% Klas Nordberg 2009-11-30

% Find the focal points n1 and n2 of each of the cameras
n1h=liu_camera_center(C1);  % hom coord
n2h=liu_camera_center(C2);
n1=vgg_get_nonhomg(n1h);    % inhom coord
n2=vgg_get_nonhomg(n2h);

% For each image point, find a 3D point z1 and z2 on its projection line
% which is distinct from the camera center
z1h=C1'*inv(C1*C1')*y1;
z2h=C2'*inv(C2*C2')*y2;
z1=vgg_get_nonhomg(z1h);
z2=vgg_get_nonhomg(z2h);

% We want to find 3D points x1, x2 with smallest distance between them,
% such that
%
% x1 = (1-t1)*n1 + t1*z1
% x2 = (1-t2)*n2 + t2*z2
%
% for scalars t1, t2 to be determined.  t1,t2 are the solution to
%
% [d1.d1 -d1.d2][t1] = [d1.dn]
% [d2.d1 -d2.d2][t2] = [d2.dn]
%
% where d1=z1-n1, d2=z2-n2, dn = n2-n1

% Find the direction vector from n1 to z1, and from n2 to z2
d1=z1-n1;
d2=z2-n2;
dn=n2-n1;

A=[d1'*d1 -d1'*d2;d1'*d2 -d2'*d2];
b=[d1'*dn;d2'*dn];

t=inv(A)*b;

% x1 and x2 are the 3D points on each of the two projection lines which are
% closest to the other line
x1=vgg_get_homg((1-t(1))*n1+t(1)*z1);
x2=vgg_get_homg((1-t(2))*n2+t(2)*z2);

% Compute point which lies between x1 and x2
x=x1+x2;

return
