clc
clear
close all

%% SFCTMN
s_T1_noCE_sfctmn = [36.69	36.69	36.69];       % Full overlapping (no CE)
s_T1_sfctmn = [36.69	36.69	36.69];       % Full overlapping
s_T2_sfctmn = [108.33	1.04	108.33];     % Neighbor overlapping
s_T3_sfctmn = [109.36	55.38	109.36];     % Potential overlapping (SINR accomplished)
s_T3_noCE_sfctmn = [109.36	0.00	109.36];     % Potential overlapping: SINR not accomplished in B - CE = 50 dB
s_T4_sfctmn = [109.36	109.36	109.36];     % No overlapping

%% KOMONDOR

s_T1_noCE_kom = [36.43	36.75	36.54];             % Full overlapping (no CE)
s_T1_kom = [41.46	41.31	41.53];             % Full overlapping
s_T2_kom = [107.99	1.57	107.98];           % Neighbor overlapping
s_T3_kom = [109.37	82.94	109.36];          % Potential overlapping (SINR accomplished)
s_T3_noCE_kom = [109.36	0.00	109.36];  % Potential overlapping: SINR not accomplished in B - CE = 50 dB (99.998 % packet lost)
s_T4_kom = [109.37	109.36	109.36];                % No overlapping

% Missing WLANs A and C points regarding Komondor
figure
bar([s_T1_noCE_sfctmn; s_T1_sfctmn; s_T2_sfctmn; s_T3_noCE_sfctmn; s_T3_sfctmn; s_T4_sfctmn])
hold on
delta_x_axis = 0.225;

plot(1-delta_x_axis,s_T1_noCE_kom(1), 'r*');
plot(1,s_T1_noCE_kom(2), 'r*');
plot(1+delta_x_axis,s_T1_noCE_kom(3), 'r*');

plot(2-delta_x_axis,s_T1_kom(1), 'r*');
plot(2,s_T1_kom(2), 'r*');
plot(2+delta_x_axis,s_T1_kom(3), 'r*');

plot(3-delta_x_axis,s_T2_kom(1), 'r*');
plot(3,s_T2_kom(2), 'r*');
plot(3+delta_x_axis,s_T2_kom(3), 'r*');

plot(4-delta_x_axis,s_T3_noCE_sfctmn(1), 'r*');
plot(4,s_T3_noCE_sfctmn(2), 'r*');
plot(4+delta_x_axis,s_T3_noCE_sfctmn(3), 'r*');

plot(5-delta_x_axis,s_T3_kom(1), 'r*');
plot(5,s_T3_kom(2), 'r*');
plot(5+delta_x_axis,s_T3_kom(3), 'r*');

plot(6-delta_x_axis,s_T4_sfctmn(1), 'r*');
plot(6,s_T4_sfctmn(2), 'r*');
plot(6+delta_x_axis,s_T4_sfctmn(3), 'r*');
grid on
grid minor

xticks(1:6)
xticklabels({'T1-noCE','T1','T2','T3-noCE','T3','T4'})
xlabel('Overlapping setting')
ylabel('Trhoguhput [Mbps]')
% legend('WLAN A','WLAN B','WLAN C', 'Komondor')

[legend_h,object_h,plot_h,text_strings] = legend('SF A','SF B','SF C', 'Sim A', 'Sim B', 'Sim C');
