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

fprintf('\n===== Selective Repeat ARQ =====\n');

start = 1;

while start <= frame_size

    % Determine the current window
    ending = min(start + window_size - 1, frame_size);

    fprintf('\nSender sends:\n');

    for i = start:ending
        fprintf('%s ', frames{i});
    end
    fprintf('\n');

    % Store lost frames
    lost_frames = {};

    fprintf('\nReceiver:\n');

    % Process each frame in the window
    for i = start:ending

        % Random frame loss
        if rand() < loss_probability

            fprintf('%s -> Frame Lost\n', frames{i});
            fprintf('%s -> Timeout\n', frames{i});

            lost_frames{end + 1} = frames{i};

        else

            fprintf('%s -> Received\n', frames{i});

            % Random ACK loss
            if rand() < loss_probability

                fprintf('ACK%d -> Lost\n', i);
                fprintf('%s -> Timeout\n', frames{i});

                lost_frames{end + 1} = frames{i};

            else

                fprintf('ACK%d -> Received\n', i);

            end
        end
    end

    % Selective retransmission
    if ~isempty(lost_frames)

        fprintf('\nSender retransmits:\n');

        for i = 1:length(lost_frames)
            fprintf('%s ', lost_frames{i});
        end
        fprintf('\n');

        fprintf('\nReceiver:\n');

        for i = 1:length(lost_frames)

            frame = lost_frames{i};

            % Extract frame number
            frame_number = sscanf(frame, 'F%d');

            fprintf('%s -> Received\n', frame);
            fprintf('ACK%d -> Received\n', frame_number);

        end

    else

        fprintf('\nNo Retransmission Needed\n');

    end

    % Slide the window
    fprintf('\nWindow Slides\n');

    start = ending + 1;

end

fprintf('\nAll Frames Transmitted Successfully!\n');

