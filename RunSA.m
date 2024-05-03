function [best_cost, best_solution] = RunSA(model,CostFunction)
    % Initialize SA parameters
    MaxIt = 1200;       % Maximum Number of Iterations
    MaxIt2 = 80;        % Maximum Number of Inner Iterations
    T0 = model.T0;      % Initial Temperature
    alpha = model.alpha;% Temperature Damping Rate
    % Initialization
    x.Position = CreateRandomSolution(model);
    [x.Cost, x.Sol] = CostFunction(x.Position);
    BestSol = x;
    BestCost = zeros(MaxIt, 1);
    T = T0;
    % SA Main Loop
    for it = 1:MaxIt
        for it2 = 1:MaxIt2
            % Create Neighbor
            xnew.Position = CreateNeighbor(x.Position);
            [xnew.Cost, xnew.Sol] = CostFunction(xnew.Position);
            if xnew.Cost <= x.Cost
                % xnew is better, so it is accepted
                x = xnew;
            else
                % xnew is not better, so it is accepted conditionally
                delta = xnew.Cost - x.Cost;
                p = exp(-delta / T);
                if rand <= p
                    x = xnew;
                end
            end
            % Update Best Solution
            if x.Cost <= BestSol.Cost
                BestSol = x;
            end
        end
        % Store Best Cost
        BestCost(it) = BestSol.Cost;
        % Reduce Temperature
        T = alpha * T;
    end
    % Output the best cost and best solution
    best_cost = BestSol.Cost;
    best_solution = BestSol;
end