close all
clear all;

resolution = 30;
data = load('SRTM_N35_to_39_E127_to_129.mat');
terrain = data.SRTM_N35_to_39_E127_to_129;

% % smooth
xm = floor(12000/resolution);
ym = floor(8000/resolution);

% % rough
% xm = floor(26000/resolution);
% ym = floor(14000/resolution);

y_max = ym + 20;
y_min = ym - 20;
x_max = xm + floor(5000/resolution)+20;
x_min = xm - 20;

x_mesh              = x_min:x_max;
y_mesh              = y_min:y_max;
[X_mesh, Y_mesh]    = meshgrid(x_mesh, y_mesh);
z_mesh              = terrain(x_mesh, y_mesh)';
z_mesh(1,1) = 0;
z_mesh(1,2) = 600;

[xi, yi] = meshgrid(x_min : 1 : x_max, y_min : 1 : y_max);

zi = interp2(X_mesh, Y_mesh, z_mesh, xi, yi, 'spline');

mean(var(zi',0))

figure()
contourf(xi,yi,zi)
colormap('gray');
hold on;
axis ([x_min x_max y_min y_max]);
axis equal;
plot(xm, ym, 'rs', 'linewidth', 2);
plot(xm+floor(5000/resolution), ym, 'ro', 'linewidth', 2);
