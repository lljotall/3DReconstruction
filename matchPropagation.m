function [ local, seed ] = matchPropagation( I1, I2, matchedPoints1, matchedPoints2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   Lhillier & Quan, 2002
    
    n = 5;      % Neighborhood size
    matchN = 2; % Local neighborhood size
    z = 0.8;    % Xcorrelation threshold
    t = 2;      % Confidence threshold
    map = HashTable(length(I1)^2);
    
    % Assembles Heap with Seed input points
    seed = MaxHeapKV(length(I1)^2);
    for i = 1:length(matchedPoints1)
        % I1 window
        p = floor(matchedPoints1(i).Location);
        
        % I2 window
        q = floor(matchedPoints2(i).Location);
        
        % Calculates crosscorrelation between the two windows
        [zncc, dx, dy] = xcorrelation(n, I1, p, I2, q);

        % Insert maximum crosscorrelation in heap
        seed.InsertKey({zncc p q+[dx dy]});
    end

    while ~seed.IsEmpty()
        x = seed.ExtractMax();
        local = MaxHeapKV(length(I1)*length(I1));
        % Store in 'local' new candidate matches enforcing the disparity
        % gradient limit
        for i = x{2}(1)-n:x{2}(1)+n
            for j = x{2}(2)-n:x{2}(2)+n
                for u = x{3}(1)-n:x{3}(1)+n
                    for v = x{3}(2)-n:x{3}(2)+n
                        
                        if confidence(I1, i, j) > t && confidence(I2, u, v) > t
                            [zncc, dx, dy] = xcorrelation(matchN, I1, [i j], I2, [u v]);
                            if zncc > z
                                key = {zncc [i j] [u v]+[dx dy]};
                                local.InsertKey(key);
                            end
                        end
                        
                    end
                end
            end
        end
        
        % Store in 'seed' and 'map' final matches
        while ~local.IsEmpty()
            x = local.ExtractMax();
            if ~map.ContainsKey(mat2str(x{2})) && ~map.ContainsKey(mat2str(x{3}))
                seed.InsertKey(x);
                map.Add(mat2str(x{2}), x{3});
                map.Add(mat2str(x{3}), x{2});
            end
        end
    end

end

% Returns the maximum crosscorrelation between two matrices and the lag
% between their centers.
function [xcorrelation, lagX, lagY] = xcorrelation(n, I1, p, I2, q)
    neighborhood1 = I1(p(1)-n:p(1)+n, p(2)-n:p(2)+n);
    neighborhood2 = I2(q(1)-n:q(1)+n, q(2)-n:q(2)+n);
        
%     lagX = 0;
%     lagY = 0;
%     xcorrelation = sum(sum(normxcorr2(neighborhood1, neighborhood2)))/((2*n+1)^2);
    [znccPartial, line] = max(normxcorr2(neighborhood1, neighborhood2));
    [xcorrelation, column] = max(znccPartial);
    
    lagX = line(column)-2*n;
    lagY = column-2*n;
end

% ?
function s = confidence(I, x, y)
    s = max([I(x+1, y)-I(x, y) I(x-1, y)-I(x, y) I(x, y+1)-I(x, y) I(x, y-1)-I(x, y)]);
end