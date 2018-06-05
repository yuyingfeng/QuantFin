function [sigma, MSE, BSM_prices ] = estimated_BSM_sigma(S,r,q,T,K,sigma0,option_mkt_p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

options=optimset('MaxFunEvals',100000,'Maxiter',100000,'Display','iter','LargeScale','off');
[sigma,MSE]=fminsearch(@(sigma)likfunBSM(sigma, S,r,q, T, K,option_mkt_p),sigma0);
MSE=MSE/length(S);
BSM_prices= BSM_price_calculator(S, r, q,T, K,sigma);

end

