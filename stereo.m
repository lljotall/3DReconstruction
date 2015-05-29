function [ hNew ] = stereo( h1 )
%STEREO Uses an iterative approach to find correspondent points in two
%stereo images.
%   Method deduced in B.D. Lucas and T. Kanade. An iterative image registra
%   tion technique with an application to stereo vision. In Proceedings of 
%   the 7th International Joint Conference on Artificial Intelligence, 1981.

    % Initialization
    %h1 = 3;
    x = (1:1000)';
    func = @(x) (x.^2);

    F = func(x);
    G = func(x+h1);

    %plot(x, F, x, G);

    hOld = 0;
    hNew = 1;

     while(hNew ~= hOld)
        hOld = hNew;
        beginRange = 1:(length(x)-hOld-1);
        endRange = (hOld+1):(length(x)-1);
        endRangeDiff = [endRange length(x)];
         
        w = 1./abs(diff(G)-diff(F));
        factor = w(beginRange).*diff(F(endRangeDiff));
        hNew = hOld+ round(sum(factor.*(G(beginRange)-F(endRange)))/sum(factor.*diff(F(endRangeDiff))));
     end
end

