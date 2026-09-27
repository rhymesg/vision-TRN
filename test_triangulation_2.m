% clc;
clear;
% close all;


pos_cam1 = [300; 500; 500];
pos_cam2 = [350; 500; 500];
euler1 = [10; 0; 0]*pi/180;
euler2 = [0; 0; 0]*pi/180;
f = 700;  % focal length
nx = 720; % number of pixels on x-axis
ny = 480; % number of pixels on y-axis
pixel_err_std = 3.0; % standard deviation of gaussian pixel noise
subpixel = 0; % if 0, do 'round' and pixels become integers
camera = [f; nx; ny; pixel_err_std; subpixel];

resolution = 30;
[terrain, features] = loadTerrainAndFeatureMap(resolution, 3);

indices = getMatchedPoints(pos_cam1, pos_cam2, euler1, euler2, features, camera);
for k = 1:1:length(indices)
    [y1_set(:,k), y2_set(:,k)] = getImageMeasurement(features(:,indices(k)), pos_cam1, pos_cam2, euler1, euler2, camera);
end

%% errors from h error

% hError = (0:0.01:1)*50;
% d_res = zeros(1,length(hError));
% for k = 1:1:length(hError)
%     euler1_n = euler1;
%     euler2_n = euler2;
%     
%     for i = 1:1:1;
%         x_est(:,k) = estimateFeaturePosition(y1_set(:,i), y2_set(:,i), pos_cam1, pos_cam2, euler1_n, euler2_n, camera);
%         x_err(:,k) = features(:,indices(i)) - x_est(:,k);
%         z_mea = x_est(3,k) + hError(k);
%         z_est = getFeatureHeight_dted(x_est(1,k), x_est(2,k), terrain, resolution);
%         
%         d = abs(z_est - z_mea);
%         d_res(k) = d_res(k) + d;
%     end
%     
% end

% figure;
% subplot(3,1,1);
% plot(hError, abs(x_err(1,:)), 'linewidth', 1.5);grid on;
% ylabel('X Error (m)');
% subplot(3,1,2);
% plot(hError, abs(x_err(2,:)), 'linewidth', 1.5);grid on;
% ylabel('Y Error (m)');
% subplot(3,1,3);
% plot(hError, abs(x_err(3,:)), 'linewidth', 1.5);grid on;
% ylabel('Z Error (m)');
% xlabel('Body Angle Error (deg)');
% 
% figure;
% plot(hError, d_res, 'linewidth', 1.5);grid on;
% ylabel('Residual ''d'' (m)');
% xlabel('h Error (m)');

%%

nSample = 1000;
% h_std_3s = 25;
h_std_3s = 0;
% hError = abs(h_std_3s*randn([1,nSample]));
d_res = zeros(1,nSample);
for k = 1:1:nSample
    euler1_n = euler1;
    euler2_n = euler2;
    
    for i = 1:1:length(indices);
        x_est(:,k) = estimateFeaturePosition(y1_set(:,i), y2_set(:,i), pos_cam1, pos_cam2, euler1_n, euler2_n, camera);
        x_err(:,k) = features(:,indices(i)) - x_est(:,k);
        z_mea = x_est(3,k) + abs(normrnd(0,h_std_3s/3));%hError(k);
        z_est = getFeatureHeight_dted(x_est(1,k), x_est(2,k), terrain, resolution) + normrnd(0,4.71);
        
        d = abs(z_est - z_mea);
        d_res(k) = d_res(k) + d;
    end
%     d_res(k) = d_res(k) / length(indices);
end
% 
[f, x] = hist(d_res, 10);

figure;
cm = colormap('gray');
bar(x, f/sum(f*diff(x(1:2))), 'FaceColor', cm(52,:), 'BarWidth', 1, 'LineWidth', 1);
grid on;
xlabel('sum d (m)');
ylabel('Probability');
% axis([0 14 0 0.7]);
hold on;


resDist = fitdist(d_res', 'normal')


%%
a = 25;
b = 125;
for k = 1:1:nSample;
    
    d_sample(k) = a + (k-1)*(b-a)/nSample;
%     p_d(k) = exp(-d_sample(k)^2);

end

sig = resDist.sigma;
m = resDist.mu;
p_d = 1/sqrt(2*pi)/sig*exp(-(d_sample-m*ones(1,nSample)).^2/(2*sig^2));
% p_d = exp(-0.8*abs(d_sample-m*ones(1,nSample)));

% p_d = p_d / sum(p_d) * nSample;
p_d = p_d / sum(p_d*(b-a)/nSample);

sum(p_d*(b-a)/nSample)

plot(d_sample, p_d, 'k-.', 'Linewidth', 1);

%%

nSample = 1000;
h_std_3s = 25;
% h_std_3s = 0;
% hError = abs(h_std_3s*randn([1,nSample]));
d_res = zeros(1,nSample);
for k = 1:1:nSample
    euler1_n = euler1;
    euler2_n = euler2;
    
    for i = 1:1:length(indices);
        x_est(:,k) = estimateFeaturePosition(y1_set(:,i), y2_set(:,i), pos_cam1, pos_cam2, euler1_n, euler2_n, camera);
        x_err(:,k) = features(:,indices(i)) - x_est(:,k);
        z_mea = x_est(3,k) + abs(normrnd(0,h_std_3s/3));
        z_est = getFeatureHeight_dted(x_est(1,k), x_est(2,k), terrain, resolution) + normrnd(0,4.71);
        
        d = abs(z_est - z_mea);
        d_res(k) = d_res(k) + d;
    end
%     d_res(k) = d_res(k) / length(indices);
end
% 
[f, x] = hist(d_res, 10);
bar(x, f/sum(f*diff(x(1:2))), 'FaceColor', cm(60,:), 'BarWidth', 1, 'LineWidth', 1); hold on

resDist = fitdist(d_res', 'normal')

%%
a = 60;
b = 260;
for k = 1:1:nSample;
    
    d_sample(k) = a + (k-1)*(b-a)/nSample;
%     p_d(k) = exp(-d_sample(k)^2);

end

sig = resDist.sigma;
m = resDist.mu;
p_d = 1/sqrt(2*pi)/sig*exp(-(d_sample-m*ones(1,nSample)).^2/(2*sig^2));
% p_d = exp(-0.8*abs(d_sample-m*ones(1,nSample)));

% p_d = p_d / sum(p_d) * nSample;
p_d = p_d / sum(p_d*(b-a)/nSample);

sum(p_d*(b-a)/nSample)

plot(d_sample, p_d, 'k--', 'Linewidth', 1); hold on;


% legend('DEM Error', 'sum d ~ N(74.2, 13.4^2)', 'DEM + Surface Error', 'sum d ~ N(152, 24.7^2)');
