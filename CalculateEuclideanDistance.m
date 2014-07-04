function [ Z ] = CalculateEuclideanDistance( X, Y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Input:  X, Y: Matrix
%   Output:  Z: Euclidean Distance of X and Y

    X_vector = reshape(X, numel(X),1);
    Y_vector = reshape(Y, numel(Y),1);
    C = (X_vector-Y_vector).^2;
    Z = sqrt(sum(C));

end

