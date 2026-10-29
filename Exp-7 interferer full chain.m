clear; clc; rng(2);
f=50; N=12; Vfs=1.5; ncyc=10; M=200;

% [freq Vrms Vphase Irms Iphase]
Hm = [ 50 230 0 10 -30;
    150 11.5 0  2 -45;
    250  6.9 0  1 -60];
P_true = sum(Hm(:,2).*Hm(:,4).*cosd(Hm(:,3)-Hm(:,5)));
fint=3150; Vint=5; Iint=0.5;

RC=1.6e3*100e-9;                                    % matched filters
Hf=@(fr,on) on./(1+1j*2*pi*fr*RC) + (1-on);       % on=1 filter, on=0 none
adc=@(x) max(min(round(x/(2*Vfs/2^N))*(2*Vfs/2^N), Vfs), -Vfs);
comp=@(t,fr,a,ph,H) sqrt(2)*a*abs(H).*sin(2*pi*fr*t + deg2rad(ph) + angle(H));

fsList = [3200 6400 12800];
fprintf('P_true = %.1f W\n\n', P_true);
fprintf('%8s %10s %10s %12s %12s\n','fs (Hz)','alias (Hz)','filter','mean err %','worst err %');

for a=1:numel(fsList)
    fs=fsList(a);
    t=(0:round(ncyc*fs/f)-1)'/fs;
    fa=abs(fint-fs*round(fint/fs));
    for on=0:1
        g=abs(Hf(f,on));                                 % gain calibrated at 50 Hz
        e=zeros(M,1);
        for m=1:M
            pint=360*rand;
            v=0; i=0;
            for h = 1:3
                v=v+comp(t,Hm(h,1),Hm(h,2),Hm(h,3),Hf(Hm(h,1),on));
                i=i+comp(t,Hm(h,1),Hm(h,4),Hm(h,5),Hf(Hm(h,1),on));
            end
            v=v+comp(t,fint,Vint,pint,Hf(fint,on));
            i=i+comp(t,fint,Iint,pint,Hf(fint,on));
            vm=adc(v/331)*331/g;                           % divider->ADC->back to volts
            im=adc(i*0.07)/0.07/g;                         % shunt->ADC->back to amps
            e(m)=100*(mean(vm.*im)-P_true)/P_true;
        end
        fprintf('%8d %10.0f %10s %12.3f %12.3f\n', fs, fa, ...
            ternary(on,'with','without'), mean(e), max(abs(e)));
    end
end

function s=ternary(c,a,b)
if c,s=a; else, s=b;end
end