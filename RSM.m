clc;
clear;
close all;

rng("default")
rand % returns the same value as at startup

%% Directory containing the models
models_directory = 'model';
model_files = dir(fullfile(models_directory, '*.mat'));
model_paths = fullfile(models_directory, {model_files.name});
num_models = numel(model_paths); % Number of found models
models = cell(num_models, 1); % Initialize cell array to store models
model_names = cell(num_models, 1); % Initialize cell array to store model names
for i = 1:num_models
    data = load(model_paths{i}); % Load each model data
    models{i} = data.model; % Store model in cell array
    [~, filename, ~] = fileparts(model_files(i).name); % Extract filename without extension
    model_names{i} = filename; % Store filename in cell array
end

% RSM Parameters
low_T0 = 5; % Lower bound for T0
high_T0 = 1000; % Upper bound for T0
low_alpha = 0.1; % Lower bound for alpha
high_alpha = 1.0; % Upper bound for alpha
num_points = 8; % Number of points in each dimension for grid

best_model = zeros(num_models, 1);
flag = true(num_models, 1);

best_temp=zeros(num_models,1);
best_alpha=zeros(num_models,1);
best_index=zeros(num_models,1);

for m = 1:num_models
    model = models{m}; % Get current model
    CostFunction = @(q) MyCost(q, model); % Cost Function
    % Generate Experimental Design Grid
    T0_values = linspace(low_T0, high_T0, num_points);
    alpha_values = linspace(low_alpha, high_alpha, num_points);
    
    figure('Name',model_names{m}); % Create a new figure for each model
    hold on;
    costs = zeros(num_points * num_points, 1);
    x_labels = cell(num_points * num_points, 1);
    best_solutions = cell(num_points * num_points, 1);
    idx = 1;
    
    for i = 1:num_points
        for j = 1:num_points
            % Set hyperparameters
            model.T0 = T0_values(i);
            model.alpha = alpha_values(j);
            
            % Run SA algorithm
            [best_cost, best_solution] = RunSA(model, CostFunction);
            if best_cost<=best_model(m) || flag(m)
                best_temp(m)=T0_values(i);
                best_alpha(m)=alpha_values(j);
                best_model(m)=best_cost;
                best_index(m)=idx;
                flag(m)=false;

            end
            % Store cost and best solution
            costs(idx) = best_cost;
            best_solutions{idx} = best_solution;
            % Create x-axis labels
            x_labels{idx} = sprintf('%.2f * %.2f', T0_values(i), alpha_values(j));
            idx = idx + 1;
        end
    end
    
    % Plot the costs as a line graph
    plot(1:num_points*num_points, costs, 'LineWidth', 1.5);
    grid on;
    
    % Set x-axis labels
    xticks(1:num_points*num_points);
    xticklabels(x_labels);
    xtickangle(45);
    
    xlabel('Combination');
    ylabel('Cost');
    t=title(['Cost of ', model_names{m}]);
    set(t,'Interpreter','none');
    % Highlight the best solution for each combination
    for k = 1:num_points * num_points
         if k == best_index(m)
            scatter(k, costs(k), 100, 'b', 'filled');  % Highlight in blue with larger marker
        else
            scatter(k, costs(k), 10, 'r', 'filled');   % Other points in red with smaller marker
         end
         drawnow;
    end
    hold off;

    disp([model_names{m}, ': Best Cost = ', num2str(best_model(m)), ...
        ', Best T0 = ', num2str(best_temp(m)), ', Best Alpha = ', num2str(best_alpha(m))]);


    
   
end


