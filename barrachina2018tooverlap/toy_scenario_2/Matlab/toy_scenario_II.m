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
EB_C = EB_A;                        % Expected BO value [s] for C
lambda_A = 1/EB_A;      % Attempt rate when packet ready for transmission [1/s]
lambda_B = 1/EB_B;      % Attempt rate when packet ready for transmission [1/s]
lambda_C = lambda_A;    % Attempt rate when packet ready for transmission [1/s]
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
mu(4) = 1 / T_succ(4);

load_AandC_packets = 0:50:1000;
load_AandC = load_AandC_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;

delta_rho = 0.00001;                     % Delta value for rho
MaxIter = 1000000;                        % Max. num. iterations for finding rho


%% Toy scenario 2 (AM) - Overlapping
% AM: just one transition possible from empty state
alfa_A = 1;
alfa_B = 1;
alfa_C = 1;
% Activity ratios
theta_A14 = alfa_A * lambda_A / mu(4);
theta_B14 = alfa_B * lambda_B / mu(4);
theta_C14 = alfa_C * lambda_C / mu(4);

% 100

% Load of B is fixed. Loads of A and C are the same and vary.
load_B_packets = 100;   % Note that all packets assume NUM_PACKETS_AGGREGATED frames aggregated
load_B = load_B_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;  % Traffic load of WLAN A [bps]
disp(['Fixed traffic load in B: ' num2str(load_B/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' packets/s'])
disp(['- ' num2str(load_B * 1E-6) ' Mbps'])

disp('Computing Toy Scenario 2 - Overlapping... ')
for load_AandC_ix = 1 : length(load_AandC)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B/R(1));                 % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    rho_C = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for C
    
    % Iterate until rho converges, i.e., rho | S_A = load_A, S_B = load_B, S_C = load_C
    for iter = 1 : MaxIter
                
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + rho_A * theta_A14 + rho_B * theta_B14 + rho_C * theta_C14 + (rho_A * theta_A14 * rho_C * theta_C14));
        pi_A14 = pi_empty * rho_A * theta_A14;
        pi_B14 = pi_empty * rho_B * theta_B14;
        pi_C14 = pi_empty * rho_C * theta_C14;
        pi_A14_C14 = pi_empty * rho_A * theta_A14 * rho_C * theta_C14;
        
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A14) ' ' num2str(pi_B14) ...
                ' ' num2str(pi_C14) ' ' num2str(pi_B14) ' ' num2str(pi_A14_C14)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A14 + pi_B14 + pi_C14 + pi_B14 + pi_A14_C14)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(4) * (pi_A14 + pi_A14_C14));
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(4) * pi_B14);
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        s_C = NUM_PACKETS_AGGREGATED * PACKET_LENGTH *  (mu(4) * (pi_C14 + pi_A14_C14));
        SiterC(iter) = s_C;
        RhoiterC(iter) = rho_C;
        
        % Update rhos
        if(s_A<load_AandC(load_AandC_ix))
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B)
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
        if(s_C < load_AandC(load_AandC_ix))
            rho_C = min(1-1E-9, rho_C + delta_rho);
        else
            rho_C = max(1E-9, rho_C - delta_rho);
        end
        
    end
     
    s_A_ov_lb_100(load_AandC_ix) = s_A;
    s_B_ov_lb_100(load_AandC_ix) = s_B;
    s_C_ov_lb_100(load_AandC_ix) = s_C;
    rho_A_ov_lb_100(load_AandC_ix) = rho_A;
    rho_B_ov_lb_100(load_AandC_ix) = rho_B;
    rho_C_ov_lb_100(load_AandC_ix) = rho_C;
end
disp(['     * pi = ' num2str(pi_empty*100) ' ' num2str(pi_A14*100) ' ' num2str(pi_B14*100) ...
    ' ' num2str(pi_C14*100) ' ' num2str(pi_A14_C14*100)])
checksum = pi_empty + pi_A14 + pi_B14 + pi_C14 + pi_A14_C14;
disp(['     * checksum (must be 1!): ' num2str(checksum)]);
if abs(checksum - 1) > 0.0001
    warning('The sum of probabilities is not 1!')
end

% 250

% Load of B is fixed. Loads of A and C are the same and vary.
load_B_packets = 250;   % Note that all packets assume NUM_PACKETS_AGGREGATED frames aggregated
load_B = load_B_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;  % Traffic load of WLAN A [bps]
disp(['Fixed traffic load in B: ' num2str(load_B/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' packets/s'])
disp(['- ' num2str(load_B * 1E-6) ' Mbps'])

disp('Computing Toy Scenario 2 - Overlapping... ')
for load_AandC_ix = 1 : length(load_AandC)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B/R(1));                 % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    rho_C = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for C
    
    % Iterate until rho converges, i.e., rho | S_A = load_A, S_B = load_B, S_C = load_C
    for iter = 1 : MaxIter
        
        if flag_verbose
            disp(['   + iter: ' num2str(iter)])
            disp(['     * rho_A: ' num2str(rho_A) ', rho_B: ' num2str(rho_B) ', rho_C: ' num2str(rho_C)])
        end
        
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + rho_A * theta_A14 + rho_B * theta_B14 + rho_C * theta_C14 + (rho_A * theta_A14 * rho_C * theta_C14));
        pi_A14 = pi_empty * rho_A * theta_A14;
        pi_B14 = pi_empty * rho_B * theta_B14;
        pi_C14 = pi_empty * rho_C * theta_C14;
        pi_A14_C14 = pi_empty * rho_A * theta_A14 * rho_C * theta_C14;
        
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A14) ' ' num2str(pi_B14) ...
                ' ' num2str(pi_C14) ' ' num2str(pi_B14) ' ' num2str(pi_A14_C14)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A14 + pi_B14 + pi_C14 + pi_B14 + pi_A14_C14)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(4) * (pi_A14 + pi_A14_C14));
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(4) * pi_B14);
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        s_C = NUM_PACKETS_AGGREGATED * PACKET_LENGTH *  (mu(4) * (pi_C14 + pi_A14_C14));
        SiterC(iter) = s_C;
        RhoiterC(iter) = rho_C;
        
        % Update rhos
        if(s_A<load_AandC(load_AandC_ix))
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B)
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
        if(s_C < load_AandC(load_AandC_ix))
            rho_C = min(1-1E-9, rho_C + delta_rho);
        else
            rho_C = max(1E-9, rho_C - delta_rho);
        end
        
    end
    
    s_A_ov_lb_250(load_AandC_ix) = s_A;
    s_B_ov_lb_250(load_AandC_ix) = s_B;
    s_C_ov_lb_250(load_AandC_ix) = s_C;
    rho_A_ov_lb_250(load_AandC_ix) = rho_A;
    rho_B_ov_lb_250(load_AandC_ix) = rho_B;
    rho_C_ov_lb_250(load_AandC_ix) = rho_C;
end
disp(['     * pi = ' num2str(pi_empty*100) ' ' num2str(pi_A14*100) ' ' num2str(pi_B14*100) ...
    ' ' num2str(pi_C14*100) ' ' num2str(pi_A14_C14*100)])
checksum = pi_empty + pi_A14 + pi_B14 + pi_C14 + pi_A14_C14;
disp(['     * checksum (must be 1!): ' num2str(checksum)]);
if abs(checksum - 1) > 0.0001
    warning('The sum of probabilities is not 1!')
end

% 400

% Load of B is fixed. Loads of A and C are the same and vary.
load_B_packets = 400;   % Note that all packets assume NUM_PACKETS_AGGREGATED frames aggregated
load_B = load_B_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;  % Traffic load of WLAN A [bps]
disp(['Fixed traffic load in B: ' num2str(load_B/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' packets/s'])
disp(['- ' num2str(load_B * 1E-6) ' Mbps'])

disp('Computing Toy Scenario 2 - Overlapping... ')
for load_AandC_ix = 1 : length(load_AandC)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B/R(1));                 % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    rho_C = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for C
    
    % Iterate until rho converges, i.e., rho | S_A = load_A, S_B = load_B, S_C = load_C
    for iter = 1 : MaxIter
        
        if flag_verbose
            disp(['   + iter: ' num2str(iter)])
            disp(['     * rho_A: ' num2str(rho_A) ', rho_B: ' num2str(rho_B) ', rho_C: ' num2str(rho_C)])
        end
        
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + rho_A * theta_A14 + rho_B * theta_B14 + rho_C * theta_C14 + (rho_A * theta_A14 * rho_C * theta_C14));
        pi_A14 = pi_empty * rho_A * theta_A14;
        pi_B14 = pi_empty * rho_B * theta_B14;
        pi_C14 = pi_empty * rho_C * theta_C14;
        pi_A14_C14 = pi_empty * rho_A * theta_A14 * rho_C * theta_C14;
        
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A14) ' ' num2str(pi_B14) ...
                ' ' num2str(pi_C14) ' ' num2str(pi_B14) ' ' num2str(pi_A14_C14)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A14 + pi_B14 + pi_C14 + pi_B14 + pi_A14_C14)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(4) * (pi_A14 + pi_A14_C14));
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(4) * pi_B14);
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        s_C = NUM_PACKETS_AGGREGATED * PACKET_LENGTH *  (mu(4) * (pi_C14 + pi_A14_C14));
        SiterC(iter) = s_C;
        RhoiterC(iter) = rho_C;
        
        % Update rhos
        if(s_A<load_AandC(load_AandC_ix))
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B)
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
        if(s_C < load_AandC(load_AandC_ix))
            rho_C = min(1-1E-9, rho_C + delta_rho);
        else
            rho_C = max(1E-9, rho_C - delta_rho);
        end
        
    end
    
    disp(['  load_A = ' num2str(load_AandC(load_AandC_ix))])
    disp(['     * pi = ' num2str(pi_empty*100) ' ' num2str(pi_A14*100) ' ' num2str(pi_B14*100) ...
    ' ' num2str(pi_C14*100) ' ' num2str(pi_A14_C14*100)])
    checksum = pi_empty + pi_A14 + pi_B14 + pi_C14 + pi_A14_C14;
    disp(['     * checksum (must be 1!): ' num2str(checksum)]);
    if abs(checksum - 1) > 0.0001
        warning('The sum of probabilities is not 1!')
    end
    
    s_A_ov_lb_400(load_AandC_ix) = s_A;
    s_B_ov_lb_400(load_AandC_ix) = s_B;
    s_C_ov_lb_400(load_AandC_ix) = s_C;
    rho_A_ov_lb_400(load_AandC_ix) = rho_A;
    rho_B_ov_lb_400(load_AandC_ix) = rho_B;
    rho_C_ov_lb_400(load_AandC_ix) = rho_C;
end
disp(['     * pi = ' num2str(pi_empty*100) ' ' num2str(pi_A14*100) ' ' num2str(pi_B14*100) ...
    ' ' num2str(pi_C14*100) ' ' num2str(pi_A14_C14*100)])
checksum = pi_empty + pi_A14 + pi_B14 + pi_C14 + pi_A14_C14;
disp(['     * checksum (must be 1!): ' num2str(checksum)]);
if abs(checksum - 1) > 0.0001
    warning('The sum of probabilities is not 1!')
end

%% Toy scenario 2 (AM) - No overlapping
% AM: just one transition possible from empty state
alfa_A = 1;
alfa_B = 1;
alfa_C = 1;
% Activity ratios
theta_A12 = alfa_A * lambda_A / mu(2);
theta_B34 = alfa_B * lambda_B / mu(2);
theta_C12 = alfa_C * lambda_C / mu(2);

% 100

% Load of B is fixed. Loads of A and C are the same and vary.
load_B_packets = 100;   % Note that all packets assume NUM_PACKETS_AGGREGATED frames aggregated
load_B = load_B_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;  % Traffic load of WLAN A [bps]
disp(['Fixed traffic load in B: ' num2str(load_B/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' packets/s'])
disp(['- ' num2str(load_B * 1E-6) ' Mbps'])

disp('Computing Toy Scenario 2 - Overlapping... ')
for load_AandC_ix = 1 : length(load_AandC)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B/R(1));                 % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    rho_C = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for C
    
    % Iterate until rho converges, i.e., rho | S_A = load_A, S_B = load_B, S_C = load_C
    for iter = 1 : MaxIter
        
        if flag_verbose
            disp(['   + iter: ' num2str(iter)])
            disp(['     * rho_A: ' num2str(rho_A) ', rho_B: ' num2str(rho_B) ', rho_C: ' num2str(rho_C)])
        end
        
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + (rho_A * theta_A12) + (rho_B * theta_B34) + (rho_C * theta_C12) +...
            (rho_A * theta_A12 *  rho_B * theta_B34) + (rho_A * theta_A12 * rho_C * theta_C12) + (rho_B * theta_B34 * rho_C * theta_C12) + ...
            (rho_A * theta_A12 *  rho_B * theta_B34 * rho_C * theta_C12));
        pi_A12 = pi_empty * rho_A * theta_A12;
        pi_B34 = pi_empty * rho_B * theta_B34;
        pi_C12 = pi_empty * rho_C * theta_C12;
        pi_A12_B34 = pi_empty * rho_A * theta_A12 *  rho_B * theta_B34;
        pi_A12_C12 = pi_empty * rho_A * theta_A12 * rho_C * theta_C12;
        pi_B34_C12 = pi_empty * rho_B * theta_B34 * rho_C * theta_C12;
        pi_A12_B34_C12 = pi_empty * rho_A * theta_A12 *  rho_B * theta_B34 * rho_C * theta_C12;
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A12) ' ' num2str(pi_B34) ...
                ' ' num2str(pi_C12) ' ' num2str(pi_A12_B34) ' ' num2str(pi_A12_C12) ' ' num2str(pi_B34_C12) ' ' num2str(pi_A12_B34_C12)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A12 + pi_B34 + pi_C12 + pi_A12_B34 + pi_A12_C12 + pi_B34_C12 + pi_A12_B34_C12)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(2) * (pi_A12 + pi_A12_B34 + pi_A12_C12 + pi_A12_B34_C12));
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(2) * (pi_B34 + pi_A12_B34 + pi_B34_C12 + pi_A12_B34_C12));
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        s_C = NUM_PACKETS_AGGREGATED * PACKET_LENGTH *  (mu(2) * (pi_C12 + pi_A12_C12 + pi_B34_C12 + pi_A12_B34_C12));
        SiterC(iter) = s_C;
        RhoiterC(iter) = rho_C;
        
        % Update rhos
        if(s_A<load_AandC(load_AandC_ix))
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B)
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
        if(s_C < load_AandC(load_AandC_ix))
            rho_C = min(1-1E-9, rho_C + delta_rho);
        else
            rho_C = max(1E-9, rho_C - delta_rho);
        end
        
    end
    
    s_A_no_lb_100(load_AandC_ix) = s_A;
    s_B_no_lb_100(load_AandC_ix) = s_B;
    s_C_no_lb_100(load_AandC_ix) = s_C;
    rho_A_no_lb_100(load_AandC_ix) = rho_A;
    rho_B_no_lb_100(load_AandC_ix) = rho_B;
    rho_C_no_lb_100(load_AandC_ix) = rho_C;
end

% 250

% Load of B is fixed. Loads of A and C are the same and vary.
load_B_packets = 250;   % Note that all packets assume NUM_PACKETS_AGGREGATED frames aggregated
load_B = load_B_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;  % Traffic load of WLAN A [bps]
disp(['Fixed traffic load in B: ' num2str(load_B/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' packets/s'])
disp(['- ' num2str(load_B * 1E-6) ' Mbps'])

disp('Computing Toy Scenario 2 - Overlapping... ')
for load_AandC_ix = 1 : length(load_AandC)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B/R(1));                 % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    rho_C = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for C
    
    % Iterate until rho converges, i.e., rho | S_A = load_A, S_B = load_B, S_C = load_C
    for iter = 1 : MaxIter
        
        if flag_verbose
            disp(['   + iter: ' num2str(iter)])
            disp(['     * rho_A: ' num2str(rho_A) ', rho_B: ' num2str(rho_B) ', rho_C: ' num2str(rho_C)])
        end
        
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + (rho_A * theta_A12) + (rho_B * theta_B34) + (rho_C * theta_C12) +...
            (rho_A * theta_A12 *  rho_B * theta_B34) + (rho_A * theta_A12 * rho_C * theta_C12) + (rho_B * theta_B34 * rho_C * theta_C12) + ...
            (rho_A * theta_A12 *  rho_B * theta_B34 * rho_C * theta_C12));
        pi_A12 = pi_empty * rho_A * theta_A12;
        pi_B34 = pi_empty * rho_B * theta_B34;
        pi_C12 = pi_empty * rho_C * theta_C12;
        pi_A12_B34 = pi_empty * rho_A * theta_A12 *  rho_B * theta_B34;
        pi_A12_C12 = pi_empty * rho_A * theta_A12 * rho_C * theta_C12;
        pi_B34_C12 = pi_empty * rho_B * theta_B34 * rho_C * theta_C12;
        pi_A12_B34_C12 = pi_empty * rho_A * theta_A12 *  rho_B * theta_B34 * rho_C * theta_C12;
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A12) ' ' num2str(pi_B34) ...
                ' ' num2str(pi_C12) ' ' num2str(pi_A12_B34) ' ' num2str(pi_A12_C12) ' ' num2str(pi_B34_C12) ' ' num2str(pi_A12_B34_C12)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A12 + pi_B34 + pi_C12 + pi_A12_B34 + pi_A12_C12 + pi_B34_C12 + pi_A12_B34_C12)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(2) * (pi_A12 + pi_A12_B34 + pi_A12_C12 + pi_A12_B34_C12));
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(2) * (pi_B34 + pi_A12_B34 + pi_B34_C12 + pi_A12_B34_C12));
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        s_C = NUM_PACKETS_AGGREGATED * PACKET_LENGTH *  (mu(2) * (pi_C12 + pi_A12_C12 + pi_B34_C12 + pi_A12_B34_C12));
        SiterC(iter) = s_C;
        RhoiterC(iter) = rho_C;
        
        % Update rhos
        if(s_A<load_AandC(load_AandC_ix))
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B)
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
        if(s_C < load_AandC(load_AandC_ix))
            rho_C = min(1-1E-9, rho_C + delta_rho);
        else
            rho_C = max(1E-9, rho_C - delta_rho);
        end
        
    end
    
    s_A_no_lb_250(load_AandC_ix) = s_A;
    s_B_no_lb_250(load_AandC_ix) = s_B;
    s_C_no_lb_250(load_AandC_ix) = s_C;
    rho_A_no_lb_250(load_AandC_ix) = rho_A;
    rho_B_no_lb_250(load_AandC_ix) = rho_B;
    rho_C_no_lb_250(load_AandC_ix) = rho_C;
end

% 400

% Load of B is fixed. Loads of A and C are the same and vary.
load_B_packets = 400;   % Note that all packets assume NUM_PACKETS_AGGREGATED frames aggregated
load_B = load_B_packets * PACKET_LENGTH * NUM_PACKETS_AGGREGATED;  % Traffic load of WLAN A [bps]
disp(['Fixed traffic load in B: ' num2str(load_B/(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)) ' packets/s'])
disp(['- ' num2str(load_B * 1E-6) ' Mbps'])

disp('Computing Toy Scenario 2 - Overlapping... ')
for load_AandC_ix = 1 : length(load_AandC)
    
    % Iterative fixed-point method variables to find rho values
    rho_A = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for A
    rho_B = min(1,load_B/R(1));                 % Long-run stationary prob. of having packets ready for txs when the channel is free for B
    rho_C = min(1,load_AandC(load_AandC_ix)/R(1));  % Long-run stationary prob. of having packets ready for txs when the channel is free for C
    
    % Iterate until rho converges, i.e., rho | S_A = load_A, S_B = load_B, S_C = load_C
    for iter = 1 : MaxIter
        
        if flag_verbose
            disp(['   + iter: ' num2str(iter)])
            disp(['     * rho_A: ' num2str(rho_A) ', rho_B: ' num2str(rho_B) ', rho_C: ' num2str(rho_C)])
        end
        
        % Probability of being in each possible
        pi_empty = 1 / ( 1 + (rho_A * theta_A12) + (rho_B * theta_B34) + (rho_C * theta_C12) +...
            (rho_A * theta_A12 *  rho_B * theta_B34) + (rho_A * theta_A12 * rho_C * theta_C12) + (rho_B * theta_B34 * rho_C * theta_C12) + ...
            (rho_A * theta_A12 *  rho_B * theta_B34 * rho_C * theta_C12));
        pi_A12 = pi_empty * rho_A * theta_A12;
        pi_B34 = pi_empty * rho_B * theta_B34;
        pi_C12 = pi_empty * rho_C * theta_C12;
        pi_A12_B34 = pi_empty * rho_A * theta_A12 *  rho_B * theta_B34;
        pi_A12_C12 = pi_empty * rho_A * theta_A12 * rho_C * theta_C12;
        pi_B34_C12 = pi_empty * rho_B * theta_B34 * rho_C * theta_C12;
        pi_A12_B34_C12 = pi_empty * rho_A * theta_A12 *  rho_B * theta_B34 * rho_C * theta_C12;
        if flag_verbose
            disp(['     * pi = ' num2str(pi_empty) ' ' num2str(pi_A12) ' ' num2str(pi_B34) ...
                ' ' num2str(pi_C12) ' ' num2str(pi_A12_B34) ' ' num2str(pi_A12_C12) ' ' num2str(pi_B34_C12) ' ' num2str(pi_A12_B34_C12)])
            disp(['     * checksum (must be 1!): ' num2str(pi_empty + pi_A12 + pi_B34 + pi_C12 + pi_A12_B34 + pi_A12_C12 + pi_B34_C12 + pi_A12_B34_C12)]);
        end
        
        % Throughput depends on each of the states, not just on when the WLAN is active
        % Thus, we need the probability of being transmitted in each possible number of channels
        s_A = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(2) * (pi_A12 + pi_A12_B34 + pi_A12_C12 + pi_A12_B34_C12));
        SiterA(iter) = s_A;
        RhoiterA(iter) = rho_A;
        s_B = NUM_PACKETS_AGGREGATED * PACKET_LENGTH * (mu(2) * (pi_B34 + pi_A12_B34 + pi_B34_C12 + pi_A12_B34_C12));
        SiterB(iter) = s_B;
        RhoiterB(iter) = rho_B;
        s_C = NUM_PACKETS_AGGREGATED * PACKET_LENGTH *  (mu(2) * (pi_C12 + pi_A12_C12 + pi_B34_C12 + pi_A12_B34_C12));
        SiterC(iter) = s_C;
        RhoiterC(iter) = rho_C;
        
        % Update rhos
        if(s_A<load_AandC(load_AandC_ix))
            rho_A = min(1-1E-9, rho_A + delta_rho);
        else
            rho_A = max(1E-9, rho_A - delta_rho);
        end
        
        if(s_B < load_B)
            rho_B = min(1-1E-9, rho_B + delta_rho);
        else
            rho_B = max(1E-9, rho_B - delta_rho);
        end
        
        if(s_C < load_AandC(load_AandC_ix))
            rho_C = min(1-1E-9, rho_C + delta_rho);
        else
            rho_C = max(1E-9, rho_C - delta_rho);
        end
        
    end
    
    s_A_no_lb_400(load_AandC_ix) = s_A;
    s_B_no_lb_400(load_AandC_ix) = s_B;
    s_C_no_lb_400(load_AandC_ix) = s_C;
    rho_A_no_lb_400(load_AandC_ix) = rho_A;
    rho_B_no_lb_400(load_AandC_ix) = rho_B;
    rho_C_no_lb_400(load_AandC_ix) = rho_C;
end



%% KOMONDOR
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

%% PLOTS

marker_size = 5;
disp('--------------------------------------------------------')
disp('Fixed traffic loads:')
disp([' - load_A = ' num2str(load_AandC_packets) ' packets/s'])
disp([' - load_B = ' num2str(load_B_packets) ' packets/s'])

figure
subplot(1,3,1)
hold on
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_AandC_c1_loadB_100* L_fpkt * 1E-6,'bo','LineWidth', 1, 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_c1_loadB_100* L_fpkt * 1E-6,'m^','LineWidth', 1, 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_no_lb_100 *  1E-6,'b-','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_no_lb_100 * 1E-6,'m-','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_AandC_c2_loadB_100* L_fpkt * 1E-6,'bo','LineWidth', 1, 'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_c2_loadB_100* L_fpkt * 1E-6,'m^','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_ov_lb_100 *  1E-6,'b--','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_ov_lb_100 * 1E-6,'m--','LineWidth', 1);
grid on
xlabel('$\ell_A, \ell_C$ [Mbps]','interpreter','latex');
xlim([0 600])

subplot(1,3,2)
hold on
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_AandC_c1_loadB_250* L_fpkt * 1E-6,'bo','LineWidth', 1, 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_c1_loadB_250* L_fpkt * 1E-6,'m^','LineWidth', 1, 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_no_lb_250 *  1E-6,'b-','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_no_lb_250 * 1E-6,'m-','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_AandC_c2_loadB_250* L_fpkt * 1E-6,'bo','LineWidth', 1,    'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_c2_loadB_250* L_fpkt * 1E-6,'m^','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_ov_lb_250 *  1E-6,'b--','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_ov_lb_250 * 1E-6,'m--','LineWidth', 1);
grid on
xlabel('$\ell_A, \ell_C$ [Mbps]','interpreter','latex');
xlim([0 600])

subplot(1,3,3)
hold on
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_AandC_c1_loadB_400* L_fpkt * 1E-6,'bo','LineWidth', 1, 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_c1_loadB_400* L_fpkt * 1E-6,'m^','LineWidth', 1, 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_no_lb_400 *  1E-6,'b-','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_no_lb_400 * 1E-6,'m-','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_AandC_c2_loadB_400* L_fpkt * 1E-6,'bo','LineWidth', 1,    'MarkerFaceColor','b','MarkerEdgeColor','k', 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_c2_loadB_400* L_fpkt * 1E-6,'m^','LineWidth', 1,    'MarkerFaceColor','m','MarkerEdgeColor','k', 'Markersize',marker_size);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_A_ov_lb_400 *  1E-6,'b--','LineWidth', 1);
plot(load_AandC./(PACKET_LENGTH * NUM_PACKETS_AGGREGATED)* L_fpkt * 1E-6, s_B_ov_lb_400 * 1E-6,'m--','LineWidth', 1);
grid on
ylabel('Throughput [Mbps]')
xlabel('$\ell_A, \ell_C$ [Mbps]','interpreter','latex');
xlim([0 600])
legend('A_{Kom,no}','B_{Kom,no}', 'A_{SF,no}','B_{SF,no}','A_{Kom,ov}','B_{Kom,ov}', 'A_{SF,ov}','B_{SF,ov}');

%% 6 WLANs scenario

id_wlan = ['A','B','C','D','E','F'];
s_wlan_sfctmn = [135.06
    135.06
    265.42
    0.42
    265.42
    339.47
    ];

s_wlan_kom = [142.74
    142.74
    242.78
    6.2
    243
    291];

figure
bar([s_wlan_sfctmn s_wlan_kom]);
ylabel('WLAN throughput [Mbps]')


grid on

