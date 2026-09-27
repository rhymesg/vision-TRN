function n = liu_camera_center(C),
%
% n = liu_camera_center(C)
%
% Computes the homogeneous coordinates n of the camera center corresponding
% to camera matrix C.  The camera center satisfies C*n = 0.
%
% NOTE: n is not normalized.
%
% Klas Nordberg 2009-02-09

[U S V] = svd(C);
n = V(:,end)

return
