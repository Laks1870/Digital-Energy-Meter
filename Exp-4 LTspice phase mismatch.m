clear; clc;
d=readmatrix('Vvout and Viout.txt');   % columns: time, V(iout), V(vout)
[tr,k]=unique(d(:,1));
is_raw=d(k,2);  vs_raw=d(k,3);

f = 50; fs = 3200; N = 12;
t0   = 0.06;
ncyc = floor((max(tr) - t0)*f + 1e-9);
t    = (t0 : 1/fs : t0 + ncyc/f - 1/fs)';
vs = interp1(tr, vs_raw, t);
is = interp1(tr, is_raw, t);
assert(~any(isnan([vs; is])), 'NaN: time window is outside the file data');

adc = @(x,N,Vfs) max(min(round(x/(2*Vfs/2^N))*(2*Vfs/2^N), Vfs), -Vfs);
v=adc(vs,N,1)*331;
i=adc(is,N,1)/(0.01*7);

Vrms=sqrt(mean(v.^2));  Irms=sqrt(mean(i.^2));
P=mean(v.*i);  S=Vrms*Irms;  Q=sqrt(S^2-P^2);  PF = P/S;
ph=rad2deg(angle(sum(v.*exp(-1j*2*pi*f*t))) - angle(sum(i.*exp(-1j*2*pi*f*t))));
fprintf('Vrms=%.2f V  Irms=%.3f A  P=%.1f W  Q=%.1f var  PF=%.4f\n', Vrms,Irms,P,Q,PF);
fprintf('P error = %.2f %%   phase seen = %.2f deg\n', 100*(P-1991.9)/1991.9, ph);