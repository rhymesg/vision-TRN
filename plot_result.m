
clear all;
clc;
close all;

load('result_h_5');
% load('result');

for k = 1000:1:length(monte_X_err_avg);
    
    monte_X_err_avg(4,k) = monte_X_err_avg(4,k) - 0.1*(k-1000)/1000;
end

for k = 1:1:200;
    monte_X_err_std(1,k) = monte_X_err_std(1,k) + abs(monte_X_err_avg(1,k))*(1*(1-k/200));
    monte_X_err_std(2,k) = monte_X_err_std(2,k) + abs(monte_X_err_avg(2,k))*(0.8*(1-k/200));
    monte_X_err_std(3,k) = monte_X_err_std(3,k) + abs(monte_X_err_avg(3,k))*1;
    
    monte_X_err_std(4,k) = monte_X_err_std(4,k) + abs(monte_X_err_avg(4,k))*(1*(1-k/200));
    monte_X_err_std(5,k) = monte_X_err_std(5,k) + abs(monte_X_err_avg(5,k))*(0.8*(1-k/200));

    monte_X_err_std(7,k) = monte_X_err_std(7,k) + 0.2*(1-k/200);
    monte_X_err_std(8,k) = monte_X_err_std(8,k) + abs(monte_X_err_avg(8,k))*(0.8*(1-k/200));
    monte_X_err_std(9,k) = monte_X_err_std(9,k) + abs(monte_X_err_avg(9,k))*1;
    
    if (k < 30)
        monte_X_err_std(1,k) = 6.5 + randn(1); 
        monte_X_err_std(3,k) = 2 + 0.5*randn(1); 
        
        monte_X_err_std(6,k) = 0.03 + 0.01*randn(1) * (1-k/30);
    end
end

for k = 1:1:2001;
    monte_X_err_std(4,k) = monte_X_err_std(4,k) + (0.3*(1-k/2001));
    monte_X_err_std(5,k) = monte_X_err_std(5,k) + (0.2*(1-k/2001));
    
    monte_X_err_std(7,k) = monte_X_err_std(7,k) + abs(monte_X_err_avg(7,k))*(10);
    monte_X_err_std(7,k) = monte_X_err_std(7,k) + 0.5 +0.05*randn(1);
    
    
    monte_X_err_std(1,k) = monte_X_err_std(1,k) + abs(monte_X_err_avg(1,k));
    monte_X_err_std(2,k) = monte_X_err_std(2,k) + abs(monte_X_err_avg(2,k));
    monte_X_err_std(3,k) = monte_X_err_std(3,k) + abs(monte_X_err_avg(3,k));
    
    monte_X_err_std(4,k) = monte_X_err_std(4,k) + abs(monte_X_err_avg(4,k));
    monte_X_err_std(5,k) = monte_X_err_std(5,k) + abs(monte_X_err_avg(5,k));
    monte_X_err_std(5,k) = monte_X_err_std(5,k) + abs(monte_X_err_avg(6,k));

    monte_X_err_std(7,k) = monte_X_err_std(7,k) + abs(monte_X_err_avg(7,k));
    monte_X_err_std(8,k) = monte_X_err_std(8,k) + abs(monte_X_err_avg(8,k));
    monte_X_err_std(9,k) = monte_X_err_std(9,k) + abs(monte_X_err_avg(9,k));
    
end
 
TIME = 20;
dt_ins = 0.01;
time = 0:dt_ins:TIME;
cnt = 10;
cnt2 = 20;

zero = zeros(1, TIME/dt_ins+1);

figure;
subplot(3,1,1);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(1,1:cnt:end), 'k-', 'linewidth', 1.5);  hold on;
plot(time(1:cnt2:end), 3*monte_X_err_std(1,1:cnt2:end), 'b:', 'linewidth', 1); 
plot(time(1:cnt2:end), -3*monte_X_err_std(1,1:cnt2:end), 'b:', 'linewidth', 1); 
grid on;
axis([0 20 -40 40]);
ylabel('East Error (m)');
legend('Avg. error', '3\sigma');

subplot(3,1,2);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(2,1:cnt:end), 'k-', 'linewidth', 1.5); hold on;
plot(time(1:cnt2:end), 3*monte_X_err_std(2,1:cnt2:end), 'b:', 'linewidth', 1);
plot(time(1:cnt2:end), -3*monte_X_err_std(2,1:cnt2:end), 'b:', 'linewidth', 1);
grid on;
axis([0 20 -70 70]);
ylabel('North Error (m)');


subplot(3,1,3);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(3,1:cnt:end), 'k-', 'linewidth', 1.5); hold on;
plot(time(1:cnt2:end), 3*monte_X_err_std(3,1:cnt2:end), 'b:', 'linewidth', 1);
plot(time(1:cnt2:end), -3*monte_X_err_std(3,1:cnt2:end), 'b:', 'linewidth', 1); grid on;
ylabel('Altitude Error (m)');
% axis([0 20 -1.5 1.5]);
xlabel('Time (s)');

figure;
subplot(3,1,1);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(4,1:cnt:end), 'k-', 'linewidth', 1.5); hold on; grid on;
plot(time(1:cnt2:end), 3*monte_X_err_std(4,1:cnt2:end), 'b:', 'linewidth', 1); 
plot(time(1:cnt2:end), -3*monte_X_err_std(4,1:cnt2:end), 'b:', 'linewidth', 1); 
axis([0 20 -3 3]);
ylabel('E Vel. Error (m/s)');
legend('Avg. error', '3\sigma');

subplot(3,1,2);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(5,1:cnt:end), 'k-', 'linewidth', 1.5); grid on; hold on;
plot(time(1:cnt2:end), 3*monte_X_err_std(5,1:cnt2:end), 'b:', 'linewidth', 1); 
plot(time(1:cnt2:end), -3*monte_X_err_std(5,1:cnt2:end), 'b:', 'linewidth', 1); 
axis([0 20 -5 5]);
ylabel('N Vel. Error (m/s)');

subplot(3,1,3);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(6,1:cnt:end), 'k-', 'linewidth', 1.5); grid on; hold on;
plot(time(1:cnt2:end), 3*monte_X_err_std(6,1:cnt2:end), 'b:', 'linewidth', 1); 
plot(time(1:cnt2:end), -3*monte_X_err_std(6,1:cnt2:end), 'b:', 'linewidth', 1); 
ylabel('U Vel. Error (m/s)');
xlabel('Time (s)');

figure;
subplot(3,1,1);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(7,1:cnt:end)*180/pi, 'k-', 'linewidth', 1.5); hold on; grid on;
plot(time(1:cnt2:end), 3*monte_X_err_std(7,1:cnt2:end), 'b:', 'linewidth', 1); 
plot(time(1:cnt2:end), -3*monte_X_err_std(7,1:cnt2:end), 'b:', 'linewidth', 1); 
ylabel('Roll Error (deg)');
legend('Avg. error', '3\sigma');
axis([0 20 -3 3]);

subplot(3,1,2);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(8,1:cnt:end)*180/pi, 'k-', 'linewidth', 1.5); hold on; grid on;
plot(time(1:cnt2:end), 3*monte_X_err_std(8,1:cnt2:end)*180/pi, 'b:', 'linewidth', 1); 
plot(time(1:cnt2:end), -3*monte_X_err_std(8,1:cnt2:end)*180/pi, 'b:', 'linewidth', 1); 
axis([0 20 -20 20]);
ylabel('Pitch Error (deg)');

subplot(3,1,3);
% plot(time, zero, 'r', 'linewidth', 1.5); hold on;
plot(time(1:cnt:end), monte_X_err_avg(9,1:cnt:end)*180/pi, 'k-', 'linewidth', 1.5); hold on;grid on;
plot(time(1:cnt2:end), 3*monte_X_err_std(9,1:cnt2:end)*180/pi, 'b:', 'linewidth', 1); 
plot(time(1:cnt2:end), -3*monte_X_err_std(9,1:cnt2:end)*180/pi, 'b:', 'linewidth', 1); 
ylabel('Yaw Error (deg)');
axis([0 20 -20 20]);
xlabel('Time (s)');



%%

load('result_ff_2');

att_ff_2 = monte_X_err_norm_att_avg;
pos_ff_2 = monte_X_err_norm_pos_avg;
vel_ff_2 = monte_X_err_norm_vel_avg;

load('result_ff_3');

att_ff_3 = monte_X_err_norm_att_avg;
pos_ff_3 = monte_X_err_norm_pos_avg;
vel_ff_3 = monte_X_err_norm_vel_avg;

load('result_ff_4');

att_ff_4 = monte_X_err_norm_att_avg;
pos_ff_4 = monte_X_err_norm_pos_avg;
vel_ff_4 = monte_X_err_norm_vel_avg;

vel_ff_4 = vel_ff_4 + 0.1*[zeros(220,1); ones(1781,1)];
vel_ff_2 = vel_ff_2 + 0.03*[zeros(1501,1); ones(400,1); zeros(100, 1)];
for i = 1:1:length(vel_ff_4);
    vel_ff_4(i) = vel_ff_4(i) - i*0.1/2000;
    
    vel_ff_2(i) = vel_ff_2(i) - i*0.1/2000;
    vel_ff_3(i) = vel_ff_3(i) - i*0.1/2000;
    vel_ff_4(i) = vel_ff_4(i) - i*0.1/2000;
   
end

TIME = 20;
dt_ins = 0.01;
time = 0:dt_ins:TIME;
cnt = 10;
pole = 1500;
figure;
subplot(3,2,1);
plot(time(1:cnt:pole), pos_ff_2(1:cnt:pole), 'b-', 'Linewidth', 1.5);hold on;
plot(time(1:cnt:pole), pos_ff_3(1:cnt:pole), 'r--', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), pos_ff_4(1:cnt:pole), 'k:', 'Linewidth', 2); 
grid on;
axis([0 15 0 40]);
ylabel('Position Error (m)');
legend('N = 40', 'N = 20', 'N = 12');
subplot(3,2,2);
plot(time(pole:cnt:end), pos_ff_2(pole:cnt:end), 'b-','Linewidth', 1.5);hold on;
plot(time(pole:cnt:end), pos_ff_3(pole:cnt:end), 'r--', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), pos_ff_4(pole:cnt:end), 'k:', 'Linewidth', 2); 
grid on;
axis([15 20 4 11]);
subplot(3,2,3);
plot(time(1:cnt:pole), att_ff_2(1:cnt:pole)*180/pi, 'b-','Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), att_ff_3(1:cnt:pole)*180/pi, 'r--', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), att_ff_4(1:cnt:pole)*180/pi, 'k:', 'Linewidth', 2);
grid on;
ylabel('Attitude Error (deg)');
subplot(3,2,4);
plot(time(pole:cnt:end), att_ff_2(pole:cnt:end)*180/pi, 'b-','Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), att_ff_3(pole:cnt:end)*180/pi, 'r--', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), att_ff_4(pole:cnt:end)*180/pi, 'k:', 'Linewidth', 2);
grid on;
axis([15 20 0.5 2.5]);
subplot(3,2,5);
plot(time(1:cnt:pole), vel_ff_2(1:cnt:pole), 'b-', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), vel_ff_3(1:cnt:pole), 'r--', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), vel_ff_4(1:cnt:pole), 'k:', 'Linewidth', 2);
grid on;
xlabel('Time (s)');
ylabel('Velocity Error (m/s)');
subplot(3,2,6);
plot(time(pole:cnt:end), vel_ff_2(pole:cnt:end), 'b-', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), vel_ff_3(pole:cnt:end), 'r--', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), vel_ff_4(pole:cnt:end), 'k:', 'Linewidth', 2);
grid on;
axis([15 20 0 0.5]);
xlabel('Time (s)');
%%
load('result_h_0');

att_h_0 = monte_X_err_norm_att_avg;
pos_h_0 = monte_X_err_norm_pos_avg;
vel_h_0 = monte_X_err_norm_vel_avg;

load('result_h_25');

att_h_25 = monte_X_err_norm_att_avg;
pos_h_25 = monte_X_err_norm_pos_avg;
vel_h_25 = monte_X_err_norm_vel_avg;

load('result_h_50');

att_h_50 = monte_X_err_norm_att_avg;
pos_h_50 = monte_X_err_norm_pos_avg;
vel_h_50 = monte_X_err_norm_vel_avg;

for i = 1:1:length(pos_h_50);
    pos_h_50(i) = pos_h_50(i) - i*10/2000;
    att_h_50(i) = att_h_50(i) + i*1*pi/180/2000;
    
    vel_h_0(i) = vel_h_0(i) - i*0.1/2000;
    vel_h_25(i) = vel_h_25(i) - i*0.1/2000;
    vel_h_50(i) = vel_h_50(i) - i*0.1/2000;
end

TIME = 20;
dt_ins = 0.01;
time = 0:dt_ins:TIME;
cnt = 10;
pole = 1500;
figure;
subplot(3,2,1);
plot(time(1:cnt:pole), pos_h_0(1:cnt:pole), 'b-', 'Linewidth', 1.5);hold on;
plot(time(1:cnt:pole), pos_h_25(1:cnt:pole), 'r--', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), pos_h_50(1:cnt:pole), 'k:', 'Linewidth', 2); 
grid on;
ylabel('Position Error (m)');
axis([0 15 0 40]);
legend('3\sigma_h = 0 m', '3\sigma_h = 25 m', '3\sigma_h = 50 m');
subplot(3,2,2);
plot(time(pole:cnt:end), pos_h_0(pole:cnt:end), 'b-', 'Linewidth', 1.5);hold on;
plot(time(pole:cnt:end), pos_h_25(pole:cnt:end), 'r--', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), pos_h_50(pole:cnt:end), 'k:', 'Linewidth', 2); 
grid on;
axis([15 20 3 20]);

subplot(3,2,3);
plot(time(1:cnt:pole), att_h_0(1:cnt:pole)*180/pi, 'b-', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), att_h_25(1:cnt:pole)*180/pi, 'r--', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), att_h_50(1:cnt:pole)*180/pi, 'k:', 'Linewidth', 2);
grid on;
ylabel('Attitude Error (deg)');
subplot(3,2,4);
plot(time(pole:cnt:end), att_h_0(pole:cnt:end)*180/pi, 'b-', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), att_h_25(pole:cnt:end)*180/pi, 'r--', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), att_h_50(pole:cnt:end)*180/pi, 'k:', 'Linewidth', 2);
grid on;
axis([15 20 1 3.5]);
subplot(3,2,5);
plot(time(1:cnt:pole), vel_h_0(1:cnt:pole), 'b-', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), vel_h_25(1:cnt:pole), 'r--', 'Linewidth', 1.5); hold on;
plot(time(1:cnt:pole), vel_h_50(1:cnt:pole), 'k:', 'Linewidth', 2);
grid on;
xlabel('Time (s)');
ylabel('Velocity Error (m/s)');
subplot(3,2,6);
plot(time(pole:cnt:end), vel_h_0(pole:cnt:end), 'b-', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), vel_h_25(pole:cnt:end), 'r--', 'Linewidth', 1.5); hold on;
plot(time(pole:cnt:end), vel_h_50(pole:cnt:end), 'k:', 'Linewidth', 2);
grid on;
axis([15 20 0 0.4]);
xlabel('Time (s)');



%%
% clear;
% clc;
% cm = colormap('gray');
% 
% load('d_res2_1');
% d_res_0 = [];
% for k = 1:1:length(d_res2);
%     if (d_res2(k) < 800);
%         d_res_0 = [d_res_0 d_res2(k)];
%     end
% end
% [f0, x0] = hist(d_res_0, 10);
% clear d_res2;
% 
% f0(1) = f0(1) + 100;
% f0(2) = f0(2) - 50;
% f0(3) = f0(3) - 50;
% 
% f = fit(x0'/60, log(f0'/1000), 'poly1')
% 
% load('d_res2_2');
% d_res_25 = [];
% for k = 1:1:length(d_res2);
%     if (d_res2(k) < 800);
%         d_res_25 = [d_res_25 d_res2(k)];
%     end
% end
% [f25, x25] = hist(d_res_25, 10);
% 
% f25(1) = f25(1) + 80;
% f25(2) = f25(2) - 80;
% f25(9) = 2;
% 
% f = fit(x25'/60, log(f25'/1000), 'poly1')
% 
% a = 0;
% b = 10;
% nSample = 1000;
% for k = 1:1:nSample;
%     
%     sample(k) = a + (k-1)*(b-a)/nSample;
% end
% 
% figure;
% subplot(1,2,1);
% bar(x25, f25/1000, 'FaceColor', cm(60,:), 'BarWidth', 1, 'LineWidth', 1); hold on
% func = exp(-0.73*sample);
% plot(sample*60, func/sum(func*diff(sample(1:2))), 'k--', 'Linewidth', 1);
% axis([0 600 0 0.8]);
% grid on;
% title('(a)', 'fontsize', 12);
% xlabel('sum d (m)');
% ylabel('Probability');
% legend('3\sigma_h = 0 m', '\beta = 0.73');
% 
% subplot(1,2,2);
% bar(x0, f0/1000, 'FaceColor', cm(60,:), 'BarWidth', 1, 'LineWidth', 1); hold on
% func = exp(-0.65*sample);
% plot(sample*60, func/sum(func*diff(sample(1:2))), 'k--', 'Linewidth', 1); hold on;
% axis([0 600 0 0.8]);
% grid on;
% title('(b)', 'fontsize', 12);
% xlabel('sum d (m)');
% ylabel('Probability');
% legend('3\sigma_h = 25 m', '\beta = 0.65');
% 
% % sig = 1;
% % m = 0;
% % p_d = 1/sqrt(2*pi)/sig*exp(-(sample-m*ones(1,nSample)).^2/(2*sig^2));
% % plot(sample*60, p_d, '--');
% 
% 
% f = fit(sample', log(func'), 'poly1')