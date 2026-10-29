f=50; fs=3200; cycles=10;
t=0:1/fs:cycles/f - 1/fs
% Ideal signals: 230 Vrms, 10 Arms, 30 deg lag
v=230*sqrt(2)*sin(2*pi*f*t);
i=10*sqrt(2)*sin(2*pi*f*t - deg2rad(30));
% ADC model: quantize to N bits over +/-Vfs
adc=@(x,N,Vfs) max(min(round(x/(2*Vfs/2^N)) * (2*Vfs/2^N),Vfs),-Vfs);
N=12;
vq=adc(v,N,400);
iq=adc(i,N,20);

% Meter calculation
meter = @(v,i) deal(sqrt(mean(v.^2)), sqrt(mean(i.^2)),mean(v.*i));
[Vrms,Irms,P]=meter(vq,iq);
S=Vrms*Irms; Q=sqrt(S^2 -P^2); PF=P/S;

% Ideal values and error
P_ideal=230*10*cosd(30);
fprintf('Vrms = %.2f V\nIrms = %.3f A\nP = %.1f W (ideal %.1f)\nPF = %.4f\n', Vrms, Irms, P, P_ideal, PF);
fprintf('P error = %.4f %%\n', 100*(P - P_ideal)/P_ideal);

