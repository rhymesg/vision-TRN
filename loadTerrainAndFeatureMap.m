function  [terrain, features] = loadTerrainAndFeatureMap ( resolution, ff )

dted_size = 120;
ptr_f = fopen('terrain.txt', 'r');
terrain = fscanf(ptr_f, '%f', [dted_size, dted_size]); 
fclose(ptr_f);

terrain = [terrain terrain; terrain terrain];
dted_size = 240;

k = 0;
for i = ff:ff:dted_size;
    for j = ff:ff:dted_size;
        k = k + 1;
        features(1,k) = resolution*i;
        features(2,k) = resolution*j;
        features(3,k) = terrain(i, j);
    end 
end


end