clear; clc;
f = 50; N = 12; cycles = 10;
adc = @(x,N,Vfs) max(min(round(x/(2*Vfs/2^N))*(2*Vfs/2^N), Vfs), -Vfs);

% Reference: very high sampling rate gives the "true" power
fs_ref = 51200;
tr = 0:1/fs_ref:cycles/f - 1/fs_ref;
sig = @(t) deal( ...
    230*sqrt(2)*sin(2*pi*f*t) + 0.05*230*sqrt(2)*sin(2*pi*3*f*t), ...
    10*sqrt(2)*sin(2*pi*f*t - deg2rad(30)) + 0.3*10*sqrt(2)*sin(2*pi*5*f*t - deg2rad(20)) );
[vr, ir] = sig(tr);
P_true = mean(vr.*ir);

fsv = [200 300 400 500 800 1600 3200 6400];
err = zeros(size(fsv));
for k = 1:numel(fsv)
    t = 0:1/fsv(k):cycles/f - 1/fsv(k);
    [v, i] = sig(t);
    P = mean(adc(v,N,400).*adc(i,N,20));
    err(k) = 100*(P - P_true)/P_true;
end
disp(table(fsv', err', 'VariableNames', {'fs_Hz','Perror_percent'}));
semilogx(fsv, err, '-o'); grid on;
xlabel('Sampling frequency (Hz)'); ylabel('P error (%)');
title('Power error with harmonics vs sampling rate');