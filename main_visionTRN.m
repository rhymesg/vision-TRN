% Scalar TRN experiment; paper: https://doi.org/10.1177/0954410017690548
% Scope and citation: docs/method.md and README.md#citation.
clc;
clear;
close all;

TIME = 100;
dt_ins = 1;
dt = 1;

resolution = 20;
data = load('SRTM_N35_to_39_E127_to_129.mat');
terrain = data.SRTM_N35_to_39_E127_to_129;

monte_step = 20;
%%
acc_std = [0.2; 0.2; 0.2];
pqr_std = [0.02; 0.02; 0.02];

num_samples = 1000;

samples_X = zeros(1,num_samples);
samples_A = zeros(1,num_samples);
samples_V = zeros(1,num_samples);

X_std0 = 100;
X_std = 2;
resample_X_std = 1;

A_std0 = 10 * pi/180;
A_std = pqr_std(1) * dt_ins;
resample_A_std = A_std/2;

V_std0 = 2.0;
V_std = acc_std(1) * dt_ins;
resample_V_std = V_std/2;

h_std_3s = 0;
DEM_std = 0;
DEM_bias = 0;
ra_std = 10;

N_meas = 2;
meas_disperse = 100;

ra_std_est = 15;
att_std_est = 3.0 *pi/180;
vel_std_est = 0.5;
V_bias = 0.2;

bar_std = 5.0;
Q = diag([acc_std; pqr_std].*[acc_std; pqr_std]);

acc_true = zeros(3, TIME/dt_ins+1);
pqr_true = zeros(3, TIME/dt_ins+1);
acc = zeros(3, TIME/dt_ins+1);
pqr = zeros(3, TIME/dt_ins+1);

X_true = zeros(9, TIME/dt_ins+1);

X = zeros(1, TIME/dt_ins+1);
A = zeros(1, TIME/dt_ins+1);
V = zeros(1, TIME/dt_ins+1);

%% 

monte_X_est = zeros(monte_step, TIME/dt_ins+1);
monte_X_err = zeros(monte_step, TIME/dt_ins+1);
monte_A_est = zeros(monte_step, TIME/dt_ins+1);
monte_A_err = zeros(monte_step, TIME/dt_ins+1);
monte_V_est = zeros(monte_step, TIME/dt_ins+1);
monte_V_err = zeros(monte_step, TIME/dt_ins+1);

for ii = 1:1:monte_step;

    X_err = zeros(1, TIME/dt_ins+1);
    A_err = zeros(1, TIME/dt_ins+1);
    V_err = zeros(1, TIME/dt_ins+1);
    
    X_true = zeros(9, TIME/dt_ins+1);
    X = zeros(1, TIME/dt_ins+1);
    A = zeros(1, TIME/dt_ins+1);
    V = zeros(1, TIME/dt_ins+1);

    X_true(:,1) = [21000; 12000; 1000; 55; 0; 0; 0; 0; 0];
    
    X_err(1) = 100;
    A_err(1) = 8 * pi/180;
    V_err(1) = -1.2;

    X(1) = X_true(1,1) + X_err(1);   % initial state
    A(1) = X_true(7,1) + A_err(1);
    V(1) = X_true(4,1) + V_err(1);
    
    acc_true = zeros(3, TIME/dt_ins+1);
    pqr_true = zeros(3, TIME/dt_ins+1);
    
    samples_X = generateSamples(X(1), X_std0, num_samples);
    samples_A = generateSamples(A(1), A_std0, num_samples);
    samples_V = generateSamples(V(1), V_std0, num_samples);
    k = 1;
    for t = dt_ins:dt_ins:TIME;
        k = k + 1;

        %%% propagation
        X_true(1:3,k) = X_true(1:3,k-1) + X_true(4:6,k-1)*dt_ins;
        X_true(4:6,k) = X_true(4:6,k-1) + acc_true(:,k-1)*dt_ins;
        X_true(7:9,k) = X_true(7:9,k-1) + pqr_true(:,k-1)*dt_ins;

        acc(:,k-1) = acc_true(:,k-1) + normrnd(0, acc_std);
        pqr(:,k-1) = pqr_true(:,k-1) + normrnd(0, pqr_std);
 
        X(k) = X(k-1) + (V(k-1))*dt_ins;
        V(k) = V(k-1) + acc(1,k-1)*dt_ins;
        A(k) = A(k-1) + pqr(1,k-1)*dt_ins;
        
        if ( abs(mod(t, dt)) < dt_ins/2 )

            % get measurements
            for i = 1:1:N_meas
                x_meas(:,i) = X_true(1:2,k) + normrnd(0, [0; meas_disperse]);
                z_meas(i) = getFeatureHeight_dted(x_meas(1,i), x_meas(2,i), terrain, resolution) + DEM_bias*rand + normrnd(0, ra_std);
            end
            
            % scatter particles
            p = zeros(1,num_samples);
            pv = zeros(1,num_samples);
            pa = zeros(1,num_samples);
            diff = (X(k) - X(k-1));

            for n = 1:1:num_samples;
                
                samples_X(n) = samples_X(n) + diff + normrnd(0, X_std);
                samples_A(n) = samples_A(n) + normrnd(0, A_std);
                samples_V(n) = samples_V(n) + normrnd(0, V_std);
                
                p(n) = 1;
                pa(n) = 1;
                pv(n) = 1;
                for i = 1:1:N_meas;
                    z_est = getFeatureHeight_dted(samples_X(n)+x_meas(1,i), X_true(2,k)+x_meas(2,i), terrain, resolution);
                    d(i) = abs(z_est - z_meas(i));
                    
                    p(n) = p(n) * (1/sqrt(2*pi*ra_std_est^2))*exp(-d(i)^2/2/ra_std_est^2);
                    
                    err_att = abs(samples_A(n) - X_true(7,k) - normrnd(0, att_std_est));
                    pa(n) = pa(n) * (1/sqrt(2*pi*att_std_est^2))*exp(-err_att^2/2/att_std_est^2);
                    
                    err_vel = abs(samples_V(n) - X_true(4,k) - normrnd(0, att_std_est));
                    pv(n) = pv(n) * (1/sqrt(2*pi*vel_std_est^2))*exp(-err_vel^2/2/(vel_std_est*2)^2);
    
                end
                pa(n) = pa(n)*sqrt(p(n));
                
                p(n) = p(n) * (1/sqrt(2*pi*15^2))*exp(-abs( X_true(1,k) - samples_X(n) )^2/2/15^2);

            end         

            psum = sum(p);
            pasum = sum(pa);
            pvsum = sum(pv);
            for n = 1:1:num_samples;
                p(n) = p(n) / psum;
                pa(n) = pa(n) / pasum;
                pv(n) = pv(n) / pvsum;
            end

            cumsum_p = cumsum(p);
            for n = 1:1:num_samples;
                ip = find(rand <= cumsum_p, 1);
                if isempty(ip)
                    ip = 1;
                end
                samples_X_tmp(n) = samples_X(ip);
            end
            
            cumsum_pa = cumsum(pa);
            for n = 1:1:num_samples;
                ip = find(rand <= cumsum_pa, 1);
                if isempty(ip)
                    ip = 1;
                end
                samples_A_tmp(n) = samples_A(ip);
                
            end
            
            cumsum_pv = cumsum(pv);
            for n = 1:1:num_samples;
                ip = find(rand <= cumsum_pv, 1);
                if isempty(ip)
                    ip = 1;
                end
                samples_V_tmp(n) = samples_V(ip); 
            end

            for n = 1:1:num_samples;
                samples_X(n) = samples_X_tmp(n) + normrnd(0, resample_X_std);
                samples_A(n) = samples_A_tmp(n) + normrnd(0, resample_A_std);
                samples_V(n) = samples_V_tmp(n) + normrnd(0, resample_V_std);
            end

            % The estimate is the mean of the particles.
            X(k) = mean(samples_X, 2);
            A(k) = mean(samples_A, 2);
            V(k) = mean(samples_V, 2);

        end    
        
        X_err(k) = X(k) - X_true(1,k);
        A_err(k) = A(k) - X_true(7,k);
        V_err(k) = V(k) - X_true(4,k);
        
    end % main algorithm
    
    monte_X_est(ii,:) = X;
    monte_X_err(ii,:) = X_err;
    monte_A_est(ii,:) = A;
    monte_A_err(ii,:) = A_err;
    monte_V_est(ii,:) = V;
    monte_V_err(ii,:) = V_err;
     
    disp(['Monte-Carlo step ' int2str(ii) '/' int2str(monte_step) ' complete']);
end % montestep

%%
if (monte_step > 1)
    r = 0;
    for ii = 1:1:monte_step

        if (abs(monte_X_err(ii,end)) < 50)
            r = r + 1;
            res_monte_X_est(r,:) = monte_X_est(ii,:);
            res_monte_X_err(r,:) = monte_X_err(ii,:);
        end
    end
    disp(['convergence = ' int2str(r/monte_step*100) '%']);


    monte_X_est_avg = mean(res_monte_X_est, 1);
    monte_X_err_avg = mean(res_monte_X_err, 1);
    monte_A_est_avg = mean(monte_A_est, 1);
    monte_A_err_avg = mean(monte_A_err, 1);
    monte_V_est_avg = mean(monte_V_est, 1);
    monte_V_err_avg = mean(monte_V_err, 1);

    monte_X_err_std = stderr(res_monte_X_err);
    monte_A_err_std = stderr(monte_A_err);
    monte_V_err_std = stderr(monte_V_err) + ones(1,k) * V_bias;

end

time = 0:dt_ins:TIME;
savefile = 'result.mat';
save(savefile);
%%

figure;
subplot(3,1,1);
plot(time, monte_X_err_std, 'b--', 'linewidth', 1.5); 
ylabel('Position Error (m)');

subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'b--', 'linewidth', 1.5); 
ylabel('Attitude Error (deg)');

subplot(3,1,3);
plot(time, monte_V_err_std, 'b--', 'linewidth', 1.5); 
ylabel('Velocity Error (m/s)');
xlabel('Time (sec)');


% figure;
% subplot(3,1,1);
% plot(time, X_true(1,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, X(1,:), 'b--', 'linewidth', 1.5); hold on;
% legend('true', 'estimated');
% ylabel('East (m)');
% 
% subplot(3,1,2);
% plot(time, X_true(2,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, X(2,:), 'b--', 'linewidth', 1.5); hold on;
% ylabel('North (m)');
% 
% subplot(3,1,3);
% plot(time, X_true(3,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, X(3,:), 'b--', 'linewidth', 1.5); hold on;
% ylabel('Up (m)');
% xlabel('Time (sec)');

%%
% figure;
% subplot(3,1,1);
% plot(time, X_true(4,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, X(4,:), 'b--', 'linewidth', 1.5); hold on;
% legend('true', 'estimated');
% ylabel('East velocity (m/s)');
% 
% subplot(3,1,2);
% plot(time, X_true(5,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, X(5,:), 'b--', 'linewidth', 1.5); hold on;
% ylabel('North velocity (m/s)');
% 
% subplot(3,1,3);
% plot(time, X_true(6,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, X(6,:), 'b--', 'linewidth', 1.5); hold on;
% ylabel('Up velocity (m/s)');
% xlabel('Time (sec)');

%%
% figure;
% subplot(3,1,1);
% plot(time, X_true(7,:)*180/pi, 'r', 'linewidth', 1.5); hold on;
% plot(time, X(7,:)*180/pi, 'b--', 'linewidth', 1.5); hold on;
% legend('true', 'estimated');
% ylabel('Roll angle (deg)');
% 
% subplot(3,1,2);
% plot(time, X_true(8,:)*180/pi, 'r', 'linewidth', 1.5); hold on;
% plot(time, X(8,:)*180/pi, 'b--', 'linewidth', 1.5); hold on;
% ylabel('Pitch angle (deg)');
% 
% subplot(3,1,3);
% plot(time, X_true(9,:)*180/pi, 'r', 'linewidth', 1.5); hold on;
% plot(time, X(9,:)*180/pi, 'b--', 'linewidth', 1.5); hold on;
% ylabel('Yaw angle (deg)');
% xlabel('Time (sec)');

%% monte plot
zero = zeros(1, TIME/dt_ins+1);





%%


%
% figure;
% subplot(3,1,1);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(1,:), 'b--', 'linewidth', 1.5); 
% ylabel('East error (m)');
% 
% subplot(3,1,2);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(2,:), 'b--', 'linewidth', 1.5); 
% ylabel('North error (m)');
% 
% subplot(3,1,3);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(3,:), 'b--', 'linewidth', 1.5); 
% ylabel('Up error (m)');
% xlabel('Time (sec)');
%%

% figure;
% subplot(3,1,1);
% plot(time, monte_X_err_std_norm_pos, 'b', 'linewidth', 1.5);
% subplot(3,1,2);
% plot(time, monte_X_err_std_norm_vel, 'b', 'linewidth', 1.5);
% subplot(3,1,3);
% plot(time, monte_X_err_std_norm_att, 'b', 'linewidth', 1.5);


%%
% figure;
% subplot(3,1,1);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(4,:), 'b--', 'linewidth', 1.5); 
% ylabel('East velocity error (m/s)');
% 
% subplot(3,1,2);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(5,:), 'b--', 'linewidth', 1.5); 
% ylabel('North velocity error (m/s)');
% 
% subplot(3,1,3);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(6,:), 'b--', 'linewidth', 1.5); 
% ylabel('Up velocity error (m/s)');
% xlabel('Time (sec)');

%%
% figure;
% subplot(3,1,1);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(7,:)*180/pi, 'b--', 'linewidth', 1.5); 
% ylabel('Roll angle error (deg)');
% 
% subplot(3,1,2);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(8,:)*180/pi, 'b--', 'linewidth', 1.5); 
% ylabel('Pitch angle error (deg)');
% 
% subplot(3,1,3);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
% plot(time, monte_X_err_avg(9,:)*180/pi, 'b--', 'linewidth', 1.5); 
% ylabel('Yaw angle error (deg)');
% xlabel('Time (sec)');

% %%
% figure;
% subplot(2,1,1);
% plot(time, monte_X_err_norm_pos_avg, 'b--', 'linewidth', 1.5);
% 
% subplot(2,1,2);
% plot(time, monte_X_err_norm_att_avg*180/pi, 'b--', 'linewidth', 1.5);

%%
% figure;
% plot(time, monte_X_err_norm_vel_avg, 'b--', 'linewidth', 1.5);

%%
% x_features = [530; 900; getFeatureHeight_dted(530, 900, terrain, resolution);
%               600; 660; getFeatureHeight_dted(600, 660, terrain, resolution);
%               900; 740; getFeatureHeight_dted(900, 740, terrain, resolution);
%               700; 1000; getFeatureHeight_dted(700, 1000, terrain, resolution)];
% 
% terrainRect = [300 1100 500 1300];
% terrainX(1) = terrainRect(1);
% terrainY(1) = terrainRect(3);
% m = floor((terrainRect(2)-terrainRect(1))/resolution);
% n = floor((terrainRect(4)-terrainRect(3))/resolution);
% for i = 2:1:m;
%     terrainX(i) = terrainX(i-1) + resolution;
% end
% for j = 2:1:n;
%     terrainY(j) = terrainY(j-1) + resolution;
% end
% for i = 1:1:m;
%     for j = 1:1:n;
%         terrainSurf(i,j) = getFeatureHeight_dted(terrainX(i), terrainY(j), terrain, resolution); 
%     end
% end

% figure;
% hold on;
% plot3(x_features(1), x_features(2), x_features(3)+50, 'rd', 'linewidth', 3); 
% plot3(X_true(1,:), X_true(2,:), X_true(3,:), 'k', 'linewidth', 2); 
% surf(terrainX, terrainY, terrainSurf); 
% plot3(x_features(4), x_features(5), x_features(6), 'rd', 'linewidth', 3);
% plot3(x_features(7), x_features(8), x_features(9)+50, 'rd', 'linewidth', 3);
% plot3(x_features(10), x_features(11), x_features(12), 'rd', 'linewidth', 3);
% xlabel('East (m)');
% ylabel('North (m)');
% zlabel('Up (m)');
% grid on;
% legend('feature point', 'UAV trajectory');

%%

% figure;
% subplot(3,1,1);
% plot(time, vn_true(1,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, vn_est(1,:), 'b--', 'linewidth', 1.5);
% legend('true', 'estimated');
% ylabel('Norm of vel_E');
% 
% subplot(3,1,2);
% plot(time, vn_true(2,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, vn_est(2,:), 'b--', 'linewidth', 1.5);
% ylabel('Norm of vel_N');
% 
% subplot(3,1,3);
% plot(time, vn_true(3,:), 'r', 'linewidth', 1.5); hold on;
% plot(time, vn_est(3,:), 'b--', 'linewidth', 1.5);
% ylabel('Norm of vel_U');
% xlabel('Time (sec)'); 
