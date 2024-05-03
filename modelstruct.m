function model = modelstruct(J, c, I, r, x, y)
    x0 = 51.49867690805325; % x-coordinate of depot
    y0 = -0.1009936968752794; % y-coordinate of depot
    xmin= 51.35;
    xmax= 51.58;
    ymin= -0.26;
    ymax= 0.078;
    % Create the struct
    model.I = I;    model.J = J;    model.r = r;    model.c = c;
    model.x = x;    model.y = y;    model.x0 = x0;    model.y0 = y0;
    model.xmin= xmin;    model.xmax= xmax;
    model.ymin= ymin;    model.ymax=ymax;
    
    % Calculate d0 (distance from depot to each customer)
    d0 = sqrt((x - x0).^2 + (y - y0).^2);
    model.d0 = d0;
    
    % Calculate d (distance between each pair of customers)
    d = zeros(I, I);
    for i = 1:I
        for j = 1:I
            d(i, j) = sqrt((x(i) - x(j))^2 + (y(i) - y(j))^2);
        end
    end
    model.d = d;
end

