clear; clc; rng(1);
f=50; w=2*pi*f; M=5000;
tolR=0.01; tolC=0.05;                       % 1 % resistors, 5 % capacitors
rnd = @(x,tol) x.*(1+tol*(2*rand(M,1)-1));    % uniform +/- tolerance

R3=rnd(330e3,tolR); R4=rnd(1e3,tolR);  R5=rnd(600,tolR);  C1=rnd(100e-9,tolC);
R6=rnd(1.6e3,tolR); C2=rnd(100e-9,tolC);
Rf=rnd(6e3,tolR);   Rg=rnd(1e3,tolR);  Rs=rnd(0.01,tolR);

Vs=230;  I=10*exp(-1j*deg2rad(30));         % rms phasors
Rth=R3.*R4./(R3+R4);
Hv=(R4./(R3+R4))./(1+1j*w*C1.*(R5+Rth)); % voltage channel
Hi=Rs.*(1+Rf./Rg)./(1+1j*w*C2.*R6);      % current channel

v_m=Vs*Hv*331;   i_m=I*Hi/(0.01*7);         % meter's nominal scaling
P_ideal=230*10*cosd(30);

P_raw=real(v_m.*conj(i_m));                               
P_cal=230*10*cos(angle(v_m.*conj(i_m)));               
e_raw=100*(P_raw-P_ideal)/P_ideal;
e_cal=100*(P_cal-P_ideal)/P_ideal;

fprintf('Uncalibrated: mean %.3f %%, std %.3f %%, worst %.3f %%\n', mean(e_raw), std(e_raw), max(abs(e_raw)));
fprintf('Gain-calibrated: mean %.3f %%, std %.3f %%, worst %.3f %%\n', mean(e_cal), std(e_cal), max(abs(e_cal)));

figure;
subplot(2,1,1); histogram(e_raw,50); grid on; xlabel('P error (%)'); title('Uncalibrated, 1% R / 5% C');
subplot(2,1,2); histogram(e_cal,50); grid on; xlabel('P error (%)'); title('After gain calibration');