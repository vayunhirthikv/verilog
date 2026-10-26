clc;
clear;
close all;

% =========================================================
% DISTANCE VECTOR ROUTING USING BELLMAN-FORD
% =========================================================

n = input('Enter number of routers: ');

if n < 1 || n ~= floor(n)
    error('Number of routers must be a positive integer.');
end

routers = cell(1,n);

fprintf('\nEnter Router Names:\n');

for i = 1:n
    routers{i} = upper(strtrim(input( ...
        sprintf('Router %d: ',i),'s')));

    if isempty(routers{i}) || any(strcmp(routers(1:i-1),routers{i}))
        error('Router names must be unique and nonempty.');
    end
end

% =========================================================
% ENTER LINKS
% =========================================================

A = zeros(n,n);

links = input('\nEnter number of links: ');

if links < 0 || links ~= floor(links)
    error('Number of links must be a non-negative integer.');
end

fprintf('\nEnter links in the format: A B 4\n');
fprintf('Example: A B 4 means cost between A and B is 4.\n\n');

for i = 1:links

    parts = strsplit(strtrim(input( ...
        sprintf('Link %d: ',i),'s')));

    if numel(parts) ~= 3
        error('Enter each link in the format: A B Cost');
    end

    r1 = upper(parts{1});
    r2 = upper(parts{2});
    cost = str2double(parts{3});

    u = find(strcmp(routers,r1),1);
    v = find(strcmp(routers,r2),1);

    if isempty(u) || isempty(v) || u == v
        error('Invalid router or self-link.');
    end

    if ~isfinite(cost) || cost <= 0
        error('Link cost must be positive.');
    end

    if A(u,v) ~= 0
        error('Duplicate links are not supported.');
    end

    A(u,v) = cost;
    A(v,u) = cost;

end

% =========================================================
% DRAW NETWORK GRAPH
% =========================================================

G = graph(A,routers);

figure('Name','Distance Vector Network');

p = plot(G,'Layout','force', ...
    'NodeLabel',routers, ...
    'EdgeLabel',G.Edges.Weight, ...
    'LineWidth',1.5);

title('Distance Vector Routing Network');

% =========================================================
% INITIALIZE DISTANCE VECTORS
% =========================================================

% Each row represents one router's distance vector.
% Each column represents a destination.

D = inf(n,n);
nextHop = zeros(n,n);

for i = 1:n

    % Distance from router to itself
    D(i,i) = 0;

    % Directly connected neighbours
    for j = 1:n

        if A(i,j) > 0
            D(i,j) = A(i,j);
            nextHop(i,j) = j;
        end
    end
end

% =========================================================
% DISTANCE VECTOR ITERATIONS
% =========================================================

fprintf('\n========== DISTANCE VECTOR UPDATES ==========\n');

maxIterations = n - 1;

for iteration = 1:maxIterations

    D_old = D;
    nextHop_old = nextHop;
    changed = false;

    fprintf('\nIteration %d\n',iteration);

    % Each router receives distance vectors from neighbours
    for i = 1:n

        neighbours = find(A(i,:) > 0);

        for j = neighbours

            % Router i considers routes advertised by router j
            for d = 1:n

                if isfinite(D_old(j,d))

                    newCost = A(i,j) + D_old(j,d);

                    if newCost < D(i,d)

                        D(i,d) = newCost;
                        nextHop(i,d) = j;
                        changed = true;

                    end
                end
            end
        end
    end

    fprintf('Updated distance vectors:\n');

    fprintf('%-12s', 'Router');

    for d = 1:n
        fprintf('%-10s',routers{d});
    end
    fprintf('\n');

    for i = 1:n

        fprintf('%-12s',routers{i});

        for d = 1:n

            if isinf(D(i,d))
                fprintf('%-10s','INF');
            else
                fprintf('%-10g',D(i,d));
            end
        end
        fprintf('\n');
    end

    if ~changed
        fprintf('\nConvergence reached.\n');
        break;
    end
end

% =========================================================
% GENERATE ROUTING TABLES
% =========================================================

fprintf('\n========== DISTANCE VECTOR ROUTING TABLES ==========\n');

for i = 1:n

    fprintf('\nRouting Table for Router %s\n',routers{i});

    fprintf('%-15s %-15s %-12s %s\n', ...
        'Destination','Next Hop','Cost','Path');

    for d = 1:n

        path = build_path(nextHop,i,d,n);

        if i == d

            hop = '-';
            cost = '0';
            pathText = routers{i};

        elseif isinf(D(i,d))

            hop = '-';
            cost = 'INF';
            pathText = 'No Route';

        elseif isempty(path)

            hop = '-';
            cost = num2str(D(i,d));
            pathText = 'Path unavailable';

        else

            hop = routers{nextHop(i,d)};
            cost = num2str(D(i,d));
            pathText = strjoin(routers(path),' -> ');

        end

        fprintf('%-15s %-15s %-12s %s\n', ...
            routers{d},hop,cost,pathText);

    end
end

% =========================================================
% SOURCE AND DESTINATION
% =========================================================

source = upper(strtrim(input('\nEnter Source Router: ','s')));
destination = upper(strtrim(input('Enter Destination Router: ','s')));

s = find(strcmp(routers,source),1);
d = find(strcmp(routers,destination),1);

if isempty(s) || isempty(d)

    fprintf('\nInvalid Router!\n');

elseif isinf(D(s,d))

    fprintf('\nNo route available.\n');

else

    path = build_path(nextHop,s,d,n);

    fprintf('\n========== ROUTING RESULT ==========\n');

    fprintf('Source      : %s\n',source);
    fprintf('Destination : %s\n',destination);
    fprintf('Cost        : %g\n',D(s,d));

    if isempty(path)
        fprintf('Path        : Path unavailable\n');
    else
        fprintf('Path        : %s\n', ...
            strjoin(routers(path),' -> '));

        % ================================================
        % HIGHLIGHT ROUTE
        % ================================================

        figure('Name','Distance Vector Shortest Path');

        p = plot(G,'Layout','force', ...
            'NodeLabel',routers, ...
            'EdgeLabel',G.Edges.Weight);

        title(sprintf('Distance Vector: %s to %s (Cost = %g)', ...
            source,destination,D(s,d)));

        highlight(p,path,'NodeColor',[0.2 0.8 0.3]);

        if numel(path) > 1
            highlight(p,path(1:end-1),path(2:end), ...
                'EdgeColor','red','LineWidth',3);
        end
    end
end

% =========================================================
% ALL-PAIRS SHORTEST ROUTES
% =========================================================

fprintf('\n========== ALL-PAIRS SHORTEST ROUTES ==========\n');

for i = 1:n

    for d = i+1:n

        path = build_path(nextHop,i,d,n);

        if isinf(D(i,d))

            fprintf('%s -> %s | No Route\n', ...
                routers{i},routers{d});

        elseif isempty(path)

            fprintf('%s -> %s | Cost = %g | Path unavailable\n', ...
                routers{i},routers{d},D(i,d));

        else

            fprintf('%s -> %s | Cost = %g | Path = %s\n', ...
                routers{i},routers{d},D(i,d), ...
                strjoin(routers(path),' -> '));

        end
    end
end

fprintf('\nPROGRAM COMPLETED\n');

% =========================================================
% RECONSTRUCT ROUTE USING NEXT HOPS
% =========================================================

function path = build_path(nextHop,source,destination,n)

    path = source;

    if source == destination
        return;
    end

    current = source;

    for k = 1:n

        current = nextHop(current,destination);

        if current == 0
            path = [];
            return;
        end

        path(end+1) = current;

        if current == destination
            return;
        end
    end

    % Prevent infinite loops if a route is inconsistent
    path = [];
end

