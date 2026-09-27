function [ monte_X_err_std ] = stderr( err_monte_X )
%STDERR 이 함수의 요약 설명 위치
%   자세한 설명 위치

s = size(err_monte_X);

monteNum = s(1);

for i = 1:1:s(2);  
    err_sqr_sum = 0;
    for k = 1:1:monteNum;
        err_sqr_sum = err_sqr_sum + err_monte_X(k,i).^2;
    end
    monte_X_err_std(i) = sqrt(err_sqr_sum/monteNum);
end

end

