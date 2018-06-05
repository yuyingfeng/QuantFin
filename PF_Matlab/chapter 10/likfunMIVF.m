function MSE= likfunMIVF(alpha, S,r,q, T, K, option_price_mkt )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
x0=ones(length(S),1);
x1=S./K;
x2=x1.^2;
x3=T/365;
x4=x3.^2;
x5=x1.*x3;
XX=[x0,x1,x2,x3,x4,x5];

yhat=XX*alpha;
yhat=max(yhat,0.0000000000000001);

BSM_IVF_prices= BSM_price_calculator(S, r, q,T, K,yhat);
Sqaured_Pricing_Error=(BSM_IVF_prices-option_price_mkt).^2;
MSE=sum(Sqaured_Pricing_Error)/length(S); 



end

