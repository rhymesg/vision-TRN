function [ R ] = DCM( euler )
%DCM_I2B Summary of this function goes here
%   rotation from 1 to 2 when euler is anlge of 2 relative to 1.

phi = euler(1);
the = euler(2);
psi = euler(3);

R =     [ cos(the)*cos(psi)                                cos(the)*sin(psi)                               -sin(the) ;
        sin(phi)*sin(the)*cos(psi)-cos(phi)*sin(psi)     sin(phi)*sin(the)*sin(psi)+cos(phi)*cos(psi)     sin(phi)*cos(the) ;
        cos(phi)*sin(the)*cos(psi)+sin(phi)*sin(psi)     cos(phi)*sin(the)*sin(psi)-sin(phi)*cos(psi)     cos(phi)*cos(the) ] ;

end

