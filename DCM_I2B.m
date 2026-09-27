function [ DCM ] = DCM_I2B( phi, the, psi )
%DCM_I2B Summary of this function goes here
%   Detailed explanation goes here

DCM = [cos(the)*cos(psi), cos(the)*sin(psi), -sin(the);
    sin(phi)*sin(the)*cos(psi)-cos(phi)*sin(psi), sin(phi)*sin(the)*sin(psi)+cos(phi)*cos(psi), sin(phi)*cos(the);
    cos(phi)*sin(the)*cos(psi)+sin(phi)*sin(psi), cos(phi)*sin(the)*sin(psi)-sin(phi)*cos(psi), cos(phi)*cos(the)];

end

