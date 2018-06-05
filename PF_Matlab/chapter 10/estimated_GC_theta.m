function [theta, MSE, GC_prices ] = estimated_GC_theta(S,r,q,T,K,theta0,option_mkt_p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

options=optimset('MaxFunEvals',100000,'Maxiter',100000,'Display','iter','LargeScale','off');
[theta,MSE]=fminsearch(@(theta)likfunGC(theta, S,r,q, T, K,option_mkt_p),theta0);
MSE=MSE/length(S);
GC_prices= GC_price_calculator(S, r, q,T, K,theta(1),theta(2),theta(3));
end

