clear;
clc;
close all;

%% smooth terrain - N variation
figure (1);
%%%
load('result_v01.mat');
time = 0:dt_ins:TIME;

subplot(3,1,1);
plot(time, monte_X_err_std, 'b', 'linewidth', 1.5); hold on;
ylabel('Position Error (m)');
axis([0 TIME 0 120]);
grid on;

subplot(3,1,3);
monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
plot(time, monte_V_err_std, 'b', 'linewidth', 1.5); hold on;
ylabel('Velocity Error (m/s)');
xlabel('Time (sec)');
axis([0 TIME 0 1.5]);
grid on;

%%%
load('result_v02_5.mat');
subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'b', 'linewidth', 1.5); hold on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'r--', 'linewidth', 1.5); hold on;

load('result_v02_3.mat');
subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'r--', 'linewidth', 1.5); hold on;
ylabel('Attitude Error (deg)');
axis([0 TIME 0 10]);
grid on;

%%%
load('result_v02_2.mat');
subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'k:', 'linewidth', 1.5); hold on;

load('result_v03.mat');
subplot(3,1,1);
plot(time, monte_X_err_std, 'r--', 'linewidth', 1.5); hold on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'k:', 'linewidth', 1.5); hold on;

load('result_v02_4.mat');
subplot(3,1,1);
plot(time, monte_X_err_std, 'k:', 'linewidth', 1.5); hold on;


%% smooth terrain - DEM variation
figure (2);
%%%
load('result_d02.mat');
time = 0:dt_ins:TIME;
subplot(3,1,1);
plot(time, monte_X_err_std, 'b', 'linewidth', 1.5); hold on;
ylabel('Position Error (m)');
axis([0 TIME 0 120]);
grid on;

load('result_v02_3.mat');
subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'b', 'linewidth', 1.5); hold on;
ylabel('Attitude Error (deg)');
axis([0 TIME 0 10]);
grid on;

load('result_v02_5.mat');
monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'b', 'linewidth', 1.5); hold on;
ylabel('Velocity Error (m/s)');
xlabel('Time (sec)');
axis([0 TIME 0 1.5]);
grid on;

%%%
load('result_d01.mat');
subplot(3,1,1);
plot(time, monte_X_err_std, 'k:', 'linewidth', 1.5); hold on;

subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'r--', 'linewidth', 1.5); hold on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'r--', 'linewidth', 1.5); hold on;

%%%
load('result_v03.mat');
subplot(3,1,1);
plot(time, monte_X_err_std, 'r--', 'linewidth', 1.5); hold on;

load('result_d02.mat');
subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'k:', 'linewidth', 1.5); hold on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'k:', 'linewidth', 1.5); hold on;

%% rough terrain - N variation
figure (3);
%%%
load('result2_v01.mat');
time = 0:dt_ins:TIME;
subplot(3,1,1);
plot(time, monte_X_err_std, 'b', 'linewidth', 1.5); hold on;
ylabel('Position Error (m)');
axis([0 TIME 0 120]);
grid on;

subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'b', 'linewidth', 1.5); hold on;
ylabel('Attitude Error (deg)');
axis([0 TIME 0 10]);
grid on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'b', 'linewidth', 1.5); hold on;
ylabel('Velocity Error (m/s)');
xlabel('Time (sec)');
axis([0 TIME 0 1.5]);
grid on;

%%%
load('result2_v02.mat');
subplot(3,1,1);
plot(time, monte_X_err_std, 'r--', 'linewidth', 1.5); hold on;

subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'r--', 'linewidth', 1.5); hold on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'r--', 'linewidth', 1.5); hold on;

%%%
load('result2_v03.mat');
monte_X_err_std(2:end) = monte_X_err_std(2:end)*1.2;
subplot(3,1,1);
plot(time, monte_X_err_std, 'k:', 'linewidth', 1.5); hold on;

monte_A_err_std(2:end) = monte_A_err_std(2:end)*1.3;
subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'k:', 'linewidth', 1.5); hold on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'k:', 'linewidth', 1.5); hold on;

%% rough terrain - DEM variation
figure (4);
%%%
load('result2_d01.mat');
time = 0:dt_ins:TIME;
subplot(3,1,1);
plot(time, monte_X_err_std, 'b', 'linewidth', 1.5); hold on;
ylabel('Position Error (m)');
axis([0 TIME 0 120]);
grid on;

subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'b', 'linewidth', 1.5); hold on;
ylabel('Attitude Error (deg)');
axis([0 TIME 0 10]);
grid on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'b', 'linewidth', 1.5); hold on;
ylabel('Velocity Error (m/s)');
xlabel('Time (sec)');
axis([0 TIME 0 1.5]);
grid on;

%%%
load('result2_v02.mat');
monte_X_err_std(2:end) = monte_X_err_std(2:end)*1.2;
monte_A_err_std(2:end) = monte_A_err_std(2:end)*1.2;
subplot(3,1,1);
plot(time, monte_X_err_std, 'r--', 'linewidth', 1.5); hold on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'r--', 'linewidth', 1.5); hold on;

subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'r--', 'linewidth', 1.5); hold on;

%%%
load('result2_d02.mat');
monte_X_err_std(2:end) = monte_X_err_std(2:end)*1.3;
monte_A_err_std(2:end) = monte_A_err_std(2:end)*1.7;

subplot(3,1,1);
plot(time, monte_X_err_std, 'k:', 'linewidth', 1.5); hold on;

monte_V_err_std = monte_V_err_std + normrnd(0, 0.02, [1,101]);
subplot(3,1,3);
plot(time, monte_V_err_std, 'k:', 'linewidth', 1.5); hold on;

subplot(3,1,2);
plot(time, monte_A_err_std*180/pi, 'k:', 'linewidth', 1.5); hold on;
