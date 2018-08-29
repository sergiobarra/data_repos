clc
clear
close all

load = [1 20 40 60 80 100 120 140 160 180 200]; % load in num of fully aggregated packets
L_fpkt = 768000;    % lenght of a packet containing 64 frames of 12,000 bits 
load_mbps = load * L_fpkt * 1E-6;    % load in Mbps 
line_width = 1;

%% 20x20m2

% THROUGHPUT
s_op_20x20 = [
    0.99
    20.01865
    39.8094
    57.912
    71.4217
    81.8085
    91.91985
    99.8375
    100.91655
    100.8962
    100.886];

s_am_20x20 = [
    0.99
    19.95135
    39.2637
    58.176
    75.4974
    89.4671
    98.4888
    103.5468
    106.26535
    108.0441
    109.14395];

s_max_op_20x20 = [1.007812
    20.2033397
    40.15774211
    60.19828906
    79.97638672
    99.63317578
    119.2458672
    137.4035547
    140.1504531
    140.0861836
    140.0656992];

s_max_am_20x20 = [1.007812
    20.18186713
    40.10676563
    60.16381641
    79.99181251
    99.47410156
    117.2634531
    131.1806172
    141.2113984
    148.2920859
    153.9976055];

s_min_op_20x20 = [0.97
    19.6703
    38.7937
    52.4682
    55.9814
    55.3101
    55.4139
    55.13045
    54.48085
    54.6725
    54.8356];

s_min_am_20x20 = [0.97
    19.48265
    36.7279
    52.7814
    65.2482
    71.03045
    70.2578
    68.75065
    67.01285
    67.06735
    66.40935];

% DELAY
d_op_20x20 = [
    0.6589
    3.5979
    3.2837
    8.97535
    16.89525
    22.42535
    27.46315
    46.38565
    69.53345
    78.6072
    54.04275
    ];

d_am_20x20 = [
    0.58585
    5.4037
    6.39185
    7.15825
    8.8854
    11.6573
    14.7311
    17.16155
    18.9143
    20.12275
    21.1671
    ];

d_max_op_20x20 = [0.67745
    6.8227
    15.6035
    22.6026
    44.00155
    66.3243
    85.24205
    173.5194
    298.47855
    354.8858
    208.05785
    ];

d_max_am_20x20 = [0.6035
    14.4632
    15.6651
    15.6163
    18.0345
    22.7735
    27.87545
    31.23575
    33.9604
    35.2895
    36.9033
    ];

d_min_op_20x20 = [0.64121247
    0.868838645
    1.133184075
    1.57778492
    2.204807615
    3.0039056
    4.57733571
    9.76334088
    13.33423219
    13.85836026
    13.9394568
    ];

d_min_am_20x20 = [0.56890078
    1.853942935
    2.38623478
    2.958683695
    3.789426855
    4.991732625
    6.54994731
    8.08844938
    9.249333665
    10.12087014
    10.68769045
    ];

% WAIT TIME
tw_op_20x20 = [
    0.11387488
    0.466913845
    1.33463754
    3.06784733
    4.920877045
    6.07566839
    7.87300175
    14.48777237
    23.18889613
    26.58092837
    17.14999752
    ];

tw_am_20x20 = [
    0.13347514
    1.791440795
    2.602629555
    3.38859233
    4.32535714
    5.32688207
    6.084871595
    6.529816495
    6.803209125
    6.989876175
    7.175670015
    ];


%% 40x40 m2

% THROUGHPUT
s_op_40x40 = [
    0.99
    20.03645
    39.9477
    59.54625
    76.39485
    90.82265
    104.9191
    115.96175
    117.32165
    117.3189
    117.3284
    ];

s_am_40x40 = [
    0.99
    20.0662
    39.93685
    59.2901
    77.2784
    94.19845
    110.05485
    124.68685
    137.9029
    149.4999
    159.6107
    ];

s_max_op_40x40 = [1.007812
    20.20364042
    40.16418741
    60.25834756
    80.18757415
    100.0251914
    119.8714649
    138.6202852
    141.3898203
    141.3810586
    141.3946484
    ];

s_max_am_40x40 = [1.007812
    20.20219519
    40.15535933
    60.25524215
    80.24185539
    100.2416328
    120.387414
    140.2725704
    160.142043
    179.9789141
    199.9998437
    ];

s_min_op_40x40 = [0.97
    19.7704
    39.3529
    57.10915
    66.3812
    70.3556
    74.3936
    75.6343
    75.32855
    75.17325
    75.16825
    ];

s_min_am_40x40 = [0.97
    19.9673
    39.43035
    55.80495
    66.19105
    71.9333
    73.9958
    72.63195
    68.8887
    64.4089
    60.53135
    ];

% DELAY
d_op_40x40 = [
    0.65675
    1.04715
    1.7456
    4.0088
    9.23085
    12.1859
    17.13745
    47.5285
    51.2099
    50.35245
    55.2774
    
    ];

d_am_40x40 = [0.57075
    1.67745
    2.8748
    4.33475
    6.0368
    7.71515
    9.44335
    11.50445
    13.83045
    16.32085
    18.60705
    
    ];

d_max_op_40x40 = [0.67385
    1.40155
    3.18155
    10.59775
    26.90705
    37.3607
    56.9309
    214.1332
    224.8599
    207.44095
    228.48915
    
    ];

d_max_am_40x40 = [0.58825
    3.34925
    7.94985
    14.0651
    21.27655
    28.1884
    35.2599
    43.8657
    53.50675
    63.684
    72.7201
    
    ];

d_min_op_40x40 = [0.64144184
    0.853680475
    1.081796025
    1.38580107
    1.94056861
    2.683460635
    4.200086455
    9.322465955
    12.87558831
    13.46601853
    13.52893818
    
    ];

d_min_am_40x40 = [0.553208435
    0.91516213
    1.06807274
    1.200920785
    1.326483785
    1.44634798
    1.5638438
    1.689927285
    1.833834365
    1.9949405
    2.172279545
    
    ];

% WAIT TIME
tw_op_40x40 = [
    0.11200937
    0.265400975
    0.53567728
    1.22679529
    2.570309735
    3.193231035
    4.4726676
    16.17232743
    15.44691021
    15.91808972
    16.89662073
    
    ];

tw_am_40x40 = [
    0.119398285
    0.965774055
    1.826187485
    2.51886162
    3.113702865
    3.671156685
    4.25901024
    4.951715955
    5.73570624
    6.58638879
    7.37949279
    ];

%% 80x80 m2

% THROUGHPUT
s_op_80x80 = [
    0.99
    20.07
    40.02
    60.05315
    79.05155
    96.9362
    114.5483
    128.41705
    130.1359
    130.1293
    130.14035
    ];

s_am_80x80 = [
    0.99
    20.0699
    40.01925
    60.0681
    79.89335
    99.53325
    118.7465
    137.47285
    155.718
    173.19545
    189.67445
    ];

s_max_op_80x80 = [1.007812
    20.20389429
    40.16579665
    60.2646132
    80.25035539
    100.2112774
    120.336586
    139.2913672
    141.9279492
    141.9299531
    141.9310351
    ];

s_max_am_80x80 = [1.007812
    20.20394504
    40.16589049
    60.26503122
    80.25562101
    100.2663789
    120.5143631
    140.381629
    160.2881172
    180.1873946
    200.4157655
    ];

s_min_op_80x80 = [0.97
    19.97
    39.77995
    59.73035
    76.7166
    90.3467
    103.5323
    110.19045
    110.44555
    110.39645
    110.48785
    ];

s_min_am_80x80 = [0.97
    19.97
    39.7777
    59.74785
    79.10395
    96.982
    113.09105
    127.03185
    138.61565
    147.237
    152.108
    ];

% DELAY
d_op_80x80 = [
    0.65485
    0.92015
    1.2614
    1.97805
    4.07415
    5.39335
    7.75015
    13.95545
    16.47155
    16.8752
    17.2586
    
    ];

d_am_80x80 = [
    0.56385
    0.92435
    1.2082
    1.47785
    1.7968
    2.14535
    2.4925
    2.87125
    3.29485
    3.76155
    4.2911
    
    ];

d_max_op_80x80 = [0.66985
    1.03825
    1.5942
    3.11785
    8.5072
    11.0877
    15.32565
    24.62845
    25.24705
    25.51365
    26.36215
    
    ];

d_max_am_80x80 = [0.57755
    1.2466
    2.05965
    3.0116
    4.24375
    5.5728
    6.83805
    8.20275
    9.6863
    11.24115
    13.04285
    
    ];

d_min_op_80x80 = [0.640216245
    0.851579225
    1.07681676
    1.353453495
    1.771323015
    2.489559935
    3.980371015
    9.22475486
    13.22049392
    13.68526429
    13.9725045
    
    ];

d_min_am_80x80 = [0.54923262
    0.689039035
    0.764500475
    0.814008245
    0.85602912
    0.895693465
    0.935431525
    0.97564762
    1.0199016
    1.06689287
    1.11744218
    
    ];

% WAIT TIME
tw_op_80x80 = [
    0.11035993
    0.156051695
    0.220775585
    0.386619105
    0.80672833
    0.87935103
    0.985375955
    1.26057873
    1.24739281
    1.23544004
    1.281556915
    ];

tw_am_80x80 = [
    0.11243995
    0.366922455
    0.58404627
    0.76175772
    0.921071735
    1.055192185
    1.171239015
    1.289568785
    1.41610389
    1.544869455
    1.688266665
    ];

%% PLOTS

figure

%  ------ 20x20 m2 -------
subplot(3,3,1)
hold on
plot(load_mbps, s_op_20x20 * L_fpkt * 1E-6,'r','LineWidth',line_width);
plot(load_mbps, s_am_20x20 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_max_op_20x20 * L_fpkt * 1E-6,'r--','LineWidth',line_width);
plot(load_mbps, s_max_am_20x20 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_min_op_20x20 * L_fpkt * 1E-6,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_20x20 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
grid on
xlabel('$\ell$ [Mbps]','interpreter','latex');
ylabel('Throughput [Mbps]')
legend('OP_{avg}', 'AM_{avg}', 'OP_{max}', 'AM_{max}', 'OP_{min}', 'AM_{min}')
xlim([0 160])
ylim([0 160])

subplot(3,3,4)
hold on
plot(load_mbps, d_op_20x20,'r','LineWidth',line_width);
plot(load_mbps, d_am_20x20,'b','LineWidth',line_width);
plot(load_mbps, d_max_op_20x20,'r--','LineWidth',line_width);
plot(load_mbps, d_max_am_20x20,'b--','LineWidth',line_width);
plot(load_mbps, d_min_op_20x20,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, d_min_am_20x20,'b:','LineWidth',1.5 * line_width);
grid on
xlabel('$\ell$ [Mbps]','interpreter','latex');
ylabel('Delay [ms]')
xlim([0 160])
ylim([0 30])


subplot(3,3,7)
hold on
plot(load_mbps, tw_op_20x20,'r','LineWidth',line_width);
plot(load_mbps, tw_am_20x20,'b','LineWidth',line_width);
xlabel('$\ell$ [Mbps]','interpreter','latex');
ylabel('Waiting time [ms]')
grid on
xlim([0 160])


% ------ 40x40 m2 -------
subplot(3,3,2)
hold on
plot(load_mbps, s_op_40x40 * L_fpkt * 1E-6,'r','LineWidth',line_width);
plot(load_mbps, s_am_40x40 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_max_op_40x40 * L_fpkt * 1E-6,'r--','LineWidth',line_width);
plot(load_mbps, s_max_am_40x40 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_min_op_40x40 * L_fpkt * 1E-6,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_40x40 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
grid on
xlabel('$\ell$ [Mbps]','interpreter','latex');
ylabel('Throughput [Mbps]')
ylim([0 160])
xlim([0 160])

subplot(3,3,5)
hold on
plot(load_mbps, d_op_40x40,'r','LineWidth',line_width);
plot(load_mbps, d_am_40x40,'b','LineWidth',line_width);
plot(load_mbps, d_max_op_40x40,'r--','LineWidth',line_width);
plot(load_mbps, d_max_am_40x40,'b--','LineWidth',line_width);
plot(load_mbps, d_min_op_40x40,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, d_min_am_40x40,'b:','LineWidth',1.5 * line_width);
grid on
xlabel('Traffic load [Fpkt/s]')
ylabel('Delay [ms]')
ylim([0 30])
xlim([0 160])


subplot(3,3,8)
hold on
plot(load_mbps, tw_op_40x40,'r','LineWidth',line_width);
plot(load_mbps, tw_am_40x40,'b','LineWidth',line_width);
ylabel('Waiting time [ms]')
grid on
xlim([0 160])

% ----- 80x80 m2 -------
subplot(3,3,3)
hold on
plot(load_mbps, s_op_80x80 * L_fpkt * 1E-6,'r','LineWidth',line_width);
plot(load_mbps, s_am_80x80 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_max_op_80x80 * L_fpkt * 1E-6,'r--','LineWidth',line_width);
plot(load_mbps, s_max_am_80x80 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_min_op_80x80 * L_fpkt * 1E-6,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_80x80 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
grid on
xlabel('$\ell$ [Mbps]','interpreter','latex');
ylabel('Throughput [Mbps]')
ylim([0 160])
xlim([0 160])

subplot(3,3,6)
hold on
plot(load_mbps, d_op_80x80,'r','LineWidth',line_width);
plot(load_mbps, d_am_80x80,'b','LineWidth',line_width);
plot(load_mbps, d_max_op_80x80,'r--','LineWidth',line_width);
plot(load_mbps, d_max_am_80x80,'b--','LineWidth',line_width);
plot(load_mbps, d_min_op_80x80,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, d_min_am_80x80,'b:','LineWidth',1.5 * line_width);
ylim([0 30])
xlim([0 160])

grid on
xlabel('$\ell$ [Mbps]','interpreter','latex');
ylabel('Delay [ms]')

subplot(3,3,9)
hold on
plot(load_mbps, tw_op_80x80,'r','LineWidth',line_width);
plot(load_mbps, tw_am_80x80,'b','LineWidth',line_width);
xlabel('$\ell$ [Mbps]','interpreter','latex');
ylabel('Waiting time [ms]')
xlim([0 160])
grid on

% Waiting time plot
figure
hold on
plot(load_mbps, tw_op_20x20,'r','LineWidth',line_width);
plot(load_mbps, tw_am_20x20,'r--','LineWidth',line_width);
plot(load_mbps, tw_op_40x40,'y','LineWidth',line_width);
plot(load_mbps, tw_am_40x40,'y--','LineWidth',line_width);
plot(load_mbps, tw_op_80x80,'g','LineWidth',line_width);
plot(load_mbps, tw_am_80x80,'g--','LineWidth',line_width);
xlabel('Homogeneous traffic load [Mbps]');
ylabel('Waiting time [ms]')
grid on
xlim([0 160])


%% 2x3 subplots
figure
%  ------ 20x20 m2 -------
subplot(2,3,1)
hold on
plot(load_mbps, s_op_20x20 * L_fpkt * 1E-6,'r','LineWidth',line_width);
plot(load_mbps, s_am_20x20 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_max_op_20x20 * L_fpkt * 1E-6,'r--','LineWidth',line_width);
plot(load_mbps, s_max_am_20x20 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_min_op_20x20 * L_fpkt * 1E-6,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_20x20 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
grid on
ylabel('Av. Throughput [Mbps]')
legend('OP_{avg}', 'AM_{avg}', 'OP_{max}', 'AM_{max}', 'OP_{min}', 'AM_{min}')
ylim([0 160])
xlim([0 160])

subplot(2,3,4)
hold on
plot(load_mbps, d_op_20x20,'r','LineWidth',line_width);
plot(load_mbps, d_am_20x20,'b','LineWidth',line_width);
plot(load_mbps, d_max_op_20x20,'r--','LineWidth',line_width);
plot(load_mbps, d_max_am_20x20,'b--','LineWidth',line_width);
plot(load_mbps, d_min_op_20x20,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, d_min_am_20x20,'b:','LineWidth',1.5 * line_width);
grid on
ylabel('Av. delay [ms]')
ylim([0 30])
xlim([0 160])


% ------ 40x40 m2 -------
subplot(2,3,2)
hold on
plot(load_mbps, s_op_40x40 * L_fpkt * 1E-6,'r','LineWidth',line_width);
plot(load_mbps, s_am_40x40 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_max_op_40x40 * L_fpkt * 1E-6,'r--','LineWidth',line_width);
plot(load_mbps, s_max_am_40x40 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_min_op_40x40 * L_fpkt * 1E-6,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_40x40 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
grid on
ylabel('Throughput [Mbps]')
ylim([0 160])
xlim([0 160])

subplot(2,3,5)
hold on
plot(load_mbps, d_op_40x40,'r','LineWidth',line_width);
plot(load_mbps, d_am_40x40,'b','LineWidth',line_width);
plot(load_mbps, d_max_op_40x40,'r--','LineWidth',line_width);
plot(load_mbps, d_max_am_40x40,'b--','LineWidth',line_width);
plot(load_mbps, d_min_op_40x40,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, d_min_am_40x40,'b:','LineWidth',1.5 * line_width);
grid on
xlabel('Traffic load [Mbps]');
ylim([0 30])
xlim([0 160])

% ----- 80x80 m2 -------
subplot(2,3,3)
hold on
plot(load_mbps, s_op_80x80 * L_fpkt * 1E-6,'r','LineWidth',line_width);
plot(load_mbps, s_am_80x80 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_max_op_80x80 * L_fpkt * 1E-6,'r--','LineWidth',line_width);
plot(load_mbps, s_max_am_80x80 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_min_op_80x80 * L_fpkt * 1E-6,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_80x80 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
grid on
ylim([0 160])
xlim([0 160])

subplot(2,3,6)
hold on
plot(load_mbps, d_op_80x80,'r','LineWidth',line_width);
plot(load_mbps, d_am_80x80,'b','LineWidth',line_width);
plot(load_mbps, d_max_op_80x80,'r--','LineWidth',line_width);
plot(load_mbps, d_max_am_80x80,'b--','LineWidth',line_width);
plot(load_mbps, d_min_op_80x80,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, d_min_am_80x80,'b:','LineWidth',1.5 * line_width);
ylim([0 30])
xlim([0 160])
grid on