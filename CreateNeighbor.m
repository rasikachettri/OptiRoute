%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPAP108
% Project Title: Solving Vehicle Routing Problem using Simulated Annealing
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function qnew=CreateNeighbor(q)
    m=randi([1 3]);
    switch m
        case 1
            qnew=Swap(q);   % Do Swap
        case 2
            qnew=Reversion(q);    % Do Reversion
        case 3
            qnew=Insertion(q);   % Do Insertion
    end
end

function qnew=Swap(q)
    n=numel(q);
    i=randsample(n,2);
    i1=i(1);
    i2=i(2);
    qnew=q;
    qnew([i1 i2])=q([i2 i1]);
end

function qnew=Reversion(q)
    n=numel(q);
    i=randsample(n,2);
    i1=min(i(1),i(2));
    i2=max(i(1),i(2));
    qnew=q;
    qnew(i1:i2)=q(i2:-1:i1);
end

function qnew=Insertion(q)
    n=numel(q);
    i=randsample(n,2);
    i1=i(1);
    i2=i(2);
    if i1<i2
        qnew=[q(1:i1-1) q(i1+1:i2) q(i1) q(i2+1:end)];
    else
        qnew=[q(1:i2) q(i1) q(i2+1:i1-1) q(i1+1:end)];
    end
end

