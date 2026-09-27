function [ dT ] = getTranslation_8point( x1, x2, n, camera_model )
% Eight-point translation experiment; https://doi.org/10.1177/0954410017690548
% Paper differences and citation: docs/method.md and README.md#citation.

f = camera_model(1);
C = [f 0 0; 0 f 0; 0 0 1]; % calibration matrix

X = [];
for k = 1:1:n;
    a = [x1(1,k)*x2(1,k); x1(1,k)*x2(2,k); x1(1,k); x1(2,k)*x2(1,k); x1(2,k)*x2(2,k); x1(2,k); x2(1,k); x2(2,k); 1];
    X = [X a];
end
[U, S, V] = svd(X',0);

E = [V(1,9) V(4,9) V(7,9); V(2,9) V(5,9) V(8,9); V(3,9) V(6,9) V(9,9)];

%E = inv(C)*E*C;

[U1, S1, V1] = svd(E);

Rz_p = [0 1 0; -1 0 0; 0 0 1]';
Rz_m = [0 -1 0; 1 0 0; 0 0 1]';
Sn = diag([1 1 0]);

R1 = U1*Rz_p'*V1';
R2 = U1*Rz_m'*V1';
% T1hat = U1*Rz_p*Sn*U1';
% T2hat = U1*Rz_m*Sn*U1';
T1hat = V1*Rz_p*S1*V1';
T2hat = V1*Rz_m*S1*V1';
T1 = [T1hat(3,2); T1hat(1,3); T1hat(2,1)];
T2 = [T2hat(3,2); T2hat(1,3); T2hat(2,1)];

R = R1;

if (T1(1) > T2(1))
    T = T1;
else
    T = T2;
end

% M = zeros(3*n, n+1);
% for k = 1:1:n;
%     x2hat = [0 -x2(3,k) x2(2,k); x2(3,k) 0 -x2(1,k); -x2(2,k) x2(1,k) 0];
%     m = x2hat*R1*x1(:,k);
%     t = x2hat*T;
%     M(3*k-2:3*k,k) = m;
%     M(3*k-2:3*k,n+1) = t;
% end
% % [U2, S2, V2] = svd(M, 0);
% % V2(:,n+1)
% [Vec, D] = eig(M'*M);
% Vec(:,1);

dT = T;

end

