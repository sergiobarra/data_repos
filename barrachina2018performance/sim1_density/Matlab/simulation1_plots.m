clear
close all
clc

h = waitbar(0,'Wait, man. Life is nice and easy :)');
steps = 1000;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h)

% 07 Nov 2017: 50 scenarios per N value

%% SEVERAL POLICIES EXPERIMENTS FOR N = 2, 5, 10, 20, 30, 40, 50
n = [2 5 10 20 30 40 50];


% Only primary
s_op = [88.7092	87.0546	83.6632	74.4104	70.2544	64.7564	58.7956];
s_std_op = [5.130224501	6.657659149	5.713568684	5.431857637	4.214240271	3.493577057	3.406371677];
% f_op = [16.02	39.7294	75.687	68.7434	228.2332	300.9008];
% f_op_normalized = f_op ./  n;
jfi_op = [0.99482478	0.98039456	0.96531878	0.91096138	0.88130298	0.84766678	0.81633952];
s_min_op = [83.4474	74.6216	58.2218	23.9526	7.7852	5.774	2.5206];
bw_used_op = [19.2178	18.6808	16.22	16.0848	15.2282	13.9974	12.776];

% Static channel bonding
s_scb = [204.0248	165.557	126.6934	86.262	65.3444	54.5408	48.1138];
s_std_scb = [79.04231296	53.32091745	24.97959572	13.47854637	7.564279957	6.310292803	5.024398386];
% f_scb = [16.6206	34.8184	38.0304	74.8354	8.186	0 0];  % 0 means that no WLAN could not transmit any packet
% f_scb_normalized = f_scb ./  n;
jfi_scb = [0.89922284	0.77466786	0.69641954	0.55210592	0.49522286	0.44965876	0.4183396];
s_min_scb = [145.8368	72.6052	14.5312	0.1156	0.0016	0	0];
bw_used_scb = [63.0762	48.2498	27.92	24.9106	17.8276	14.3424	12.375];

% Always max
s_am = [207.9458	179.2794	147.4984	109.4196	92.8304	79.6536	69.4934]; 
s_std_am = [76.46798914	46.96406596	22.5740572	13.11478243	7.412856444	4.622651311	4.462094598];
% f_am = [16.7334	41.017	80.5056	99.1474	216.6374	284.972];
% f_am_normalized = f_am ./  n;
jfi_am = [0.89933022	0.8272833	0.78599182	0.76848376	0.7613314	0.72994122	0.7185129];
s_min_am = [148.776	93.5672	59.528	19.197	6.5206	3.7152	2.9976];
bw_used_am = [64.0346	51.0812	35.1	28.7632	23.0552	19.2064	16.571];

% Prob. Uniform
s_pu = [122.9184	114.8164	104.0904	86.4592	78.4548	70.1566	62.7516];
s_std_pu = [20.13604346	14.71118008	8.89584034	6.847704767	4.785154867	3.156187709	3.485733232];
% f_pu = [16.3062	40.2514	79.5312	77.1152	211.119	277.979]; 
% f_pu_normalized = f_pu ./  n;
jfi_pu = [0.96909404	0.944867	0.93002488	0.88751912	0.86222276	0.83001748	0.8014585];
s_min_pu = [104.7742	83.921	64.2926	26.791	9.5412	6.36	3.2376];
bw_used_pu = [30.9384	27.6626	21.45	20.0932	17.8552	15.7428	14.0824];

% figure
% subplot(1,2,1)
% hold on
% plot(n, s_op, '-*')
% plot(n, s_scb, '-*')
% plot(n, s_am, '-*')
% plot(n, s_pu, '-*')
% grid on
% xlabel('N')
% ylabel('Average throughput per WLAN [Mbps]')
% % xticks(1:length(n))
% % xticklabels({'2','5','10', '20', '30', '40', '50', '60'})
% legend('OP', 'SCB', 'AM', 'PU')
% 
% subplot(1,2,2)
% hold on
% plot(n, s_min_op, '-*')
% plot(n, s_min_scb, '-*')
% plot(n, s_min_am, '-*')
% plot(n, s_min_pu, '-*')
% grid on
% xlabel('N')
% ylabel('Av. MIN. Throughput [Mbps]')
% % xticks(1:length(n))
% % xticklabels({'2','5','10', '20', '30', '40', '50', '60'})
% legend('OP', 'SCB', 'AM', 'PU')

% % Average throughput per WLAN
% figure
% hold on
% plot(n, s_op, '-*')
% plot(n, s_scb, '-*')
% plot(n, s_am, '-*')
% plot(n, s_pu, '-*')
% grid on
% xlabel('N')
% ylabel('Average throughput per WLAN [Mbps]')
% legend('OP', 'SCB', 'AM', 'PU')

% figure
% hold on
% plot(n, f_op_normalized, '-*')
% plot(n, f_scb_normalized, '-*')
% plot(n, f_am_normalized, '-*')
% plot(n, f_pu_normalized, '-*')
% grid on
% xlabel('N')
% ylabel('Normalized proportional throughput')
% legend('Only-primary', 'Static CB', 'Always-max', 'Prob. uniform')


figure
hold on
plot(n, jfi_op, '-*')
plot(n, jfi_scb, '-*')
plot(n, jfi_am, '-*')
plot(n, jfi_pu, '-*')
grid on
xlabel('N')
ylabel('E[$\mathcal{F}$]','Interpreter','latex')
% xticks(1:length(n))
% xticklabels({'2','5','10', '20', '30', '40', '50', '60'})
legend('OP', 'SCB', 'AM', 'PU')

figure 
subplot(2,2,1)
errorbar(n,s_op,s_std_op)
xlabel('N')
ylabel('Av. throughput OP')
grid on
subplot(2,2,2)
errorbar(n,s_scb,s_std_scb)
xlabel('N')
ylabel('Av. throughput SCB')
grid on
subplot(2,2,3)
errorbar(n,s_am,s_std_am)
xlabel('N')
ylabel('Av. throughput AM')
grid on
subplot(2,2,4)
errorbar(n,s_pu,s_std_pu)
xlabel('N')
ylabel('Av. throughput PU')
grid on

% figure
% hold on
% errorbar(1:3,s_op,s_std_op)
% errorbar(1:3,s_scb,s_std_scb)
% errorbar(1:3,s_am,s_std_am)
% errorbar(1:3,s_pu,s_std_pu)
% grid on
% ylabel('Average throughput per WLAN [Mbps]')
% xticks(1:4)
% xticklabels({'N = 2','N = 10','N = 30'})

figure
hold on
plot(n, bw_used_op .* n, '-*')
plot(n, bw_used_scb .* n, '-*')
plot(n, bw_used_am .* n, '-*')
plot(n, bw_used_pu .* n, '-*')
grid on
xlabel('N')
ylabel('Total bandiwdth used [MHz]')
legend('OP', 'SCB', 'AM', 'PU')


figure
hold on
plot(n, bw_used_op, '-*')
plot(n, bw_used_scb, '-*')
plot(n, bw_used_am, '-*')
plot(n, bw_used_pu, '-*')
grid on
xlabel('N')
ylabel('Av. bandiwdth used [MHz]')
legend('OP', 'SCB', 'AM', 'PU')


area = 100 * 100;   % Area [m^2]
total_bw = 8 * 20;  % System's bandiwdth [MHz]


a_cs = 5384.6;

figure
hold on
plot(n, bw_used_op .* n * a_cs/ (area * total_bw), '-*')
plot(n, bw_used_scb .* n * a_cs / (area * total_bw), '-*')
plot(n, bw_used_am .* n * a_cs/ (area * total_bw), '-*')
plot(n, bw_used_pu .* n * a_cs/ (area * total_bw), '-*')
grid on
xlabel('M')
ylabel('E[$\rho$]','Interpreter','latex')
legend('OP', 'SCB', 'AM', 'PU')

%  print -depsc2 myplot.eps

figure
hold on
plot(n, bw_used_op .* n, '-*')
plot(n, bw_used_scb .* n, '-*')
plot(n, bw_used_am.* n, '-*')
plot(n, bw_used_pu.* n, '-*')
grid on
xlabel('M')
ylabel('BW [Mbps]')
legend('OP', 'SCB', 'AM', 'PU')
