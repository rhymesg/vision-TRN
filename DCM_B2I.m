function [ DCM ] = DCM_B2I( phi, the, psi )
%DCM_B2I Summary of this function goes here
%   Detailed explanation goes here

DCM = DCM_I2B(phi, the, psi);

DCM = DCM';

end

