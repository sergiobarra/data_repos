
clear
close all
clc

%% DELAY from Komondor

load_a_axis_new = 0:50:1000;
load_a_axis_new(1) = 1;
L_fpkt = 768000;    % lenght of a packet containing 64 frames of 12,000 bits 
load_mbps = load_a_axis_new * L_fpkt * 1E-6;    % load in Mbps 

%% A and C
d_AandC_c1_loadB_100 = [
 0.605
0.89
1.145
1.535
2.295
4.35
7.09
7.39
7.58
7.72
7.83
7.93
8
8.065
8.125
8.17
8.21
8.25
8.28
8.31
8.34
    ];

d_AandC_c1_loadB_250 = [
0.59
0.89
1.14
1.535
2.305
4.365
7.105
7.39
7.58
7.72
7.83
7.93
8
8.065
8.12
8.17
8.21
8.25
8.28
8.31
8.34
    ];

d_AandC_c1_loadB_400 = [
0.605
0.89
1.15
1.535
2.295
4.35
7.105
7.4
7.575
7.72
7.83
7.92
8
8.065
8.12
8.17
8.21
8.25
8.28
8.31
8.34
    ];

d_AandC_c2_loadB_100 = [
0.775
1.1
1.27
1.415
1.595
1.8
2.06
2.435
2.795
3.26
3.78
3.995
4.12
4.19
4.245
4.265
4.325
4.37
4.39
4.415
4.445
    ];

d_AandC_c2_loadB_250 = [
0.92
1.6
1.475
1.57
1.73
1.95
2.145
2.56
2.975
3.425
3.86
4.06
4.2
4.245
4.29
4.355
4.395
4.43
4.46
4.51
4.52
    ];

d_AandC_c2_loadB_400 = [
1.28
1.715
1.49
1.59
1.735
1.955
2.185
2.59
3.035
3.49
3.925
4.335
4.46
4.51
4.61
4.66
4.65
4.695
4.725
4.805
4.57
    ];

%% B
d_B_c1_loadB_100 = [
1.145
1.14
1.14
1.145
1.145
1.145
1.145
1.15
1.15
1.145
1.14
1.145
1.145
1.145
1.14
1.145
1.145
1.145
1.145
1.145
1.15
    ];

d_B_c1_loadB_250 = [
 4.35
4.385
4.395
4.365
4.35
4.345
4.38
4.365
4.355
4.33
4.385
4.35
4.4
4.35
4.365
4.315
4.33
4.345
4.37
4.36
4.37
    ];

d_B_c1_loadB_400 = [
7.575
7.575
7.58
7.575
7.58
7.58
7.58
7.58
7.58
7.575
7.58
7.58
7.58
7.58
7.575
7.575
7.58
7.575
7.58
7.58
7.58
    ];

d_B_c2_loadB_100 = [
0.92
3.815
11.875
15.72
19.665
25.71
31.47
35.865
42.755
52.255
172.105
317.37
217.615
217.56
235.205
302.225
226.825
219.59
257.225
251.685
251.7
    ];

d_B_c2_loadB_250 = [
1.34
6.795
15.8
20.17
23.83
27.915
34.9
35.99
38.6
44.535
97.245
153.46
124.065
135.93
143.755
126.13
132.98
135.885
148.36
117.96
129.16

    ];

d_B_c2_loadB_400 = [
  2.35
8.605
17.08
21.03
24.97
28.615
34.575
35.515
36.7
41.065
76.085
153.345
152.11
152.075
106.225
112.635
156.37
150.07
150.11
117.505
104.61

    ];


% figure
% 
% subplot(2,3,1)
% hold on
% plot(load_a_axis_new, d_AandC_c1_loadB_100,'ro-','Markersize',8);
% plot(load_a_axis_new, d_B_c1_loadB_100,'kx-','Markersize',8);
% xlabel('l_A = l_C [pkt/s]','fontsize',14);
% ylabel('Delay [ms] (l_B = 100 pkt/s)','fontsize',14);
% grid on
% set(gca, 'YScale', 'log')
% 
% subplot(2,3,2)
% hold on
% plot(load_a_axis_new, d_AandC_c1_loadB_250,'ro-','Markersize',8);
% plot(load_a_axis_new, d_B_c1_loadB_250,'kx-','Markersize',8);
% xlabel('l_A = l_C [pkt/s]','fontsize',14);
% ylabel('Delay [ms] (l_B = 200 pkt/s)','fontsize',14);
% grid on
% set(gca, 'YScale', 'log')
% 
% subplot(2,3,3)
% hold on
% plot(load_a_axis_new, d_AandC_c1_loadB_400,'ro-','Markersize',8);
% plot(load_a_axis_new, d_B_c1_loadB_400,'kx-','Markersize',8);
% xlabel('l_A = l_C [pkt/s]','fontsize',14);
% ylabel('Delay [ms] (l_B = 400 pkt/s)','fontsize',14);
% grid on
% set(gca, 'YScale', 'log')
% 
% subplot(2,3,4)
% hold on
% plot(load_a_axis_new, d_AandC_c2_loadB_100,'ro-','Markersize',8);
% plot(load_a_axis_new, d_B_c2_loadB_100,'kx-','Markersize',8);
% xlabel('l_A = l_C [pkt/s]','fontsize',14);
% ylabel('Delay [ms] (l_B = 100 pkt/s)','fontsize',14);
% grid on
% set(gca, 'YScale', 'log')
% 
% subplot(2,3,5)
% hold on
% plot(load_a_axis_new, d_AandC_c2_loadB_250,'ro-','Markersize',8);
% plot(load_a_axis_new, d_B_c2_loadB_250,'kx-','Markersize',8);
% xlabel('l_A = l_C [pkt/s]','fontsize',14);
% ylabel('Delay [ms] (l_B = 200 pkt/s)','fontsize',14);
% grid on
% set(gca, 'YScale', 'log')
% 
% subplot(2,3,6)
% hold on
% plot(load_a_axis_new, d_AandC_c2_loadB_400,'ro-','Markersize',8);
% plot(load_a_axis_new, d_B_c2_loadB_400,'kx-','Markersize',8);
% xlabel('l_A = l_C [pkt/s]','fontsize',14);
% ylabel('Delay [ms] (l_B = 400 pkt/s)','fontsize',14);
% grid on
% set(gca, 'YScale', 'log')



figure

subplot(3,3,1)
hold on
plot(load_mbps, d_AandC_c1_loadB_100,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, d_B_c1_loadB_100,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, d_AandC_c2_loadB_100,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, d_B_c2_loadB_100,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('l_A = l_C [pkt/s]');
ylabel('Delay [ms] (l_B = 100 pkt/s)');
grid on
legend('C_{no}: A&C','C_{no}: B','C_{ov}: A&C','C_{ov}: B');
set(gca, 'YScale', 'log')

subplot(3,3,2)
hold on
plot(load_mbps, d_AandC_c1_loadB_250,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, d_B_c1_loadB_250,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, d_AandC_c2_loadB_250,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, d_B_c2_loadB_250,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('l_A = l_C [pkt/s]');
ylabel('Delay [ms] (l_B = 250 pkt/s)');
grid on
set(gca, 'YScale', 'log')

subplot(3,3,3)
hold on
plot(load_mbps, d_AandC_c1_loadB_400,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, d_B_c1_loadB_400,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, d_AandC_c2_loadB_400,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, d_B_c2_loadB_400,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('l_A = l_C [pkt/s]');
ylabel('Delay [ms] (l_B = 400 pkt/s)');
grid on
set(gca, 'YScale', 'log')

%% THROUGHPUT

%% A and C
s_AandC_c1_loadB_100 = [
 1
50.015
100.015
150.03
200.015
249.965
264.925
264.94
264.93
264.93
264.935
264.935
264.94
264.935
264.94
264.93
264.935
264.94
264.935
264.935
264.94
    ];

s_AandC_c1_loadB_250 = [
1.005
49.98
99.985
150.005
200.015
249.84
264.935
264.93
264.935
264.94
264.94
264.94
264.935
264.935
264.93
264.93
264.94
264.93
264.935
264.94
264.93
    ];

s_AandC_c1_loadB_400 = [
 1
50
100.05
149.98
200
249.955
264.93
264.935
264.94
264.935
264.935
264.93
264.93
264.935
264.935
264.93
264.93
264.92
264.94
264.935
264.93
    ];

s_AandC_c2_loadB_100 = [
  1
50.015
100.015
150.03
200.015
250.02
299.53
346.345
388.335
427.92
466.565
472.41
472.19
472.605
472.43
472.375
472.59
472.495
472.535
472.195
472.23
    ];

s_AandC_c2_loadB_250 = [
   1.005
49.98
99.985
150.005
200.015
249.725
298.175
342.525
382.5
420.255
459.855
465.98
466.21
466.965
466.675
466.875
466.55
465.97
466.43
466.505
466.995
    ];

s_AandC_c2_loadB_400 = [
1
50
100.05
149.985
199.98
249.615
297.725
341.965
381.46
418.13
457.765
442.54
442.635
442.715
443.04
442.79
442.68
442.835
442.8
443.23
464.665
    ];

%% B
s_B_c1_loadB_100 = [
 100.03
100.04
100.02
99.95
99.985
99.975
99.995
99.975
100.01
100.005
100.005
100.015
100.015
100
99.98
100.005
100.04
100.02
100.035
99.98
100.005
    ];

s_B_c1_loadB_250 = [
  249.94
249.96
250.05
249.965
249.935
249.93
250
249.975
249.945
249.9
249.915
249.94
249.97
249.97
249.935
249.915
249.925
249.885
249.9
249.93
249.935
    ];

s_B_c1_loadB_400 = [
  264.93
264.94
264.93
264.935
264.93
264.935
264.93
264.93
264.935
264.93
264.935
264.93
264.94
264.93
264.945
264.93
264.945
264.935
264.935
264.935
264.93
    ];

s_B_c2_loadB_100 = [
 100.03
100.02
91.595
84.03
76.93
67.56
57.56
51.445
45.38
37.12
15.155
9.71
9.965
9.475
9.665
9.715
9.46
9.63
9.585
9.9
9.91
    ];

s_B_c2_loadB_250 = [
250.005
216.95
123.615
101.85
87.765
75.505
64.55
61.015
56.065
49.005
23.74
17.68
17.375
16.515
16.87
16.605
16.98
17.67
17.065
17.02
16.535
    ];

s_B_c2_loadB_400 = [
 399.98
232.015
126.12
103.005
89.025
77.08
66.185
62.295
58.425
51.91
26.325
17.795
18.1
17.81
17.465
17.825
17.82
17.665
17.635
17.22
19.37
    ];

subplot(3,3,4)
hold on
plot(load_mbps, s_AandC_c1_loadB_100 * L_fpkt * 1E-6,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, s_B_c1_loadB_100* L_fpkt * 1E-6,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, s_AandC_c2_loadB_100* L_fpkt * 1E-6,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, s_B_c2_loadB_100* L_fpkt * 1E-6,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('l_A = l_C [pkt/s]');
ylabel('Throughput [Mbps] (l_B = 100 pkt/s)');
grid on
legend('C_{no}: A&C','C_{no}: B','C_{ov}: A&C','C_{ov}: B');

subplot(3,3,5)
hold on
plot(load_mbps, s_AandC_c1_loadB_250* L_fpkt * 1E-6,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, s_B_c1_loadB_250* L_fpkt * 1E-6,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, s_AandC_c2_loadB_250* L_fpkt * 1E-6,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, s_B_c2_loadB_250* L_fpkt * 1E-6,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('l_A = l_C [pkt/s]');
ylabel('Throughput [Mbps] (l_B = 250 pkt/s)');
grid on

subplot(3,3,6)
hold on
plot(load_mbps, s_AandC_c1_loadB_400* L_fpkt * 1E-6,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, s_B_c1_loadB_400* L_fpkt * 1E-6,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, s_AandC_c2_loadB_400* L_fpkt * 1E-6,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, s_B_c2_loadB_400* L_fpkt * 1E-6,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('l_A = l_C [pkt/s]');
ylabel('Throughput [Mbps] (l_B = 400 pkt/s)');
grid on

%% DROP RATIO

drop_AandC_c1_loadB_100 = [
 0
0
0
0
0
0.02565
11.6793
24.31165
33.77175
41.11615
47.0191
51.83275
55.8461
59.247
62.1487
64.6767
66.88095
68.83305
70.56115
72.11235
73.5067
    ];

drop_AandC_c1_loadB_250 = [
 0
0
0
0
0
0.0251
11.6663
24.27815
33.76095
41.13555
47.01185
51.82625
55.8449
59.24005
62.15565
64.67535
66.88125
68.8368
70.56585
72.1143
73.5047
    ];

drop_AandC_c1_loadB_400 = [
 0
0
0
0
0
0.023
11.6701
24.3028
33.77475
41.1182
47.0063
51.8298
55.84425
59.24155
62.1546
64.67185
66.8849
68.83215
70.56305
72.11175
73.50715
    ];

drop_AandC_c2_loadB_100 = [
    0
0
0
0
0
0.0042
0.1423
1.0556
2.92195
4.90145
6.7058
14.11255
21.3017
27.30345
32.5054
37.01825
40.921
44.42395
47.4933
50.29805
52.7771 
    ];

drop_AandC_c2_loadB_250 = [
  0
0
0
0
0.0006
0.07255
0.5832
2.1002
4.3689
6.6273
8.02875
15.27085
22.30105
28.1573
33.33615
37.75085
41.67955
45.1777
48.1774
50.8994
53.2943
    ];

drop_AandC_c2_loadB_400 = [
0
0
0
0
0.0099
0.1592
0.73585
2.29425
4.648
7.0716
8.43495
19.5363
26.2261
31.8733
36.7104
40.96145
44.669
47.90145
50.79835
53.34405
53.53425

    ];

%% B
drop_B_c1_loadB_100 = [
 0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
    ];

drop_B_c1_loadB_250 = [
  0.0247
0.0253
0.0255
0.02675
0.02435
0.02425
0.0247
0.02645
0.02325
0.0252
0.02385
0.02365
0.0235
0.0233
0.02335
0.0242
0.02415
0.0253
0.0266
0.02455
0.02495
    ];

drop_B_c1_loadB_400 = [
33.7662
33.76465
33.75785
33.7747
33.7596
33.75735
33.7788
33.78455
33.7561
33.75845
33.7783
33.77875
33.76875
33.77535
33.74305
33.77855
33.77515
33.77245
33.7636
33.76795
33.76305
    ];

drop_B_c2_loadB_100 = [
 0
0.026
8.4194
15.92875
23.05905
32.4199
42.4375
48.5395
54.6196
62.8817
84.84025
90.29105
90.03575
90.5244
90.32785
90.2831
90.54135
90.3689
90.41835
90.09255
90.09155
    ];

drop_B_c2_loadB_250 = [
  0
13.2282
50.5762
59.2642
64.89285
69.79575
74.186
75.59775
77.574
80.39525
90.5023
92.92905
93.0496
93.3951
93.2505
93.35705
93.206
92.92975
93.17085
93.1911
93.3858
    ];

drop_B_c2_loadB_400 = [
 0.00415
41.9957
68.46595
74.25105
77.74065
80.7272
83.4561
84.4294
85.3919
87.0205
93.41895
95.5515
95.47495
95.54835
95.6321
95.5435
95.5442
95.5833
95.5917
95.6935
95.15675
    ];

subplot(3,3,7)
hold on
plot(load_mbps, drop_AandC_c1_loadB_100,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, drop_B_c1_loadB_100,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, drop_AandC_c2_loadB_100,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, drop_B_c2_loadB_100,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('l_A = l_C [pkt/s]');
xlabel('$\ell_A, \ell_C$ [Mbps]','interpreter','latex');

ylabel('Drop ratio [%] (l_B = 100 pkt/s)');
grid on
legend('C_{no}: A&C','C_{no}: B','C_{ov}: A&C','C_{ov}: B');

subplot(3,3,8)
hold on
plot(load_mbps, drop_AandC_c1_loadB_250,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, drop_B_c1_loadB_250,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, drop_AandC_c2_loadB_250,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, drop_B_c2_loadB_250,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('$\ell_A, \ell_C$ [Mbps]','interpreter','latex');
ylabel('Drop ratio [%] (l_B = 250 pkt/s)');
grid on

subplot(3,3,9)
hold on
plot(load_mbps, drop_AandC_c1_loadB_400,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, drop_B_c1_loadB_400,'m^-','LineWidth', 1, 'Markersize',7);
plot(load_mbps, drop_AandC_c2_loadB_400,'bo--','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
plot(load_mbps, drop_B_c2_loadB_400,'m^--','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
xlabel('l_A = l_C [pkt/s]');
ylabel('Drop ratio [%] (l_B = 400 pkt/s)');
grid on

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')

str = '$$\sin(x) = \sum_{n=0}^{\infty}{\frac{(-1)^n x^{2n+1}}{(2n+1)!}}$$';
text(-2,1,str,'Interpreter','latex')
