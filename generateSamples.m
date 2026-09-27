function [ samples_X ] = generateSamples( X, X_std, num_samples )
%GENERATESAMPLES Summary of this function goes here
%   Detailed explanation goes here

for i = 1:1:length(X_std);
    sample1 = randn([1,num_samples]);
    sample1 = X_std(i)*sample1;
    samples_X(i,:) = sample1;
end

for j = 1:1:num_samples;
   samples_X(:,j) = X + samples_X(:,j); 
end

end

