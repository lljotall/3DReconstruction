function [map1, map2, seed1, seed2] = matchPropagation( I1, I2, p1, p2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%   Lhillier & Quan, 2002

N= 2;
NN = 2*N + 1;   % Neighborhood size
n = 1;          % Local neighborhood size
nn = 2*n + 1;
z = 0;        % Xcorrelation threshold
t = 0;      % Confidence threshold
znccWindow = 2; %
NINF = -1024;


[maxRow, maxCol] = size(I1);
maxpoints = length(I1);
seed = NINF*ones(maxpoints, 5);
map1 = NINF*ones(maxpoints, 2);
map2 = NINF*ones(maxpoints, 2);
local = zeros(maxpoints, 5);

% compute ZNCC and filter points
[zncc, p1, p2] = computeMatchesZNCC(I1, p1, I2, p2, znccWindow);
p1 = p1(zncc > z, :);
p2 = p2(zncc > z, :);
zncc = zncc(zncc > z);

% Assembles Heap with Seed input points
seed(1:length(zncc), :) = sort([zncc' p1 p2], 1, 'descend');
nSeedsMatches = length(zncc);
endMapInd = 1;    

% computes neighborhood indexes
globalNeighbors = zeros(NN*NN, 2);
[globalNeighbors(:, 1), globalNeighbors(:,2)] = ind2sub([NN, NN], 1:NN*NN);
globalNeighbors = globalNeighbors - ceil(NN/2);

localNeighbors = zeros(nn*nn, 2);
[localNeighbors(:, 1), localNeighbors(:,2)] = ind2sub([nn, nn], 1:nn*nn);
localNeighbors = localNeighbors - ceil(nn/2);

% computers confidences
confidence1 = confidence(I1);
confidence2 = confidence(I2);

onesLocal = ones(length(localNeighbors), 2);
bestSeedInd = 1;
while nSeedsMatches > 0
    % best zncc
    bestSeedZNCC = seed(bestSeedInd, :);
    seed(bestSeedInd, 1) = NINF;
    bestSeedInd = bestSeedInd + 1;
    nSeedsMatches = nSeedsMatches - 1
    
    % local <- 0
    local(:, 1) = NINF;
    nLocalMatches = 0;
    
    % globalNeighbors
    u1 = bsxfun(@plus, globalNeighbors, bestSeedZNCC(2:3));
    u1(u1 < 1) = 1;
    u1(u1(:, 1) > maxRow, 1) = maxRow;
    u1(u1(:, 2) > maxCol, 2) = maxCol;
 
    u2Limits(1) = max(bestSeedZNCC(4) - N, 0);
    u2Limits(2) = min(bestSeedZNCC(4) + N, maxRow);
    u2Limits(3) = max(bestSeedZNCC(5) - N, 0);
    u2Limits(4) = min(bestSeedZNCC(5) + N, maxCol);
    for i=1:length(u1)
        u2 = bsxfun(@plus, localNeighbors, bestSeedZNCC(4:5));
        u2(u2(:, 1) < u2Limits(1), 1) = u2Limits(1);
        u2(u2(:, 1) > u2Limits(2), 1) = u2Limits(2);
        u2(u2(:, 2) < u2Limits(3), 1) = u2Limits(3);
        u2(u2(:, 2) > u2Limits(4), 1) = u2Limits(4);
        
        uu1 = bsxfun(@times, u1(i, :), onesLocal);
        [znccLocal, fpu1, fpu2] = computeMatchesZNCC(I1, uu1, I2, u2, znccWindow);
        
        if isempty(fpu1) == true
            continue;
        end
        
        fpu1 = fpu1(znccLocal > z, :);
        fpu2 = fpu2(znccLocal > z, :);
        
        uConf1 = confidence1(uint32(fpu1(:, 1)) + uint32((fpu1(:, 2) - 1))*maxRow);
        uConf2 = confidence2(uint32(fpu2(:, 1)) + uint32((fpu2(:, 2) - 1))*maxRow);
        
        firstCondition = uConf1 > t;
        secondCondition =  uConf2 > t;
        andConditions = logical(firstCondition .* secondCondition); 
        
        npropagated = sum(andConditions);
        if npropagated > 0
            local((nLocalMatches + 1):(nLocalMatches + npropagated), :) = ...
                [zncc(andConditions)', fpu1(andConditions, :), fpu2(andConditions, :)];
            nLocalMatches = nLocalMatches + npropagated;
        end
    end
    
    if nLocalMatches > 0
        local = sort(local, 1, 'descend');
        bestLocalInd = 1;
        
        while bestLocalInd <= nLocalMatches
            bestLocalZNCC = local(bestLocalInd, :);
            bestLocalInd = bestLocalInd + 1;
    
            if (ismember(bestLocalZNCC(2:3), map1, 'rows') ~= 1 && ...
                    ismember(bestLocalZNCC(4:5), map2,'rows') ~= 1)
                
                % stores ind map
                map1(endMapInd, :) = bestLocalZNCC(2:3);
                map2(endMapInd, :) = bestLocalZNCC(4:5);
                endMapInd = endMapInd + 1;
                
                % stores in seed
                emptySeedSpot = find(seed(:, 1) == NINF, 1);
                seed(emptySeedSpot, :) = bestLocalZNCC;
                nSeedsMatches = nSeedsMatches + 1;
            end 
        end
        
        seed = sort(seed, 1, 'descend');
    end
end

map1 = map1(1:endMapInd-1, :);
map2 = map2(1:endMapInd-1, :);
seed1 = p1;
seed2 = p2;

end