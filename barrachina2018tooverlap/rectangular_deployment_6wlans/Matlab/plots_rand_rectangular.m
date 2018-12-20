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

s_am_20x20 = [0.99
    18.2955
    33.72905
    49.3632
    64.29615
    78.66115
    92.1862
    105.0686
    117.2348
    128.63925
    139.0695
    ];

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
    20.18948423
    40.13470308
    60.2320039
    80.20930072
    100.2309219
    120.3480194
    140.2346055
    160.1263946
    180.0079297
    200.0081874];

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
    11.02785
    13.0694
    16.85485
    19.4936
    21.2022
    21.80695
    21.89145
    21.6058
    21.2158
    20.3629];

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
26.63730139
17.11110861
    ];

tw_am_20x20 = [
    0.137086585
1.6830872
4.149274475
6.35330226
7.68638806
9.702184795
10.3470871
11.31398626
12.94027334
13.98293512
15.222876
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
    19.26955
    35.62865
    52.6499
    69.58745
    86.5021
    103.1711
    119.6168
    135.97165
    152.04075
    167.74315];

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
    20.19742942
    40.15226547
    60.2529922
    80.24402335
    100.255332
    120.4452224
    140.3495821
    160.2583086
    180.1713516
    200.4000702];

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
    15.55215
    17.2631
    23.4402
    30.1814
    36.60815
    42.20345
    47.0879
    51.92745
    56.08615
    59.44745
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
15.39081839
15.89255249
16.83413272

    ];

tw_am_40x40 = [
    0.121834485
0.509832605
1.186905005
1.72929019
2.18775243
2.51467535
2.719943115
2.9061403
3.07231322
3.225533705
3.455834265

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
    19.95435
    38.5637
    57.3664
    76.08015
    94.87095
    113.5091
    132.07155
    150.6029
    169.0972
    187.4754];

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
    20.20261292
    40.16279658
    60.26287892
    80.25705852
    100.2704413
    120.5213004
    140.3938867
    160.3091093
    180.2140704
    200.4763982];

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
    19.3211
    31.7522
    45.08725
    58.61415
    72.6144
    85.38525
    98.5435
    111.3941
    124.12105
    136.31835];

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
   0.1148068
0.198989495
0.342929995
0.446825315
0.533664825
0.58708785
0.623433505
0.65876382
0.69930132
0.726315195
0.74462823
    ];

%% PLOTS

figure
subplot(1,3,1)
hold on
plot(load_mbps, s_op_20x20 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_am_20x20 * L_fpkt * 1E-6,'y','LineWidth',line_width);
plot(load_mbps, s_max_op_20x20 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_max_am_20x20 * L_fpkt * 1E-6,'y--','LineWidth',line_width);
plot(load_mbps, s_min_op_20x20 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_20x20 * L_fpkt * 1E-6,'y:','LineWidth',1.5 * line_width);
grid on
xlabel('$\ell$ [Mbps]','interpreter','latex');
ylabel('Throughput [Mbps]')
xlim([0 150])
ylim([0 150])

subplot(1,3,2)
hold on
plot(load_mbps, s_op_40x40 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_am_40x40 * L_fpkt * 1E-6,'y','LineWidth',line_width);
plot(load_mbps, s_max_op_40x40 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_max_am_40x40 * L_fpkt * 1E-6,'y--','LineWidth',line_width);
plot(load_mbps, s_min_op_40x40 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_40x40 * L_fpkt * 1E-6,'y:','LineWidth',1.5 * line_width);
grid on
xlabel('$\ell$ [Mbps]','interpreter','latex');
xlim([0 150])
ylim([0 150])

subplot(1,3,3)
hold on
plot(load_mbps, s_op_80x80 * L_fpkt * 1E-6,'b','LineWidth',line_width);
plot(load_mbps, s_am_80x80 * L_fpkt * 1E-6,'y','LineWidth',line_width);
plot(load_mbps, s_max_op_80x80 * L_fpkt * 1E-6,'b--','LineWidth',line_width);
plot(load_mbps, s_max_am_80x80 * L_fpkt * 1E-6,'y--','LineWidth',line_width);
plot(load_mbps, s_min_op_80x80 * L_fpkt * 1E-6,'b:','LineWidth',1.5 * line_width);
plot(load_mbps, s_min_am_80x80 * L_fpkt * 1E-6,'y:','LineWidth',1.5 * line_width);
grid on
xlabel('$\ell$ [Mbps]','interpreter','latex');
legend('OP_{avg}', 'AM_{avg}', 'OP_{max}', 'AM_{max}', 'OP_{min}', 'AM_{min}')
xlim([0 150])
ylim([0 150])

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






%% STARVATION

% 20x20 m2
stv20_op_20x20 = [0.00000
0.00250
0.00250
0.00333
0.00833
0.01750
0.03250
0.03417
0.04333
0.04917
0.05667
    ];

stv30_op_20x20 = [
    0.00000
0.00250
0.00250
0.00583
0.01083
0.03333
0.04917
0.06500
0.09000
0.12833
0.17583
    ];

stv50_op_20x20 =[
    0.00000
0.00250
0.00333
0.01000
0.04167
0.09833
0.17083
0.26250
0.44167
0.46250
0.47500
];

stv20_am_20x20 = [
    0.00000
0.05583
0.12833
0.14417
0.15083
0.15917
0.16583
0.17667
0.18167
0.19000
0.19667
];

stv30_am_20x20 = [
    0.00000
0.06833
0.14417
0.15167
0.16750
0.17917
0.18750
0.19583
0.20833
0.21500
0.22417
];

stv50_am_20x20 = [
    0.00000
0.09083
0.15750
0.17583
0.19333
0.20833
0.22417
0.23583
0.25333
0.27917
0.30500
];


% 40x40 m2
stv20_op_40x40 = [0.00000
0.00167
0.00167
0.00167
0.00333
0.01250
0.02167
0.02333
0.02417
0.02417
0.02417
    ];

stv30_op_40x40 = [
   0.00000
0.00167
0.00167
0.00333
0.00417
0.02083
0.02333
0.02500
0.02750
0.03417
0.05000

    ];

stv50_op_40x40 =[
    0.00000
0.00167
0.00167
0.00333
0.01917
0.02750
0.04500
0.09250
0.26417
0.27583
0.28000
];

stv20_am_40x40 = [
    0.00000
0.02083
0.09833
0.11333
0.11750
0.11750
0.12167
0.12250
0.12417
0.12500
0.12500];

stv30_am_40x40 = [
    0.00000
0.02667
0.10583
0.11917
0.12250
0.12667
0.13000
0.13417
0.13333
0.13417
0.13667];

stv50_am_40x40 = [
    0.00000
0.04000
0.11500
0.12667
0.13083
0.13417
0.13583
0.14333
0.14500
0.15000
0.16083];


% 80x80 m2
stv20_op_80x80 = [0.00000
0.00000
0.00000
0.00000
0.00000
0.00000
0.00167
0.00167
0.00167
0.00167
0.00167

    ];

stv30_op_80x80 = [
    0.00000
0.00000
0.00000
0.00000
0.00000
0.00167
0.00167
0.00167
0.00167
0.00417
0.00583

    ];

stv50_op_80x80 =[
   0.00000
0.00000
0.00000
0.00000
0.00083
0.00167
0.00583
0.02667
0.10333
0.10917
0.11250

    ];

stv20_am_80x80 = [
    0.00000
0.00000
0.03167
0.03750
0.04500
0.04417
0.04583
0.04583
0.04667
0.05000
0.05000
];

stv30_am_80x80 = [
   0.00000
0.00167
0.03417
0.04167
0.04667
0.04500
0.04750
0.05000
0.05083
0.05083
0.05083

    ];

stv50_am_80x80 = [
   0.00000
0.00250
0.03833
0.04667
0.04917
0.05083
0.05167
0.05500
0.05583
0.06000
0.06250
    ];

%% Starvation subplots
figure

subplot(1,3,1)
hold on
plot(load_mbps, stv20_op_20x20,'r','LineWidth',line_width);
plot(load_mbps, stv20_am_20x20,'b','LineWidth',line_width);
plot(load_mbps, stv30_op_20x20,'r--','LineWidth',line_width);
plot(load_mbps, stv30_am_20x20,'b--','LineWidth',line_width);
plot(load_mbps, stv50_op_20x20,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, stv50_am_20x20,'b:','LineWidth',1.5 * line_width);
grid on
ylabel('Starvation factor')
xlim([0 160])
ylim([0 0.5])

subplot(1,3,2)
hold on
plot(load_mbps, stv20_op_40x40,'r','LineWidth',line_width);
plot(load_mbps, stv20_am_40x40,'b','LineWidth',line_width);
plot(load_mbps, stv30_op_40x40,'r--','LineWidth',line_width);
plot(load_mbps, stv30_am_40x40,'b--','LineWidth',line_width);
plot(load_mbps, stv50_op_40x40,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, stv50_am_40x40,'b:','LineWidth',1.5 * line_width);
grid on
xlabel('Traffic load [Mbps]');
xlim([0 160])
ylim([0 0.5])

subplot(1,3,3)
hold on
plot(load_mbps, stv20_op_80x80,'r','LineWidth',line_width);
plot(load_mbps, stv20_am_80x80,'b','LineWidth',line_width);
plot(load_mbps, stv30_op_80x80,'r--','LineWidth',line_width);
plot(load_mbps, stv30_am_80x80,'b--','LineWidth',line_width);
plot(load_mbps, stv50_op_80x80,'r:','LineWidth',1.5 * line_width);
plot(load_mbps, stv50_am_80x80,'b:','LineWidth',1.5 * line_width);
grid on
xlim([0 160])
ylim([0 0.5])

legend('OP_{?=0.2}', 'AM_{?=0.2}', 'OP_{?=0.3}', 'AM_{?=0.3}', 'OP_{?=0.5}', 'AM_{?=0.5}');



