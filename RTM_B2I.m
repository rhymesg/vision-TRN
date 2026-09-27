function [ RTM ] = RTM_B2I( phi, the, psi )
%RTM_B2I Summary of this function goes here
%   Detailed explanation goes here

RTM = [1 sin(phi)*tan(the) cos(phi)*tan(the);
    0 cos(phi) -sin(phi);
    0 sin(phi)*sec(the) cos(phi)*sec(the)];

end

