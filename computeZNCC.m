%ZNCC  Normalized cross correlation
%
%	m = zncc(w1, w2)
%
% Compute the zero-mean normalized cross-correlation between the two
% equally sized image patches w1 and w2.  Result is in the range -1 to 1, with
% 1 indicating identical pixel patterns.
%
% SEE ALSO:	isimilarity

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.

function m = computeZNCC(w1, w2)

	w1 = w1 - mean(w1(:));
	w2 = w2 - mean(w2(:));

	denom = sqrt(sum(sum(w1.^2))*sum(sum(w2.^2)));

	if denom < 1e-10,
		m = 0;
	else
		m = sum(sum((w1.*w2))) / denom;
    end
end