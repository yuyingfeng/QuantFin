function mse= likfunBSM(sigma, S,r,q, T, K, option_price_mkt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
option_price_BSM= BSM_price_calculator(S, r, q,T, K,sigma);
mse = sum((option_price_BSM-option_price_mkt).^2);


end

