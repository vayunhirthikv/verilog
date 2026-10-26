clc;
clear;

window_size = input('Enter the Window Size: ');
frame_size = input('Enter Frame Size: ');
loss_probability = input('Enter Loss Probability (0 to 1): ');

% Validate inputs
if window_size <= 0 || window_size ~= floor(window_size)
    error('Window size must be a positive integer.');
end

if frame_size <= 0 || frame_size ~= floor(frame_size)
    error('Frame size must be a positive integer.');
end

if loss_probability < 0 || loss_probability > 1
    error('Loss probability must be between 0 and 1.');
end

% Create frames
frames = cell(1, frame_size);

for i = 1:frame_size
    frames{i} = ['F', num2str(i)];
end

fprintf('\n===== Go-Back-N ARQ =====\n');

start = 1;

while start <= frame_size

    % Determine current window
    ending = min(start + window_size - 1, frame_size);

    fprintf('\nSender sends:\n');

    for i = start:ending
        fprintf('%s ', frames{i});
    end
    fprintf('\n');

    lost_index = 0;
    ack_lost = false;

    fprintf('\nReceiver:\n');

    % Transmit frames in the current window
    for i = start:ending

        % Random frame loss
        if rand() < loss_probability

            fprintf('%s -> Frame Lost\n', frames{i});
            lost_index = i;
            break;

        else

            % Go-Back-N receiver discards out-of-order frames
            if lost_index == 0

                fprintf('%s -> Received\n', frames{i});

                % Random ACK loss
                if rand() < loss_probability

                    fprintf('ACK%d -> Lost\n', i);
                    lost_index = i;
                    ack_lost = true;
                    break;

                else

                    fprintf('ACK%d -> Received\n', i);

                end

            end
        end
    end

    % Retransmit from the lost frame onward
    if lost_index > 0

        fprintf('\nTimeout Occurred\n');
        fprintf('Sender retransmits from %s:\n', ...
            frames{lost_index});

        for i = lost_index:ending
            fprintf('%s ', frames{i});
        end
        fprintf('\n');

        fprintf('\nReceiver:\n');

        % Assume retransmitted frames and ACKs succeed
        for i = lost_index:ending
            fprintf('%s -> Received\n', frames{i});
            fprintf('ACK%d -> Received\n', i);
        end

    else

        fprintf('\nNo Retransmission Needed\n');

    end

    % Slide window
    fprintf('\nWindow Slides\n');

    start = ending + 1;

end

fprintf('\nAll Frames Transmitted Successfully!\n');



