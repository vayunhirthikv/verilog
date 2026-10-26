
%% =========================== CSMA/CD ===========================
clc;
clear;
close all;

%% INPUT
devices = input('Enter number of devices: ');
attempts = input('Enter number of transmission attempts: ');
base_energy = input('Enter energy used by transmitting device: ');

% Validate inputs
if devices < 1 || devices ~= floor(devices)
    error('Number of devices must be a positive integer.');
end

if attempts < 1 || attempts ~= floor(attempts)
    error('Number of attempts must be a positive integer.');
end

if ~isfinite(base_energy) || base_energy <= 0
    error('Base energy must be a positive number.');
end

fprintf('\n===== CSMA/CD ENERGY-BASED COLLISION DETECTION =====\n');

%% SINGLE SIMULATION
collision_probability = input( ...
    'Enter collision probability (0 to 1): ');

if ~isfinite(collision_probability) || ...
        collision_probability < 0 || collision_probability > 1
    error('Collision probability must be between 0 and 1.');
end

throughput = simulate_network( ...
    devices, attempts, base_energy, collision_probability);

%% THROUGHPUT PERFORMANCE GRAPH
fprintf('\n===== GENERATING THROUGHPUT GRAPH =====\n');

% Offered traffic load values
G_vec = logspace(-2, 2, 40);

% Simulation parameters
num_slots = 10000;
packet_slots = 20;
prop_delay_slots = 1;
a = prop_delay_slots / packet_slots;

% Energy detection parameters
E_tx = base_energy;
noise_std = 0.05 * E_tx;
threshold = E_tx + 0.3 * E_tx;

% Simulated throughput
throughput_sim = zeros(size(G_vec));

for idx = 1:length(G_vec)

    G = G_vec(idx);
    arrival_rate = G / packet_slots;

    successful_packet_slots = 0;
    slot = 1;

    while slot <= num_slots - packet_slots

        % Generate Poisson random number without a toolbox
        transmitting_nodes = poisson_random(arrival_rate);

        if transmitting_nodes == 0

            % Idle channel
            slot = slot + 1;

        elseif transmitting_nodes == 1

            % Single transmitter: measure medium energy
            E_media = E_tx + noise_std * randn();

            if E_media > threshold

                % False collision due to noise
                slot = slot + 2 * prop_delay_slots;

            else

                % Successful transmission
                successful_packet_slots = ...
                    successful_packet_slots + packet_slots;

                slot = slot + packet_slots;

            end

        else

            % Multiple transmitters: collision
            E_media = transmitting_nodes * E_tx ...
                      + noise_std * randn();

            if E_media > threshold

                % Collision detected; abort early
                slot = slot + 2 * prop_delay_slots;

            else

                % Undetected collision
                slot = slot + packet_slots;

            end

        end
    end

    % Normalized throughput
    throughput_sim(idx) = ...
        successful_packet_slots / num_slots;

end

%% THEORETICAL THROUGHPUT
G_theory = logspace(-2, 2, 200);

S_theory = (G_theory .* exp(-a .* G_theory)) ./ ...
    (G_theory .* (1 + 2 * a) + exp(-a .* G_theory));

%% PLOT BOTH CURVES
figure('Color', [1 1 1], ...
       'Name', 'CSMA/CD Throughput Performance');

% Theoretical throughput
semilogx(G_theory, S_theory, ...
    'LineWidth', 2, ...
    'Color', [0.85 0.325 0.098]);

hold on;

% Energy-detection simulation
semilogx(G_vec, throughput_sim, 'o--', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 6, ...
    'Color', [0 0.447 0.741], ...
    'MarkerFaceColor', [0 0.447 0.741]);

grid on;

title(sprintf( ...
    'Throughput Performance of CSMA/CD with Energy Detection (a = %.2f)', a), ...
    'FontSize', 12, ...
    'FontWeight', 'bold');

xlabel('Offered Traffic Load (G) [attempts / packet time]', ...
    'FontSize', 11);

ylabel('Normalized Throughput (S)', ...
    'FontSize', 11);

legend('Theoretical Throughput', ...
       'Energy-Detection Simulation', ...
       'Location', 'NorthWest');

xlim([1e-2 1e2]);
ylim([0 1]);

hold off;

fprintf('\n===== GRAPH GENERATED SUCCESSFULLY =====\n');

%% SIMULATION FUNCTION
function throughput = simulate_network( ...
    devices, attempts, base_energy, collision_probability)

    successful = 0;
    collisions = 0;

    fprintf('\n----------------------------------------\n');
    fprintf('Collision Probability: %.2f\n', ...
        collision_probability);
    fprintf('----------------------------------------\n');

    for i = 1:attempts

        % Select transmitting device
        transmitter = randi(devices);

        transmitting_energy = base_energy;

        % Generate collision event
        collision = rand() < collision_probability;

        if collision

            % Energy contributed by another transmitter
            other_energy = base_energy * ...
                (0.5 + 0.5 * rand());

            measured_energy = ...
                transmitting_energy + other_energy;

        else

            measured_energy = transmitting_energy;

        end

        fprintf('\nAttempt %d\n', i);
        fprintf('Device %d transmitting\n', transmitter);

        fprintf('Transmitting Energy = %.2f\n', ...
            transmitting_energy);

        fprintf('Measured Medium Energy = %.2f\n', ...
            measured_energy);

        % Energy comparison
        if measured_energy > transmitting_energy

            fprintf('Result: COLLISION DETECTED\n');
            collisions = collisions + 1;

        else

            fprintf('Result: NO COLLISION\n');
            successful = successful + 1;

        end
    end

    % Calculate throughput percentage
    throughput = (successful / attempts) * 100;

    fprintf('\n----------------------------------------\n');
    fprintf('Successful Transmissions: %d\n', successful);
    fprintf('Collisions: %d\n', collisions);
    fprintf('Throughput: %.2f%%\n', throughput);
    fprintf('----------------------------------------\n');

end

%% TOOLBOX-FREE POISSON RANDOM NUMBER GENERATOR
function k = poisson_random(lambda)

    % Handle zero arrival rate
    if lambda <= 0
        k = 0;
        return;
    end

    % Knuth's algorithm for Poisson random numbers
    L = exp(-lambda);
    p = 1;
    k = 0;

    while p > L
        k = k + 1;
        p = p * rand();
    end

    k = k - 1;

end

%% DISPLAY SUMMARY
fprintf('\n===============================================\n');
fprintf(' SIMULATION COMPLETED\n');
fprintf('===============================================\n');

