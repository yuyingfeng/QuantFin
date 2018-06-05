function mse= likfunGC(theta, S,r,q, T, K, option_price_mkt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
option_price_GC= GC_price_calculator(S, r, q,T, K,theta(1),theta(2),theta(3));
mse = mean((option_price_GC-option_price_mkt).^2);


end

