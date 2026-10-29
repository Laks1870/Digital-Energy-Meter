f=50; N=12;
P_ideal=230*10*cosd(30);
adc=@(x,N,Vfs) max(min(round(x/(2*Vfs/2^N))*(2*Vfs/2^N), Vfs), -Vfs);

fs=3200;
cyc=[0.5 1 1.25 1.5 2 2.5 5 10 10.3 20];
errA=zeros(size(cyc));
for k=1:numel(cyc)
    t=0:1/fs:cyc(k)/f-1/fs;
    v=230*sqrt(2)*sin(2*pi*f*t);
    i=10*sqrt(2)*sin(2*pi*f*t -deg2rad(30));
    P=mean(adc(v,N,400).*adc(i,N,20));
    errA(k)=100*(P-P_ideal)/P_ideal;
end
disp(table(cyc', errA', 'VariableNames', {'Cycles','Perror_percent'}));


fsv = [100 150 200 400 800 1600 3200 6400];
errB = zeros(size(fsv));
for k = 1:numel(fsv)
    t = 0:1/fsv(k):10/f - 1/fsv(k);
    v = 230*sqrt(2)*sin(2*pi*f*t);
    i = 10*sqrt(2)*sin(2*pi*f*t - deg2rad(30));
    P = mean(adc(v,N,400).*adc(i,N,20));
    errB(k) = 100*(P - P_ideal)/P_ideal;
end
disp(table(fsv', errB', 'VariableNames', {'fs_Hz','Perror_percent'}));

figure;
subplot(2,1,1); stem(cyc, errA, 'filled'); grid on;
xlabel('Cycles in window'); ylabel('P error (%)'); title('Non-integer cycles');
subplot(2,1,2); semilogx(fsv, errB, '-o'); grid on;
xlabel('Sampling frequency (Hz)'); ylabel('P error (%)'); title('Sampling frequency');