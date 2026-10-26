clc;
clear;
close all;

% =========================================================
% INPUT: ROUTERS
% =========================================================

n = input('Enter number of routers: ');

if n < 1 || n ~= floor(n)
    error('Number of routers must be a positive integer.');
end

routers = cell(1, n);

fprintf('\nEnter Router Names:\n');

for i = 1:n
    routers{i} = upper(strtrim(input( ...
        sprintf('Router %d: ', i), 's')));

    if isempty(routers{i})
        error('Router name cannot be empty.');
    end

    if any(strcmp(routers(1:i-1), routers{i}))
        error('Router names must be unique.');
    end
end

% =========================================================
% ENTER LINKS
% =========================================================

A = zeros(n, n);

links = input('\nEnter number of links: ');

if links < 0 || links ~= floor(links)
    error('Number of links must be a non-negative integer.');
end

fprintf('\nEnter links in the format:\n');
fprintf('A B 4\n');
fprintf('Meaning: A and B are connected with cost 4\n\n');

for i = 1:links

    line = input(sprintf('Link %d: ', i), 's');

    parts = strsplit(strtrim(line));

    if numel(parts) ~= 3
        error('Enter each link in the format: A B 4');
    end

    r1 = upper(parts{1});
    r2 = upper(parts{2});
    cost = str2double(parts{3});

    idx1 = find(strcmp(routers, r1), 1);
    idx2 = find(strcmp(routers, r2), 1);

    if isempty(idx1) || isempty(idx2)
        error('Link contains an unknown router.');
    end

    if idx1 == idx2
        error('Self-links are not supported.');
    end

    if ~isfinite(cost) || cost <= 0
        error('Link cost must be a positive number.');
    end

    % Undirected network
    A(idx1, idx2) = cost;
    A(idx2, idx1) = cost;

end

% Create MATLAB graph
G = graph(A, routers);

% =========================================================
% COMPLETE NETWORK GRAPH
% =========================================================

figure('Name', 'Complete Network Graph');

p1 = plot(G, ...
    'Layout', 'force', ...
    'NodeLabel', routers, ...
    'EdgeLabel', G.Edges.Weight, ...
    'NodeColor', [0.3 0.7 0.9], ...
    'MarkerSize', 9, ...
    'LineWidth', 1.5);

title('Complete Network Graph');
p1.NodeFontSize = 12;

% =========================================================
% GENERATE ROUTING TABLES
% =========================================================

fprintf('\n');
fprintf('%s\n', repmat('=', 1, 85));
fprintf('                         ROUTING TABLES\n');
fprintf('%s\n', repmat('=', 1, 85));

for s = 1:n

    [distance, previous] = dijkstra(A, s);

    fprintf('\nRouting Table for Router %s\n', routers{s});
    fprintf('%s\n', repmat('-', 1, 85));

    fprintf('%-15s %-15s %-12s %s\n', ...
        'Destination', 'Next Hop', 'Cost', 'Path');

    fprintf('%s\n', repmat('-', 1, 85));

    for d = 1:n

        path = get_path(previous, s, d);

        % Source router itself
        if s == d

            next_hop = '-';
            cost = '0';
            path_string = routers{s};

        % No route available
        elseif isinf(distance(d))

            next_hop = '-';
            cost = 'INF';
            path_string = 'No Route';

        % Normal route
        else

            next_hop = routers{path(2)};
            cost = num2str(distance(d));
            path_string = strjoin(routers(path), ' -> ');

        end

        fprintf('%-15s %-15s %-12s %s\n', ...
            routers{d}, next_hop, cost, path_string);

    end
end

% =========================================================
% SOURCE AND DESTINATION
% =========================================================

fprintf('\n');
fprintf('%s\n', repmat('=', 1, 85));

source = upper(strtrim(input('Enter Source Router: ', 's')));
destination = upper(strtrim(input('Enter Destination Router: ', 's')));

src = find(strcmp(routers, source), 1);
dst = find(strcmp(routers, destination), 1);

if isempty(src) || isempty(dst)

    fprintf('\nInvalid Router!\n');

else

    [distance, previous] = dijkstra(A, src);
    path = get_path(previous, src, dst);

    if isempty(path)

        fprintf('\nNo route available between %s and %s.\n', ...
            source, destination);

    else

        fprintf('\n');
        fprintf('%s\n', repmat('=', 1, 85));
        fprintf('                         ROUTING RESULT\n');
        fprintf('%s\n', repmat('=', 1, 85));

        fprintf('Source      : %s\n', source);
        fprintf('Destination : %s\n', destination);
        fprintf('Cost        : %g\n', distance(dst));
        fprintf('Path        : %s\n', ...
            strjoin(routers(path), ' -> '));

        % ================================================
        % DRAW SELECTED SHORTEST PATH
        % ================================================

        figure('Name', 'Selected Shortest Path');

        p2 = plot(G, ...
            'Layout', 'force', ...
            'NodeLabel', routers, ...
            'EdgeLabel', G.Edges.Weight, ...
            'NodeColor', [0.75 0.75 0.75], ...
            'MarkerSize', 9, ...
            'LineWidth', 1.5);

        title(sprintf('Shortest Path: %s to %s (Cost = %g)', ...
            source, destination, distance(dst)));

        p2.NodeFontSize = 12;

        % Highlight path nodes
        highlight(p2, path, ...
            'NodeColor', [0.2 0.8 0.3], ...
            'MarkerSize', 11);

        % Highlight path edges
        if numel(path) > 1
            highlight(p2, path(1:end-1), path(2:end), ...
                'EdgeColor', [1 0 0], ...
                'LineWidth', 3);
        end

    end
end

% =========================================================
% ALL PAIRWISE SHORTEST PATHS
% =========================================================

fprintf('\n');
fprintf('%s\n', repmat('=', 1, 85));
fprintf('                   ALL PAIRWISE SHORTEST PATHS\n');
fprintf('%s\n', repmat('=', 1, 85));

all_paths = {};
all_costs = [];

pair_count = 0;

for s = 1:n

    [distance, previous] = dijkstra(A, s);

    for d = s+1:n

        path = get_path(previous, s, d);

        if ~isempty(path)

            path_string = strjoin(routers(path), ' -> ');

            fprintf('%s -> %s   Cost = %g   Path = %s\n', ...
                routers{s}, routers{d}, ...
                distance(d), path_string);

            pair_count = pair_count + 1;

            all_paths{pair_count} = sprintf( ...
                '%s -> %s : %s (Cost = %g)', ...
                routers{s}, routers{d}, ...
                path_string, distance(d));

            all_costs(pair_count) = distance(d);

        else

            fprintf('%s -> %s   Cost = INF   Path = No Route\n', ...
                routers{s}, routers{d});

        end
    end
end

% =========================================================
% DRAW ALL-PAIRS SHORTEST PATHS
% =========================================================

fprintf('\nGenerating All-Pairs Shortest Path Graph...\n');

figure('Name', 'All-Pairs Shortest Paths');

p3 = plot(G, ...
    'Layout', 'force', ...
    'NodeLabel', routers, ...
    'EdgeLabel', G.Edges.Weight, ...
    'NodeColor', [0.3 0.7 0.9], ...
    'MarkerSize', 9, ...
    'LineWidth', 1.5);

title('Network Graph - All Pairwise Shortest Paths');
p3.NodeFontSize = 12;

% Display all shortest paths beside the graph
if isempty(all_paths)

    path_text = 'No connected router pairs found.';

else

    path_text = strjoin(all_paths, newline);

end

annotation('textbox', [0.12 0.01 0.78 0.20], ...
    'String', path_text, ...
    'FitBoxToText', 'off', ...
    'Interpreter', 'none', ...
    'FontSize', 9, ...
    'BackgroundColor', 'white', ...
    'EdgeColor', [0.5 0.5 0.5]);

fprintf('\n');
fprintf('%s\n', repmat('=', 1, 85));
fprintf('                  PROGRAM COMPLETED\n');
fprintf('%s\n', repmat('=', 1, 85));




function [distance, previous] = dijkstra(A, source)

n = size(A, 1);

distance = inf(1, n);
previous = zeros(1, n);
visited = false(1, n);

distance(source) = 0;

for iteration = 1:n

    % Select unvisited router with minimum distance
    candidates = distance;
    candidates(visited) = inf;

    [minimum, u] = min(candidates);

    if isinf(minimum)
        break;
    end

    visited(u) = true;

    % Check all neighbouring routers
    neighbours = find(A(u, :) > 0);

    for v = neighbours

        if visited(v)
            continue;
        end

        new_distance = distance(u) + A(u, v);

        if new_distance < distance(v)

            distance(v) = new_distance;
            previous(v) = u;

        end
    end
end
end


% =========================================================
% FIND SHORTEST PATH
% =========================================================

function path = get_path(previous, source, destination)

path = [];
current = destination;

% Unreachable destination
if source ~= destination && previous(destination) == 0
    return;
end

% Reconstruct path backwards
while current ~= 0

    path = [current path];

    if current == source
        return;
    end

    current = previous(current);

end

% Source was not reached
path = [];
end