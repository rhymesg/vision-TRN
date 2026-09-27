
clc;
close all;
clear;

for h = 10:20:50;
H = 500;
% h = 20;
h_std = 10;

k = 0;
for the = 0.1:0.1:22.5;
    k = k + 1;
    dthe_x(k) = the*pi/180;
    dthe_y(k) = the*pi/180 - atan((1-h/H)*tan(the*pi/180));
    dthe_y2(k) = dthe_y(k)*180/pi/the;
end

% figure(1);
% axis([0. 22.5 0 3]);
% [ax,p1,p2] = plotyy(dthe_x*180/pi, dthe_y*180/pi, dthe_x*180/pi, dthe_y2);hold on;
% p1.axis([0 22.5 0 3]);
% p2.axis([0 22.5 0 0.02]);
figure(1);
plot(dthe_x*180/pi, dthe_y*180/pi); hold on;
figure(2);
plot(dthe_x*180/pi, dthe_y2);hold on;

end

k = 0;
for h = 0.1:0.1:50;
    k = k + 1;
    theta = 10;
    dthe_yy(k) = theta*pi/180 - atan((1-h/H)*tan(theta*pi/180));
end

figure;
plot(dthe_yy*180/pi);

nSample = 1000;
sample = h_std*randn([1,nSample]);
h_arr = abs(sample);
theta = 10*pi/180;
for k = 1:1:nSample;
    
    dtheta(k) = (theta - atan((1-h_arr(k)/H)*tan(theta)))*180/pi;
    dtheta(k) = dtheta(k)/h_arr(k);
end

figure;
hist(dtheta);
figure;
hist(h_arr);