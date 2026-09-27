function [ x_pred, F, L ] = process_model( x, acc, pqr, dt_ins)
% Nine-state propagation helper; https://doi.org/10.1177/0954410017690548
% Contracts and paper differences: docs/source-reference.md and docs/method.md.

x_pred = zeros(9, 1);
x_pred(7:9) = x(7:9) + RTM_B2I(x(7), x(8), x(9))*pqr*dt_ins;
x_pred(4:6) = x(4:6) + DCM_I2B(pi, 0, pi/2)*DCM_B2I(x(7), x(8), x(9))*acc*dt_ins;
x_pred(1:3) = x(1:3) + x_pred(4:6)*dt_ins;

F = zeros(9, 9);
F(1:9,1:9) = [eye(3) eye(3)*dt_ins zeros(3,3);
    zeros(3,3) eye(3) zeros(3,3);
    zeros(3,3) zeros(3,3) zeros(3,3)];

L = zeros(9, 6);
L(4:6,1:3) = DCM_I2B(pi, 0, pi/2)*DCM_B2I(x(7), x(8), x(9))*dt_ins;
L(7:9,4:6) = RTM_B2I(x(7), x(8), x(9))*dt_ins;

end

