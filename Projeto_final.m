close all;
clear all;

% 1 Modelando Antena
ri = .4;
re = .5;

nVoltas = 6;
antena = spiralArchimedean('NumArms', 1, 'Turns', nVoltas, 'InnerRadius', ri, 'OuterRadius', re, 'Tilt', 90, 'TiltAxis', 'Y');
freq = linspace(1000000, 10000000, 200);

figure(1);
show(antena);

% ----------------------------------

% 2 Calculando impedância da antena
figure(2);
impedance(antena, freq');
ylim([-100, 100]);
%xlim([15, 40]);
grid

%-----------------------------------

% 3 Antena Receptora
antena_receptora = spiralArchimedean('NumArms', 1, 'Turns', nVoltas, 'InnerRadius', ri, 'OuterRadius', re, 'Tilt', 90, 'TiltAxis', 'Y');

% entre 3 e 6
nVoltas = 6;

receptora = spiralArchimedean('NumArms', 1, 'Turns', nVoltas, 'InnerRadius',...
ri, 'OuterRadius', re, 'Tilt', 90, 'TiltAxis', 'Y');

dipole_array = linearArray('Element', [antena, receptora]);
dipole_array.ElementSpacing = .5;

figure(3);
show(dipole_array);
grid

% -----------------------------------

% 4 Simulando acoplamento
sparam = sparameters(dipole_array, freq);

% -----------------------------------

% 5 Visualizando os ganhos
%figure(4);
%rfplot(sparam, 2, 1, 'abs');
%xlim(6,6.5);
%grid

% -----------------------------------

% 6 Visualização 3D
freq2 = (25:0.1:36)*1e6;
dist = re*2*(0.5:0.1:1.5);
load('wptData.mat');
s21_dist = zeros(length(dist), length(freq2));

for i=1:length(dist)
    s21_dist(i,:) = rfparam(sparam_dist(i), 2, 1);
end

figure(5);
[X, Y] = meshgrid(freq2/1e6, dist);
surf(X,Y,abs(s21_dist), 'EdgeColor', 'none');
view(150, 20);
shading(gca, 'interp');

axis tight;
xlabel('Frequency [MHz]');
ylabel('Distance [m]');
zlabel('S_{21} Magnitude');
grid


% -----------------------------------

% 7 Corrente ressonante

% Para visualizar com menor número de voltas:
nVoltas_teste = 3;
antena_teste = spiralArchimedean('NumArms', 1, 'Turns', nVoltas_teste, 'InnerRadius', ri, 'OuterRadius', re, 'Tilt', 90, 'TiltAxis', 'Y');

freq_res = 6.2e6;

figure(6);
current(antena, freq_res);
grid

figure(7);
current(antena_teste, freq_res);
grid

% -----------------------------------

% 8 Unindo dois modelos
sigma = 20;
wC = 5.2*1e6;
L = sigma/wC;
C = 1/(sigma*wC);
Z = zeros(length(freq), 1);

for m = 1:length(freq)
    Z(m)= 1i*freq(m)*L*1/(1i*freq(m)*C)/((1i*freq(m)*L)+(1/(1i*freq(m)*C))) + 2*1i*freq(m)*L;
end

figure(9);
plot(freq, imag(Z));
imag(Z);
grid();
ylim([-100,100]);

xlabel('Frequência [Hz]');
ylabel('Impedância [ohms]');

M = 1/wC;
Rc = 1;

M_s = linspace(M, 0.1*1e-7, 200);
s_G = zeros(length(M_s), 1);

for m = 1:length(M_s)
    G = (abs(1j*wC*M_s(m))/Rc).^2;
    s_G(m,1) = G;
end

hold on
figure(10);
plot(M_s, s_G);
xlabel('M');
ylabel('Ganho');
grid


