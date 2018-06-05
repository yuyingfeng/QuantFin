function option_price_BSM= BSM_price_calculator(S, r, q,T, K,sigma)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
tmp1=S.*exp(-q.*T);%PF col H
tmp2=S./K;%PF col I
tmp3=(log(S./K)+T.*(r-q+0.5*(sigma.^2)))./(sigma.*sqrt(T));%PF col J %d1
tmp4=tmp3-sqrt(T).*sigma;%PF col K %d2
tmp5=normcdf(tmp3,0,1);%PF col L
tmp6=normcdf(tmp4,0,1);%PF col M

option_price_BSM=tmp1.*tmp5-K.*exp(-r.*T).*tmp6;

end

