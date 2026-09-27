function [ Z ] = getFeatureHeight_dted( X, Y, terrain, resolution )
% DEM interpolation for TRN; https://doi.org/10.1177/0954410017690548
% Grid contract and citation: docs/source-reference.md and README.md#citation.
idx_X = -1;
for i = 1:1:size(terrain,1)-1;
    if (i*resolution <= X && (i+1)*resolution > X)
        idx_X = i;
        break;
    end
end

idx_Y = -1;
for i = 1:1:size(terrain,2)-1;
    if (i*resolution <= Y && (i+1)*resolution > Y)
        idx_Y = i;
        break;
    end
end

if (idx_X == -1 || idx_Y == -1)
    %disp('Error: terrain에 해당 정보가 없음'); 
    Z = 0;
    return;
end

% bilinear interpolation
Q11 = terrain(idx_X, idx_Y);
Q12 = terrain(idx_X, idx_Y+1);
Q21 = terrain(idx_X+1, idx_Y);
Q22 = terrain(idx_X+1, idx_Y+1);
X1 = idx_X*resolution;
X2 = (idx_X+1)*resolution;
Y1 = idx_Y*resolution;
Y2 = (idx_Y+1)*resolution;

h11 = Q11*(X2 - X)*(Y2 - Y) / ((X2 - X1)*(Y2 - Y1));
h12 = Q12*(X2 - X)*(Y - Y1) / ((X2 - X1)*(Y2 - Y1));
h21 = Q21*(X - X1)*(Y2 - Y) / ((X2 - X1)*(Y2 - Y1));
h22 = Q22*(X - X1)*(Y - Y1) / ((X2 - X1)*(Y2 - Y1));

Z = h11 + h12 + h21 + h22;

end

