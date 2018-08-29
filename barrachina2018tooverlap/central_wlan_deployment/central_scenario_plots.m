clc
clear
close all

load = [1 20 40 60 80 100 120 140 160 180 200 220 240];
line_width = 1;
L_fpkt = 768000;    % lenght of a packet containing 64 frames of 12,000 bits 
load_mbps = load * L_fpkt * 1E-6;    % load in Mbps 

%% Probability throughput similar to load
p_op = [100
99
88
75
65
39
5
0
0
0
0
0
0];

p_scb = [41
10
7
6
5
3
2
1
1
1
1
1
1];

p_am = [100
98
93
81
73
58
51
36
30
24
18
13
12];

p_pu = [100
99
93
80
68
56
35
18
4
0
0
0
0];

figure
hold on
plot(load_mbps, p_op/100,'LineWidth',line_width);
plot(load_mbps, p_scb/100,'LineWidth',line_width);
plot(load_mbps, p_am/100,'LineWidth',line_width);
plot(load_mbps, p_pu/100,'LineWidth',line_width);
xlabel('$\ell_A$ [Fpkt/s]','interpreter','latex');
ylabel('$P_A$','interpreter','latex');
xticks(load_mbps)
grid on

%% Delay comparison AM vs PU
s_am = [7
15
26
37
63
72
76
78
78
77
78
78
81];

s_pu = [10
2
3
4
2
2
2
5
1
4
3
1
0];

s_draw = [83
83
71
59
35
26
22
17
21
19
19
21
19];
    
figure
y = [s_am, s_pu, s_draw];
bar(load_mbps,y,'stacked')
xticks(load_mbps)
grid on
legend('AM', 'PU', 'Draw')
xlabel('$\ell_A$ [Fpkt/s]','interpreter','latex');
ylabel({'Share of scenarios','with smallest delay [%]'})

%% Delay comparison AM vs OP
s_am = [15
35
63
68
76
81
83
81
81
84
83
80
82
];

s_op = [3
1
1
5
4
2
0
3
1
2
2
2
3];

s_draw = [82
64
36
27
20
17
17
16
18
14
15
18
15];
    
figure
y = [s_am, s_op, s_draw];
bar(load_mbps,y,'stacked')
xticks(load_mbps)
grid on
legend('AM', 'OP', 'Draw')
xlabel('$\ell_A$ [Mbps]','interpreter','latex');
ylabel({'Share of scenarios','with smallest delay [%]'})

%% Delay
d_op = [4.6316
7.1209
10.1029
12.7321
15.4154
18.4666
21.2796
22.6321
24.1704
24.8642
25.2796
26.1796
25.6504];

d_am = [4.0478
6.1593
7.5114
9.5634
11.2151
12.4958
13.9303
15.0833
15.9874
16.7205
17.2423
17.8794
18.0054];

d_pu = [4.0829
6.7985
8.926
10.719
12.995
15.3203
16.5193
18.1926
19.4836
20.3422
20.9629
21.6617
22.1456];

figure
hold on
plot(load_mbps, d_op,'LineWidth',line_width);
plot(load_mbps, d_am,'LineWidth',line_width);
plot(load_mbps, d_pu,'LineWidth',line_width);
xlabel('$\ell_A$ [Mbps]','interpreter','latex');
ylabel('Av. delay E[d] [ms]');
xticks(load_mbps)
grid on

%% Thoruhgput
s_op = [1.0156
19.9539
39.2167
57.1235
72.4663
84.2708
91.238
94.3915
95.5141
95.7374
95.9577
95.6997
96.1021];

s_scb = [0.5819
4.8572
7.1008
8.7957
10.3482
11.312
12.4019
12.9661
13.9142
14.1443
14.3575
15.0119
15.8583];

s_am = [1.016
19.9412
39.5052
57.6985
74.8717
89.4747
102.2016
111.994
120.6916
127.5146
133.3875
137.5811
141.5213];

s_pu = [1.0155
19.9347
39.3536
57.5033
73.7822
87.3636
98.1748
105.2496
109.9542
112.3362
114.4731
114.6602
115.6121];

figure
hold on
plot(load_mbps, s_op,'LineWidth',line_width);
plot(load_mbps, s_scb,'LineWidth',line_width);
plot(load_mbps, s_am,'LineWidth',line_width);
plot(load_mbps, s_pu,'LineWidth',line_width);
xlabel('$\ell_A$ [Mbps]','interpreter','latex');
ylabel('Av. throughput E[?] [Mbps]');
xticks(load_mbps)
grid on

    