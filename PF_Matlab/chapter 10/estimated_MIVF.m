function [alpha, MSE, MIVF_prices ] = estimated_MIVF(S,r,q,T,K,alpha0,option_mkt_p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%options=optimset('MaxFunEvals',100000,'Maxiter',100000,'Display','iter','LargeScale','off');
[alpha,MSE]=fminsearch(@(alpha)likfunMIVF(alpha, S,r,q, T, K,option_mkt_p),alpha0);
MSE=MSE/length(S);

x0=ones(length(S),1);
x1=S./K;
x2=x1.^2;
x3=T/365;
x4=x3.^2;
x5=x1.*x3;
XX=[x0,x1,x2,x3,x4,x5];

impvol=XX*alpha;
impvol=max(impvol,0.0000000000001);

MIVF_prices= BSM_price_calculator(S, r, q,T, K,impvol);
end

