% Reference (what a calibrator would apply): 230 V rms, 10 A rms
kv=230/Vrms;   ki=10/Irms;          % gain correction factors
v_cal=v*kv;    i_cal=i*ki;

Vrms_c=sqrt(mean(v_cal.^2));  Irms_c=sqrt(mean(i_cal.^2));
P_c=mean(v_cal.*i_cal);  S_c=Vrms_c*Irms_c;  PF_c=P_c/S_c;
fprintf('Calibrated: Vrms=%.3f Irms=%.4f P=%.1f W PF=%.4f  P error=%.3f %%\n', ...
    Vrms_c, Irms_c, P_c, PF_c, 100*(P_c-1991.9)/1991.9);

T_window=ncyc/f;                       % seconds measured
E_Ws=P_c*T_window;                   % watt-seconds in this window
fprintf('Energy in window = %.4f Ws\n', E_Ws);
fprintf('Extrapolated to 1 hour = %.4f kWh\n', P_c*3600/3.6e6);