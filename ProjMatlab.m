%clear all;
%close all;

% ri = Raio interno
ri = .4;

% re = Raio externo
re = .5;

% entre 3 e 6
nVoltas = 6;

antena = spiralArchimedean('NumArms', 1, 'Turns', nVoltas, 'InnerRadius',...
ri, 'OuterRadius', re, 'Tilt', 90, 'TiltAxis', 'Y');

receptora = spiralArchimedean('NumArms', 1, 'Turns', nVoltas, 'InnerRadius',...
ri, 'OuterRadius', re, 'Tilt', 90, 'TiltAxis', 'Y');

freq = linspace(1000000, 10000000, 200);

dipole_array = linearArray('Element', [antena,receptora]);
dipole_array.ElementSpacing = .3;

show(dipole_array);


ctr=1;
dist = 0.05:0.001:0.5;
dipole_array.ElementSpacing = dist;
ganho = sparameters(dipole_array, freq);
ganhos = [ganhos;ganho];


for dist = 0.05:0.001:0.5
    dipole_array.ElementSpacing = dist;
    ganhos = sparameters(dipole_array, freq);
    
end

%surf(ganhos, freq, dist);

%rfplot(ganhos,2,1,'abs');

%ganhos = sparameters(dipole_array, freq);

%xlim([0,8]);


%rfparam(ganhos,2,1);

%impedance(antena, freq');
%ylim([-100, 100]);