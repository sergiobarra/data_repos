clc
clear
close all

load = [1 20 40 60 80 100 120 140 160 180 200 220 240];
line_width = 1;
L_fpkt = 768000;    % lenght of a packet containing 64 frames of 12,000 bits 
load_mbps = load * L_fpkt * 1E-6;    % load in Mbps 

%% Probability throughput similar to load
p_op = [100
98
92
81
68
41
10
0
0
0
0
0
0];

p_scb = [10
5
1
1
1
1
1
1
1
0
0
0
0];

p_am = [99
92
87
80
71
59
44
39
35
28
19
15
11];

p_pu = [100
95
89
79
71
60
39
26
8
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
s_am = [3
2
9
20
47
63
63
64
63
66
64
66
65];

s_pu = [19
19
19
18
17
13
15
13
13
12
13
12
11];

s_draw = [78
79
72
62
36
24
22
23
24
22
23
22
24];
    
figure
y = [s_am, s_pu, s_draw];
bar(load_mbps,y,'stacked')
xticks(load_mbps)
grid on
legend('AM', 'PU', 'Draw')
xlabel('$\ell_A$ [Fpkt/s]','interpreter','latex');
ylabel({'Share of scenarios','with smallest delay [%]'})

%% Delay comparison AM vs OP
s_am = [4
21
47
64
66
69
70
66
67
67
69
67
67];

s_op = [17
18
18
14
13
14
13
12
11
13
10
12
12];

s_draw = [79
61
35
22
21
17
17
22
22
20
21
21
21];
    
figure
y = [s_am, s_op, s_draw];
bar(load_mbps,y,'stacked')
xticks(load_mbps)
grid on
legend('AM', 'OP', 'Draw')
xlabel('$\ell_A$ [Mbps]','interpreter','latex');
ylabel({'Share of scenarios','with smallest delay [%]'})

%% Delay without outliers, where outlier if d_av > 100 ms
% - Outliers: OP = 1 scenario per load, AM = 7.25 scenarios per load, PU = 2 scenarios per load
% - Thus, 3% scenarios are outliers in average considering the three
% policies
% - SCB is not considered due to the high probability of starvation
d_op = [3.533131313
5.20979798
7.514040404
9.973333333
12.68464646
15.70979798
18.49858586
20.25494949
21.55565657
22.31909091
22.73141414
23.13717172
23.28090909];

d_am = [4.573020833
4.881182796
6.163870968
6.667717391
8.87516129
10.46225806
11.98129032
12.25054348
13.93688172
13.78369565
15.1472043
15.67354839
16.26806452];

d_pu = [3.883232323
5.739081633
7.663061224
9.793061224
11.79285714
13.80285714
15.85061224
17.11040816
18.51653061
19.44214286
19.91438776
20.50510204
20.8727551];

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
s_op = [1.0157
19.9093
39.2981
57.3847
73.4634
85.691
93.4178
96.9051
97.9561
98.2831
98.4598
98.4752
98.5347];

s_scb = [0.1697
1.4624
2.2298
2.8233
3.1062
3.4149
3.5967
4.2234
4.1268
4.0507
4.4535
4.4205
4.4929];

s_am = [1.0127
18.9557
37.2472
54.5181
70.9929
85.3256
97.2449
107.0665
115.955
123.2942
129.8192
134.0798
137.4381];

s_pu = [1.0158
19.7412
38.7416
56.4168
72.8221
86.6357
97.7886
105.4679
110.7297
113.5246
115.7085
116.4284
117.1724];

figure
hold on
plot(load_mbps, s_op* L_fpkt * 1E-6,'LineWidth',line_width);
plot(load_mbps, s_scb* L_fpkt * 1E-6,'LineWidth',line_width);
plot(load_mbps, s_am* L_fpkt * 1E-6,'LineWidth',line_width);
plot(load_mbps, s_pu* L_fpkt * 1E-6,'LineWidth',line_width);
plot(load_mbps, load_mbps,'LineWidth',line_width);
xlabel('$\ell_A$ [Mbps]','interpreter','latex');
ylabel('Av. throughput E$[\Gamma]$ [Mbps]','interpreter','latex');
xticks(load_mbps)
yticks(load_mbps)
grid on

    