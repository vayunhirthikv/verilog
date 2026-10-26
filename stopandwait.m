clc;
clear;

frame_size = input('Enter Number of Frames: ');
loss_probability = input('Enter Loss Probability (0 to 1): ');

% Validate inputs
if frame_size <= 0 || frame_size ~= floor(frame_size)
    error('Number of frames must be a positive integer.');
end

if loss_probability < 0 || loss_probability > 1
    error('Loss probability must be between 0 and 1.');
end

% Create frames
frames = cell(1, frame_size);

for i = 1:frame_size
    frames{i} = ['F', num2str(i)];
end

fprintf('\n===== Stop-and-Wait ARQ =====\n');

for i = 1:frame_size

    frame = frames{i};

    while true

        fprintf('\nSender sends: %s\n', frame);

        % Start timer
        fprintf('Timer Started\n');

        pause(1);

        % Random frame loss
        if rand() < loss_probability

            fprintf('Receiver: Frame Lost\n');
            fprintf('Timeout Occurred\n');
            fprintf('Retransmitting %s\n', frame);

            continue;

        else

            fprintf('Receiver: %s Received\n', frame);

            % Random ACK loss
            if rand() < loss_probability

                fprintf('ACK Lost\n');
                fprintf('Timeout Occurred\n');
                fprintf('Retransmitting %s\n', frame);

                continue;

            else

                fprintf('ACK Received for %s\n', frame);
                fprintf('Moving to next frame\n');

                break;

            end
        end
    end
end

fprintf('\nAll Frames Transmitted Successfully!\n');


