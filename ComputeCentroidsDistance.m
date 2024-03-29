function idx = ComputeCentroidsDistance(X, centroids)
%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1 
%   vector of centroid assignments (i.e. each entry in range [1..K])
% @param X         : a num*dim feature matrix
% @param centroids : a k*dim dictionary matrix

% Set K
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), K);

% ====================== YOUR CODE HERE ======================
% Instructions: Go over every example, find its closest centroid, and store
%               the index inside idx at the appropriate location.
%               Concretely, idx(i) should contain the index of the centroid
%               closest to example i. Hence, it should be a value in the 
%               range 1..K
%

% the vectorized algorithm to find closest center
for i = 1:size(X,1)
    distance = sum(bsxfun(@minus,X(i,:), centroids).^2,2);
%     [smallest,idx(i,1)] = min(distance);    
    idx(i,:) = 1./distance;
end

% =============================================================

end

