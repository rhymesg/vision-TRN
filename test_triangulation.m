% clc;
clear;
close all;


pos_cam1 = [300; 500; 500];
pos_cam2 = [350; 500; 500];
euler1 = [10; 0; 0]*pi/180;
euler2 = [0; 0; 0]*pi/180;
f = 700;  % focal length
nx = 720; % number of pixels on x-axis
ny = 480; % number of pixels on y-axis
pixel_err_std = 0.0; % standard deviation of gaussian pixel noise
subpixel = 1; % if 0, do 'round' and pixels become integers
camera = [f; nx; ny; pixel_err_std; subpixel];

resolution = 30;
[terrain, features] = loadTerrainAndFeatureMap(resolution);

indices = getMatchedPoints(pos_cam1, pos_cam2, euler1, euler2, features, camera);
for k = 1:1:length(indices)
    [y1_set(:,k), y2_set(:,k)] = getImageMeasurement(features(:,indices(k)), pos_cam1, pos_cam2, euler1, euler2, camera);
end

%% errors from body angle error

angleError = (-1:0.01:1)*5;
d_res = zeros(1,length(angleError));
for k = 1:1:length(angleError)
    euler1_n = euler1 + [angleError(k); 0; 0]*pi/180;
    euler2_n = euler2;
    
    for i = 1:1:1;
        x_est(:,k) = estimateFeaturePosition(y1_set(:,i), y2_set(:,i), pos_cam1, pos_cam2, euler1_n, euler2_n, camera);
        x_err(:,k) = features(:,indices(i)) - x_est(:,k);
        z_mea = x_est(3,k);
        z_est = getFeatureHeight_dted(x_est(1,k), x_est(2,k), terrain, resolution);
        
        d = abs(z_est - z_mea);
        d_res(k) = d_res(k) + d;
    end
    
end

figure;
subplot(3,1,1);
plot(angleError, abs(x_err(1,:)), 'linewidth', 1.5);grid on;
ylabel('X Error (m)');
subplot(3,1,2);
plot(angleError, abs(x_err(2,:)), 'linewidth', 1.5);grid on;
ylabel('Y Error (m)');
subplot(3,1,3);
plot(angleError, abs(x_err(3,:)), 'linewidth', 1.5);grid on;
ylabel('Z Error (m)');
xlabel('Body Angle Error (deg)');

figure;
plot(angleError, d_res, 'linewidth', 1.5);grid on;
ylabel('Residual ''d'' (m)');
xlabel('Body Angle Error (deg)');

%% errors from altitude error

AltitudeError = (-1:0.01:1)*10;
d_res = zeros(1,length(AltitudeError));
for k = 1:1:length(angleError)
   
    pos_cam2_n = pos_cam2 + [0; 0; AltitudeError(k)];
    
    for i = 1:1:1;
        x_est(:,k) = estimateFeaturePosition(y1_set(:,i), y2_set(:,i), pos_cam1, pos_cam2_n, euler1, euler2, camera);
        x_err(:,k) = features(:,indices(i)) - x_est(:,k);

        z_mea = x_est(3,k);
        z_est = getFeatureHeight_dted(x_est(1,k), x_est(2,k), terrain, resolution);
        d = abs(z_est - z_mea);
        d_res(k) = d_res(k) + d;
    end
end

figure;
subplot(3,1,1);
plot(AltitudeError, abs(x_err(1,:)), 'linewidth', 1.5);grid on;
ylabel('X Error (m)');
subplot(3,1,2);
plot(AltitudeError, abs(x_err(2,:)), 'linewidth', 1.5);grid on;
ylabel('Y Error (m)');
subplot(3,1,3);
plot(AltitudeError, abs(x_err(3,:)), 'linewidth', 1.5); grid on;
ylabel('Z Error (m)');
xlabel('Altitude Error (m)');

figure;
plot(AltitudeError, d_res, 'linewidth', 1.5);grid on;
ylabel('Residual ''d'' (m)');
xlabel('Altitude Error (m)');

%% errors from y error

YError = (-1:0.01:1)*10;
d_res = zeros(1,length(YError));
for k = 1:1:length(angleError)
   
    pos_cam2_n = pos_cam2 + [0; YError(k); 0];
    
    for i = 1:1:1;
        x_est(:,k) = estimateFeaturePosition(y1_set(:,i), y2_set(:,i), pos_cam1, pos_cam2_n, euler1, euler2, camera);
        x_err(:,k) = features(:,indices(i)) - x_est(:,k);

        z_mea = x_est(3,k);
        z_est = getFeatureHeight_dted(x_est(1,k), x_est(2,k), terrain, resolution);
        d = abs(z_est - z_mea);
        d_res(k) = d_res(k) + d;
    end
end

figure;
subplot(3,1,1);
plot(YError, abs(x_err(1,:)), 'linewidth', 1.5);grid on;
ylabel('X Error (m)');
subplot(3,1,2);
plot(YError, abs(x_err(2,:)), 'linewidth', 1.5);grid on;
ylabel('Y Error (m)');
subplot(3,1,3);
plot(YError, abs(x_err(3,:)), 'linewidth', 1.5); grid on;
ylabel('Z Error (m)');
xlabel('(camera position) Y Error (m)');

figure;
plot(YError, d_res, 'linewidth', 1.5);grid on;
ylabel('Residual ''d'' (m)');
xlabel('(camera position) Y Error (m)');


