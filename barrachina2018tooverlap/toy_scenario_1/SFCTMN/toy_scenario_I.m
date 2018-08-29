% Scenario:
% - 2 WLANs overlapping
% - Unsaturated: A's load is fixed and B varies
% - Probabilistic channel bonding depending on alpha values

clc
clear
close all

%% MATLAB management
flag_verbose = 0;

L_fpkt = 768000;    % lenght of a packet containing 64 frames of 12,000 bits
%load_mbps = load * L_fpkt * 1E-6;    % load in Mbps

%% Scenario parameters

PACKET_LENGTH = 12000;              % Payload length [bits]
NUM_PACKETS_AGGREGATED = 64;        % Number of packets aggregated
SINGLE_USER_SPATIAL_STREAMS = 1;
MCS_INDEX = 11;

T_slot = 9E-6;          % Slot duration [s]
CW_min = 16;            % Minimum CW [slots]
EB_A = (CW_min - 1) / 2 * T_slot;   % Expected BO value [s] for A
EB_B = (CW_min - 1) / 2 * T_slot;   % Expected BO value [s] for B
lambda_A = 1/EB_A;      % Attempt rate when packet ready for transmission [1/s]
lambda_B = 1/EB_B;      % Attempt rate when packet ready for transmission [1/s]
% mu: departure per number of channels [packets/s] (1/E[T_successful])
[T_succ(1), ~, R(1)] = ieee11axSUtransmission(PACKET_LENGTH, NUM_PACKETS_AGGREGATED, 1 * 20,...
    SINGLE_USER_SPATIAL_STREAMS, MCS_INDEX);
[T_succ(2), ~, R(2)] = ieee11axSUtransmission(PACKET_LENGTH, NUM_PACKETS_AGGREGATED, 2 * 20,...
    SINGLE_USER_SPATIAL_STREAMS, MCS_INDEX);
[T_succ(4), ~, R(4)] = ieee11axSUtransmission(PACKET_LENGTH, NUM_PACKETS_AGGREGATED, 4 * 20,...
    SINGLE_USER_SPATIAL_STREAMS, MCS_INDEX);

disp('Data rates (without overheads):')
disp(['- 1 channel: ' num2str(R(1) * 1E-6) ' Mbps (' num2str(R(1)/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)'])
disp(['- 2 channels: ' num2str(R(2) * 1E-6) ' Mbps (' num2str(R(2)/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)'])
disp(['- 4 channels: ' num2str(R(4) * 1E-6) ' Mbps (' num2str(R(4)/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)'])
mu(1) = 1 / T_succ(1);
mu(2) = 1 / T_succ(2);

load_A_packets = 100;   % Note that all packets assume NUM_PACKETS_AGGREGATED frames aggregated
load_A = load_A_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;  % Traffic load of WLAN A [bps] (40 packets/s)
disp(['Fixed traffic load in A: ' num2str(load_A/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' packets/s'])
disp(['- ' num2str(load_A * 1E-6) ' Mbps'])

% load_B = 1E6 : 1E6 : R(2);           % Traffic loads of WLAN B [bps]
load_B_packets = 0:10:300;
% load_B_packets = [1 10 40 80 120 150 200 250];
load_B = load_B_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;

delta_rho = 0.00001;                     % Delta value for rho
MaxIter = 1000000;                        % Max. num. iterations for finding rho


%% Scenario 2a OP
% Single channel
alfa_A = [1 0];
alfa_B = [1 0];
% Activity ratios
theta_A11 = alfa_A(1) * lambda_A / mu(1);
theta_A12 = alfa_A(2) * lambda_A / mu(2);
theta_B11 = alfa_B(1) * lambda_B / mu(1);
theta_B22 = alfa_B(1) * lambda_B / mu(1);
theta_B12 = alfa_B(2) * lambda_B / mu(2);
disp('[OP] Computing Scenario 2a: different CA, overlapping, alpha dependant... ')
for load_B_ix = 1 : length(load_B)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_A/R(1));             % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B(load_B_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    
    if flag_verbose
        disp(['- load_B_ix: ' num2str(load_B_ix) ' (load_B = ' num2str(load_B(load_B_ix)) ')'])
    end
    
    % Iterate until rho converges, i.e., rho | S_A = load_A and S_B = load_B
    for iter = 1 : MaxIter
        
        if flag_verbose
            disp(['   + iter: ' num2str(iter)])
            disp(['     * rho_A: ' num2str(rho_A) ', rho_B: ' num2str(rho_B)])
        end
        
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + rho_A * theta_A11 + rho_A * theta_A12 + rho_B * theta_B22 +  rho_B * theta_B12...
            + (rho_A * theta_A11 * rho_B * theta_B22) );
        pi_A11 = pi_empty * rho_A * theta_A11;
        pi_A12 = pi_empty * rho_A * theta_A12;
        pi_B22 = pi_empty * rho_B * theta_B22;
        pi_B12 = pi_empty * rho_B * theta_B12;
        pi_A11_B22 = pi_empty * rho_A * theta_A11 * rho_B * theta_B22;
        
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A11) ' ' num2str(pi_A12) ...
                ' ' num2str(pi_B22) ' ' num2str(pi_B12) ' ' num2str(pi_A11_B22)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A11 + pi_A12 + pi_B22 + pi_B12 + pi_A11_B22)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(1) * (pi_A11 + pi_A11_B22) + mu(2) * pi_A12);
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(1) * (pi_B22 + pi_A11_B22) + mu(2) * pi_B12);
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        
        % Update rhos
        if(s_A<load_A)
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B(load_B_ix))
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
    end
    
    s_A_op(load_B_ix) = s_A;
    s_B_op(load_B_ix) = s_B;
    rho_A_op(load_B_ix) = rho_A;
    rho_B_op(load_B_ix) = rho_B;
    
end

% figure
% hold on
% plot(RhoiterA)
% plot(RhoiterB)
% ylabel('Rho')
% legend('A', 'B')
%
% figure
% hold on
% plot(SiterA)
% plot(SiterB)
% ylabel('Rho')
% legend('A', 'B')

disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A11) ' ' num2str(pi_A12) ...
    ' ' num2str(pi_B22) ' ' num2str(pi_B12) ' ' num2str(pi_A11_B22)])
checksum = pi_empty + pi_A11 + pi_A12 + pi_B22 + pi_B12 + pi_A11_B22;
disp(['     * checksum (must be 1!): ' num2str(checksum)]);
if abs(checksum - 1) > 0.0001
    warning('The sum of probabilities is not 1!')
end

%% Scenario 2a AM
% Always max
alfa_A = [0 1];
alfa_B = [0 1];
% Activity ratios
theta_A11 = alfa_A(1) * lambda_A / mu(1);
theta_A12 = alfa_A(2) * lambda_A / mu(2);
theta_B11 = alfa_B(1) * lambda_B / mu(1);
theta_B22 = alfa_B(1) * lambda_B / mu(1);
theta_B12 = alfa_B(2) * lambda_B / mu(2);
disp('[AM] Computing Scenario 2a: different CA, overlapping, alpha dependant... ')
for load_B_ix = 1 : length(load_B)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_A/R(1));             % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B(load_B_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    
    if flag_verbose
        disp(['- load_B_ix: ' num2str(load_B_ix) ' (load_B = ' num2str(load_B(load_B_ix)) ')'])
    end
    
    % Iterate until rho converges, i.e., rho | S_A = load_A and S_B = load_B
    for iter = 1 : MaxIter
        
        if flag_verbose
            disp(['   + iter: ' num2str(iter)])
            disp(['     * rho_A: ' num2str(rho_A) ', rho_B: ' num2str(rho_B)])
        end
        
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + rho_A * theta_A11 + rho_A * theta_A12 + rho_B * theta_B22 +  rho_B * theta_B12...
            + (rho_A * theta_A11 * rho_B * theta_B22) );
        pi_A11 = pi_empty * rho_A * theta_A11;
        pi_A12 = pi_empty * rho_A * theta_A12;
        pi_B22 = pi_empty * rho_B * theta_B22;
        pi_B12 = pi_empty * rho_B * theta_B12;
        pi_A11_B22 = pi_empty * rho_A * theta_A11 * rho_B * theta_B22;
        
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A11) ' ' num2str(pi_A12) ...
                ' ' num2str(pi_B22) ' ' num2str(pi_B12) ' ' num2str(pi_A11_B22)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A11 + pi_A12 + pi_B22 + pi_B12 + pi_A11_B22)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(1) * (pi_A11 + pi_A11_B22) + mu(2) * pi_A12);
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(1) * (pi_B22 + pi_A11_B22) + mu(2) * pi_B12);
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        
        % Update rhos
        if(s_A<load_A)
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B(load_B_ix))
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
    end
    
    s_A_am(load_B_ix) = s_A;
    s_B_am(load_B_ix) = s_B;
    rho_A_am(load_B_ix) = rho_A;
    rho_B_am(load_B_ix) = rho_B;
    
end

% figure
% hold on
% plot(RhoiterA)
% plot(RhoiterB)
% ylabel('Rho')
% legend('A', 'B')
%
% figure
% hold on
% plot(SiterA)
% plot(SiterB)
% ylabel('Rho')
% legend('A', 'B')

disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A11) ' ' num2str(pi_A12) ...
    ' ' num2str(pi_B22) ' ' num2str(pi_B12) ' ' num2str(pi_A11_B22)])
checksum = pi_empty + pi_A11 + pi_A12 + pi_B22 + pi_B12 + pi_A11_B22;
disp(['     * checksum (must be 1!): ' num2str(checksum)]);
if abs(checksum - 1) > 0.0001
    warning('The sum of probabilities is not 1!')
end

%% Scenario 2a PU

% Prob. Uniform
alfa_A = [0.5 0.5];
alfa_B = [0.5 0.5];
% Activity ratios
theta_A11 = alfa_A(1) * lambda_A / mu(1);
theta_A12 = alfa_A(2) * lambda_A / mu(2);
theta_B11 = alfa_B(1) * lambda_B / mu(1);
theta_B22 = alfa_B(1) * lambda_B / mu(1);
theta_B12 = alfa_B(2) * lambda_B / mu(2);
disp('[PU] Computing Scenario 2a: different CA, overlapping, alpha dependant... ')
for load_B_ix = 1 : length(load_B)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_A/R(1));             % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B(load_B_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    
    if flag_verbose
        disp(['- load_B_ix: ' num2str(load_B_ix) ' (load_B = ' num2str(load_B(load_B_ix)) ')'])
    end
    
    % Iterate until rho converges, i.e., rho | S_A = load_A and S_B = load_B
    for iter = 1 : MaxIter
        
        if flag_verbose
            disp(['   + iter: ' num2str(iter)])
            disp(['     * rho_A: ' num2str(rho_A) ', rho_B: ' num2str(rho_B)])
        end
        
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + rho_A * theta_A11 + rho_A * theta_A12 + rho_B * theta_B22 +  rho_B * theta_B12...
            + (rho_A * theta_A11 * rho_B * theta_B22) );
        pi_A11 = pi_empty * rho_A * theta_A11;
        pi_A12 = pi_empty * rho_A * theta_A12;
        pi_B22 = pi_empty * rho_B * theta_B22;
        pi_B12 = pi_empty * rho_B * theta_B12;
        pi_A11_B22 = pi_empty * rho_A * theta_A11 * rho_B * theta_B22;
        
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A11) ' ' num2str(pi_A12) ...
                ' ' num2str(pi_B22) ' ' num2str(pi_B12) ' ' num2str(pi_A11_B22)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A11 + pi_A12 + pi_B22 + pi_B12 + pi_A11_B22)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(1) * (pi_A11 + pi_A11_B22) + mu(2) * pi_A12);
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(1) * (pi_B22 + pi_A11_B22) + mu(2) * pi_B12);
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        
        % Update rhos
        if(s_A<load_A)
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B(load_B_ix))
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
    end
    
    s_A_pu(load_B_ix) = s_A;
    s_B_pu(load_B_ix) = s_B;
    rho_A_pu(load_B_ix) = rho_A;
    rho_B_pu(load_B_ix) = rho_B;
    
end

% figure
% hold on
% plot(RhoiterA)
% plot(RhoiterB)
% ylabel('Rho')
% legend('A', 'B')
%
% figure
% hold on
% plot(SiterA)
% plot(SiterB)
% ylabel('Rho')
% legend('A', 'B')

disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A11) ' ' num2str(pi_A12) ...
    ' ' num2str(pi_B22) ' ' num2str(pi_B12) ' ' num2str(pi_A11_B22)])
checksum = pi_empty + pi_A11 + pi_A12 + pi_B22 + pi_B12 + pi_A11_B22;
disp(['     * checksum (must be 1!): ' num2str(checksum)]);
if abs(checksum - 1) > 0.0001
    warning('The sum of probabilities is not 1!')
end

%% PLOTS

disp('--------------------------------------------------------')
disp('Fixed traffic loads:')
disp([' - load_A = ' num2str(load_A_packets) ' packets/s'])
disp([' - load_B = ' num2str(load_B_packets) ' packets/s'])

s_A_op_kom = [99.98
    99.97
    99.94
    99.94
    99.97
    99.99
    99.99
    99.98
    99.98
    99.97
    100.03
    99.95
    99.98
    100.03
    99.97
    100.04];

s_B_op_kom = [1
    19.99
    40.01
    59.99
    79.95
    99.94
    119.94
    139.42
    142.4
    142.4
    142.4
    142.4
    142.4
    142.4
    142.4
    142.4];

s_A_am_kom = [99.98
    99.97
    99.94
    99.94
    99.97
    99.99
    99.99
    99.98
    99.97
    99.94
    99.95
    99.85
    99.85
    99.89
    99.85
    99.9];

s_B_am_kom = [1
    19.99
    40.01
    59.99
    79.95
    99.94
    119.94
    139.94
    159
    167.26
    168.83
    169.43
    169.52
    169.78
    169.66
    169.64];

s_A_pu_kom = [99.98
    99.97
    99.94
    99.94
    99.97
    99.99
    99.99
    99.98
    99.98
    99.97
    100.03
    99.95
    99.97
    100.03
    99.97
    100.04];

s_B_pu_kom = [1
    19.99
    40.01
    59.99
    79.95
    99.94
    119.94
    139.55
    144.26
    144.42
    144.49
    144.52
    144.48
    144.5
    144.52
    144.48];

d_A_op_kom = [
    2.41
    2.41
    2.41
    2.41
    2.41
    2.41
    2.42
    2.41
    2.41
    2.41
    2.42
    2.41
    2.42
    2.42
    2.41
    2.42
    ];

d_B_op_kom =[
    0.65
    0.85
    1.08
    1.35
    1.74
    2.41
    3.88
    9.22
    13.17
    13.63
    13.92
    14.15
    14.34
    14.51
    14.64
    14.77
    ];

d_A_am_kom = [
    1.19
    1.77
    2.04
    2.28
    2.57
    2.96
    3.53
    4.4
    5.82
    6.77
    7.02
    7.08
    7.11
    7.13
    7.11
    7.15
    ];

d_B_am_kom = [
    0.92
    1.45
    1.77
    2.09
    2.47
    2.97
    3.66
    4.75
    7
    9.44
    10.49
    11.05
    11.45
    11.73
    11.95
    12.1
    ];

d_A_pu_kom = [
    1.66
    2.09
    2.31
    2.41
    2.46
    2.5
    2.55
    2.63
    2.68
    2.7
    2.71
    2.71
    2.71
    2.71
    2.71
    2.71
    ];

d_B_pu_kom = [
    0.79
    1.01
    1.19
    1.45
    1.84
    2.5
    3.89
    8.48
    12.64
    13.27
    13.61
    13.87
    14.08
    14.26
    14.4
    14.53
    ];


% figure
%
% subplot(1,3,1)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), rho_A_op,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), rho_A_am,'m^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), rho_A_pu,'gp-','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), rho_B_op,'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), rho_B_am,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), rho_B_pu,'gp--','LineWidth', 1,...
%     'MarkerFaceColor','g','MarkerEdgeColor','k', 'Markersize',7);
% xlabel('$\ell_B$ [pkt/s]','interpreter','latex');
% ylabel(['\rho_A [n.d] (l_a = ' num2str(load_A/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)']);
% ylabel('$\rho$ ($\ell = 100$ pkt/s = 6400 frames/s)','interpreter','latex');
% grid on
% xlim([0 300])
%
% subplot(1,3,2)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_A_op/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED),'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_A_am/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED),'m^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_A_pu/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED),'gp-','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_B_op/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED),'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_B_am/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED),'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_B_pu/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED),'gp--','LineWidth', 1,...
%     'MarkerFaceColor','g','MarkerEdgeColor','k', 'Markersize',7);
% xlabel('$\ell_B$ [pkt/s]','interpreter','latex');
% ylabel('$\Gamma$ [pkt/s] ($\ell = 100$ pkt/s  = 6400 frames/s)','interpreter','latex');
% grid on
% xlim([0 300])
%
% grid on
% subplot(1,3,3)
% hold on
%
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_A_am_kom,'m^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_A_pu_kom,'gp-','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_B_op_kom,'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_B_am_kom,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_B_pu_kom,'gp--','LineWidth', 1,...
%     'MarkerFaceColor','g','MarkerEdgeColor','k', 'Markersize',7);
%
%
% legend('A - OP','A - AM','A - PU', ' B - OP', 'B - AM', 'B - PU');
% ylabel(['delay [ms] (l_a = ' num2str(load_A/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)']);
% xlabel('$\ell_B$ [pkt/s]','interpreter','latex');
% ylabel('$d$ [ms] ($\ell = 100$ pkt/s = 6400 frames/s)','interpreter','latex');
% grid on
% xlim([0 300])


%% KOMONDOR PLOTS AGG

drop_ratio_A_op_kom = [
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
drop_ratio_B_op_kom = [
    0
    0
    0
    0
    0
    0
    0
    0.3723
    10.987
    20.8856
    28.7695
    35.2719
    40.6665
    45.2242
    49.1454
    52.5163
    ];
drop_ratio_A_am_kom = [
    0
    0
    0
    0
    0
    0
    0
    0
    0.0015
    0.0342
    0.0852
    0.1002
    0.1218
    0.1407
    0.1287
    0.1388
    ];
drop_ratio_B_am_kom = [
    0
    0
    0
    0
    0
    0
    0
    0.0014
    0.6113
    7.0697
    15.5525
    22.9858
    29.3645
    34.6919
    39.4105
    43.4327
    ];
drop_ratio_A_pu_kom = [
    0
    0
    0
    0
    0
    0
    0
    0
    0
    0.0004
    0.0004
    0.0008
    0.0019
    0.0009
    0.0014
    0.0006
    
    
    ];
drop_ratio_B_pu_kom = [
    0
    0
    0
    0
    0
    0
    0
    0.2796
    9.8244
    19.7591
    27.7279
    34.3067
    39.7982
    44.415
    48.3881
    51.8218
    ];

frames_pkt_A_op_kom = [
    9.78
    9.78
    9.77
    9.77
    9.78
    9.78
    9.78
    9.78
    9.78
    9.78
    9.8
    9.77
    9.78
    9.79
    9.78
    9.8
    
    ];
frames_pkt_B_op_kom = [
    1.01
    1.35
    2.13
    3.48
    5.73
    9.77
    18.56
    50.04
    63.99
    64
    64
    64
    64
    64
    64
    64
    
    
    ];
frames_pkt_A_am_kom = [
    5.33
    8.99
    10.7
    12.14
    13.87
    16.18
    19.46
    24.48
    32.14
    36.51
    37.44
    37.54
    37.62
    37.68
    37.59
    37.71
    
    
    ];
frames_pkt_B_am_kom = [
    1.03
    2.27
    4.43
    7.31
    11.1
    16.21
    23.39
    34.31
    50.99
    61
    63.08
    63.68
    63.91
    63.98
    64
    64
    
    
    ];
frames_pkt_A_pu_kom = [
    6.84
    8.63
    9.53
    9.9
    10.06
    10.17
    10.25
    10.31
    10.35
    10.36
    10.38
    10.36
    10.36
    10.39
    10.37
    10.39
    
    
    ];
frames_pkt_B_pu_kom = [
    1.02
    1.51
    2.34
    3.74
    6.08
    10.14
    18.63
    45.5
    63.13
    63.78
    63.92
    63.97
    63.99
    64
    64
    64
    
    
    ];

twait_A_op_kom = [
    0.1104
    0.1104
    0.1105
    0.1105
    0.1105
    0.1105
    0.1106
    0.1105
    0.1105
    0.1104
    0.1106
    0.1105
    0.1105
    0.1105
    0.1105
    0.1105
    ];

twait_B_op_kom = [
    0.1118
    0.1104
    0.1102
    0.1104
    0.1105
    0.1105
    0.1105
    0.1105
    0.1106
    0.1106
    0.1103
    0.1105
    0.1105
    0.1106
    0.1105
    0.1104
    ];

twait_A_am_kom = [
    0.1354
    0.5233
    0.7048
    0.8569
    1.0389
    1.2834
    1.6293
    2.16
    2.9697
    3.4329
    3.5317
    3.5479
    3.5558
    3.5608
    3.553
    3.5625
    ];

twait_B_am_kom = [
    0.4369
    0.8425
    1.003
    1.0919
    1.1788
    1.2869
    1.437
    1.6672
    2.0036
    2.1856
    2.2206
    2.2249
    2.2309
    2.2253
    2.2301
    2.2307
    ];

twait_A_pu_kom = [
    0.1171
    0.1662
    0.1718
    0.1702
    0.1668
    0.1633
    0.1591
    0.154
    0.1538
    0.155
    0.1552
    0.1553
    0.1548
    0.1562
    0.156
    0.1555
    ];

twait_B_pu_kom = [
    0.2552
    0.2321
    0.1841
    0.1675
    0.1631
    0.1627
    0.1658
    0.1752
    0.1801
    0.1818
    0.182
    0.1812
    0.1812
    0.1856
    0.1841
    0.1841
    ];

% figure
% 
% subplot(1,5,1)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_A_op_kom ,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_A_am_kom ,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_A_pu_kom ,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_B_op_kom ,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_B_am_kom ,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6 , twait_B_pu_kom,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% %ylabel(['\rho_A [n.d] (l_a = ' num2str(load_A/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)']);
% ylabel('Av. access delay [ms]');
% grid on
% xlim([0 230.4])
% 
% subplot(1,5,2)
% hold on
% 
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_am* 1E-6,'r^--','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',5);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_pu* 1E-6,'rp:','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',6);
% 
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_op_kom * L_fpkt * 1E-6,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_am_kom * L_fpkt * 1E-6,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_pu_kom * L_fpkt * 1E-6,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_op_kom * L_fpkt * 1E-6,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_am_kom * L_fpkt * 1E-6,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_pu_kom * L_fpkt * 1E-6,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% 
% 
% 
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% ylabel('Av. throughput [Mbps]');
% grid on
% xlim([0 230.4])
% 
% subplot(1,5,3)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_A_am_kom,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_A_pu_kom,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_B_op_kom,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_B_am_kom,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_B_pu_kom,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% ylabel('Av. delay [ms]');
% grid on
% xlim([0 230.4])
% 
% subplot(1,5,4)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_A_am_kom,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_A_pu_kom,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_B_op_kom,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_B_am_kom,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_B_pu_kom,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% ylabel('Drop ratio [%]');
% grid on
% xlim([0 230.4])
% 
% subplot(1,5,5)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_A_am_kom,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_A_pu_kom,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_B_op_kom,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_B_am_kom,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_B_pu_kom,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% ylabel('Av. no. of frames per packet');
% grid on
% xlim([0 230.4])
% 
% legend('A_{OP}','A_{AM}','A_{PU}', 'B_{OP}', 'B_{AM}', 'B_{PU}');



% figure
% lim_x = 200;
% subplot(1,6,1)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_A_op,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_A_am,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_A_pu,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_B_op,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_B_am,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_B_pu,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [pkt/s]','interpreter','latex');
% ylabel(['\rho_A [n.d] (l_a = ' num2str(load_A/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)']);
% ylabel('$\rho$','interpreter','latex');
% grid on
% xlim([0 lim_x])
% 
% subplot(1,6,2)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_A_op_kom ,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_A_am_kom ,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_A_pu_kom ,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_B_op_kom ,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED) * L_fpkt * 1E-6, twait_B_am_kom ,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6 , twait_B_pu_kom,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% %ylabel(['\rho_A [n.d] (l_a = ' num2str(load_A/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)']);
% ylabel('Av. access delay [ms]');
% grid on
% xlim([0 lim_x])
% 
% subplot(1,6,3)
% hold on
% 
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_am* 1E-6,'r^--','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',5);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_pu* 1E-6,'rp:','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','r', 'Markersize',6);
% 
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_op_kom * L_fpkt * 1E-6,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_am_kom * L_fpkt * 1E-6,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_pu_kom * L_fpkt * 1E-6,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_op_kom * L_fpkt * 1E-6,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_am_kom * L_fpkt * 1E-6,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_pu_kom * L_fpkt * 1E-6,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% 
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% ylabel('Av. throughput [Mbps]');
% grid on
% xlim([0 lim_x])
% 
% subplot(1,6,4)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_A_am_kom,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_A_pu_kom,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_B_op_kom,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_B_am_kom,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, d_B_pu_kom,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% ylabel('Av. delay [ms]');
% grid on
% xlim([0 lim_x])
% 
% subplot(1,6,5)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_A_am_kom,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_A_pu_kom,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_B_op_kom,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_B_am_kom,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, drop_ratio_B_pu_kom,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% ylabel('Drop ratio [%]');
% grid on
% xlim([0 lim_x])
% 
% subplot(1,6,6)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_A_am_kom,'b^--','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_A_pu_kom,'bp:','LineWidth', 1,'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_B_op_kom,'mo-','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_B_am_kom,'m^--','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, frames_pkt_B_pu_kom,'mp:','LineWidth', 1,...
%     'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
% xlabel('$\ell_B$ [Mbps]','interpreter','latex');
% ylabel('Av. no. of frames per packet');
% grid on
% xlim([0 lim_x])
% 
% legend('A_{OP}','A_{AM}','A_{PU}', 'B_{OP}', 'B_{AM}', 'B_{PU}');

figure
lim_x = 200;
hold on
plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_A_op,'bo-','LineWidth', 1, 'Markersize',7);
plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_A_am,'b^--','LineWidth', 1, 'Markersize',7);
plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_A_pu,'bp:','LineWidth', 1,'Markersize',7);
plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_B_op,'mo-','LineWidth', 1,...
    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_B_am,'m^--','LineWidth', 1,...
    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',7);
plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, rho_B_pu,'mp:','LineWidth', 1,...
    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',8);
xlabel('$\ell_B$ [Mbps]','interpreter','latex');
ylabel(['\rho_A [n.d] (l_a = ' num2str(load_A/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' pkt/s)']);
ylabel('$\rho$','interpreter','latex');
grid on
xlim([0 lim_x])
legend('A_{OP}','A_{AM}','A_{PU}', 'B_{OP}', 'B_{AM}', 'B_{PU}');


%% NO AGGREGATION: 1 packet of 12,000 bits per frame

% s_A_op_kom = [99.98
% 99.97
% 99.94
% 99.94
% 99.97
% 99.99
% 99.99
% 99.98
% 99.98
% 99.97
% 100.03
% 99.95
% 99.98
% 100.03
% 99.97
% 100.04
% ];
%
% s_A_am_kom = [
%    99.98
% 99.97
% 99.94
% 99.94
% 99.97
% 99.99
% 99.99
% 99.98
% 99.97
% 99.94
% 99.95
% 99.85
% 99.85
% 99.89
% 99.85
% 99.9
% ];
%
% s_A_op_noagg_kom = [24.4728125
%     24.471875
%     24.47109375
%     24.47109375
%     24.47109375
%     24.47109375
%     24.4734375
%     24.47109375
%     24.47109375
%     24.47359375
%     24.47109375
%     24.47109375
%     24.47109375
%     24.4709375
%     24.47359375
%     24.47109375];
%
% s_A_am_noagg_kom = [
%
% 25.63921875
% 14.9659375
% 14.97453125
% 14.964375
% 14.969375
% 14.96859375
% 14.9690625
% 14.9746875
% 14.95984375
% 14.96984375
% 14.9821875
% 14.980625
% 14.9784375
% 14.96375
% 14.97546875
% 14.981875
% ];
%
% s_B_op_kom = [1
% 19.99
% 40.01
% 59.99
% 79.95
% 99.94
% 119.94
% 139.42
% 142.4
% 142.4
% 142.4
% 142.4
% 142.4
% 142.4
% 142.4
% 142.4
%
% ];
%
% s_B_am_kom = [1
% 19.99
% 40.01
% 59.99
% 79.95
% 99.94
% 119.94
% 139.94
% 159
% 167.26
% 168.83
% 169.43
% 169.52
% 169.78
% 169.66
% 169.64
%
% ];
%
% s_B_op_noagg_kom = [
%     1.00265625
% 19.9896875
% 24.4734375
% 24.47359375
% 24.47359375
% 24.47359375
% 24.47109375
% 24.4734375
% 24.47359375
% 24.47109375
% 24.4734375
% 24.47359375
% 24.47359375
% 24.47359375
% 24.47109375
% 24.4734375
% ];
%
% s_B_am_noagg_kom = [
%   1.00265625
% 14.97421875
% 14.9653125
% 14.975625
% 14.97078125
% 14.97140625
% 14.9709375
% 14.9653125
% 14.9803125
% 14.97015625
% 14.9578125
% 14.959375
% 14.9615625
% 14.97625
% 14.9646875
% 14.958125
%
% ];
%
%
% drop_ratio_A_op_noagg_kom = [75.5192
% 75.5195
% 75.512
% 75.5114
% 75.5186
% 75.5239
% 75.5222
% 75.5215
% 75.5208
% 75.5177
% 75.534
% 75.5151
% 75.5207
% 75.5334
% 75.5178
% 75.537];
%
% drop_ratio_A_am_noagg_kom = [
%     74.3526
% 85.0278
% 85.0142
% 85.024
% 85.0235
% 85.0274
% 85.0274
% 85.0198
% 85.0344
% 85.0239
% 85.02
% 85.01
% 85.0157
% 85.038
% 85.0184
% 85.0222
%
% ];
%
% drop_ratio_B_op_noagg_kom = [0
% 0
% 38.8308
% 59.1969
% 69.3873
% 75.5097
% 79.5953
% 82.5107
% 84.7001
% 86.4029
% 87.7572
% 88.8745
% 89.8017
% 90.585
% 91.26
% 91.8387
%
%     ];
%
% drop_ratio_B_am_noagg_kom = [0
% 25.079
% 62.5932
% 75.0305
% 81.2728
% 85.0174
% 87.516
% 89.3048
% 90.6344
% 91.6815
% 92.517
% 93.1992
% 93.765
% 94.2383
% 94.655
% 95.0115
%
%     ];
%
% d_A_op_noagg_kom =[95.6
% 95.61
% 95.61
% 95.61
% 95.61
% 95.61
% 95.6
% 95.61
% 95.61
% 95.6
% 95.61
% 95.61
% 95.61
% 95.61
% 95.6
% 95.61
%
%     ];
%
% d_A_am_noagg_kom=[
%     91.25
% 156.43
% 156.34
% 156.45
% 156.4
% 156.41
% 156.4
% 156.34
% 156.5
% 156.39
% 156.26
% 156.28
% 156.3
% 156.46
% 156.33
% 156.27
%
%     ];
%
% d_B_op_noagg_kom =[0.65
% 2.07
% 95.16
% 95.46
% 95.56
% 95.6
% 95.64
% 95.65
% 95.66
% 95.68
% 95.68
% 95.69
% 95.7
% 95.7
% 95.72
% 95.71
%
%     ];
%
% d_B_am_noagg_kom=[0.83
% 154.51
% 156.13
% 156.21
% 156.34
% 156.37
% 156.41
% 156.49
% 156.34
% 156.46
% 156.6
% 156.59
% 156.57
% 156.43
% 156.55
% 156.62
%
%     ];
%
%
% figure
% % THROUGHPUT
% subplot(3,2,1)
% title('WLAN A ($\ell_A =$ 1 Fpkt/s = 6400 frames/s)','interpreter','latex')
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_A_am_kom,'r^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_A_op_noagg_kom,'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_A_am_noagg_kom,'r^--','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','k', 'Markersize',7);
% xlabel('$\ell_B$ [Fpkt/s]','interpreter','latex');
% ylabel('$\Gamma_A$ [Fpkt/s]','interpreter','latex');
% grid on
% xlim([0 300])
%
% subplot(3,2,2)
% title('WLAN B ($\ell_A =$ 1 Fpkt/s = 6400 frames/s)','interpreter','latex')
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_B_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_B_am_kom,'r^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_B_op_noagg_kom, 'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), s_B_am_noagg_kom,'r^--','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','k', 'Markersize',7);
% xlabel('$\ell_B$ [Fpkt/s]','interpreter','latex');
% ylabel('$\Gamma_B$ [Fpkt/s]','interpreter','latex');
% grid on
% xlim([0 300])
%
% % DROP RATIO
% subplot(3,2,3)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), drop_ratio_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), drop_ratio_A_am_kom,'r^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), drop_ratio_A_op_noagg_kom,'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), drop_ratio_A_am_noagg_kom,'r^--','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','k', 'Markersize',7);
% xlabel('$\ell_B$ [Fpkt/s]','interpreter','latex');
% ylabel('drop ratio [%]','interpreter','latex');
% grid on
% xlim([0 300])
%
% subplot(3,2,4)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), drop_ratio_B_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), drop_ratio_B_am_kom,'r^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), drop_ratio_B_op_noagg_kom, 'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), drop_ratio_B_am_noagg_kom,'r^--','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','k', 'Markersize',7);
% xlabel('$\ell_B$ [Fpkt/s]','interpreter','latex');
% ylabel('drop ratio [%]','interpreter','latex');
% grid on
% xlim([0 300])
%
% % DELAY
% subplot(3,2,5)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_A_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_A_am_kom,'r^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_A_op_noagg_kom,'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_A_am_noagg_kom,'r^--','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','k', 'Markersize',7);
% xlabel('$\ell_B$ [Fpkt/s]','interpreter','latex');
% ylabel('$d$ [ms]','interpreter','latex');
% grid on
% xlim([0 300])
%
% subplot(3,2,6)
% hold on
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_B_op_kom,'bo-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_B_am_kom,'r^-','LineWidth', 1, 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_B_op_noagg_kom, 'bo--','LineWidth', 1,...
%     'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',7);
% plot(load_B./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED), d_B_am_noagg_kom,'r^--','LineWidth', 1,...
%     'MarkerFaceColor','r','MarkerEdgeColor','k', 'Markersize',7);
% xlabel('$\ell_B$ [Fpkt/s]','interpreter','latex');
% ylabel('$d$ [ms]','interpreter','latex');
% grid on
% xlim([0 300])
% legend('OP - N_a = 64','AM - N_a = 64','OP - N_a = 1', 'AM - N_a = 1');
