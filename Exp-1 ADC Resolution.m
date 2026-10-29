f=50; fs=3200; cycles=10;
t=0:1/fs:cycles/f  -1/fs;

Nbits=[4 6 8 10 12 14 16];
runs=100;
P_ideal=230*10*cosd(30);
errP=zeros(size(Nbits));
adc=@(x,N,Vfs) max(min(round(x/(2*Vfs/2^N))*(2*Vfs/2^N), Vfs), -Vfs);
for k=1:numel(Nbits)
    e=zeros(1,runs);
    for r=1:runs
        ph=2*pi*rand;
        v = 230*sqrt(2)*sin(2*pi*f*t + ph);
        i = 10*sqrt(2)*sin(2*pi*f*t + ph - deg2rad(30));
        vq = adc(v, Nbits(k), 400);
        iq = adc(i, Nbits(k), 20);
        P  = mean(vq.*iq);
        e(r) = 100*abs(P - P_ideal)/P_ideal;
    end
    errP(k)=mean(e);
end
disp(table(Nbits', errP', 'VariableNames', {'Bits','AvgPerror_percent'}));

figure;
semilogy(Nbits, errP, '-o', 'LineWidth', 1.5);
grid on; xlabel('ADC resolution (bits)'); ylabel('Active power error (%)');
title('Effect of ADC resolution on power measurement');