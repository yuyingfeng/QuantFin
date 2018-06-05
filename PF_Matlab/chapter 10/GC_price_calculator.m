function option_price_GC= GC_price_calculator(S, r, q,T, K,sigma,xi11,xi12)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%check PF textbook
tmp1=S.*exp(-q.*T);%PF col H
tmp2=S./K;%PF col I
tmp3=(log(S./K)+T.*(r-q+0.5*(sigma^2)))./(sigma.*sqrt(T));%PF col J %d1

tmp4=tmp3-sqrt(T).*sigma;%PF col K %d2

tmp5=normcdf(tmp3,0,1);%PF col L

tmp6=normcdf(tmp4,0,1);%PF col M
tmp7=normpdf(tmp3,0,1);%PF col N

tmpX1=xi11*(2*sqrt(T).*sigma-tmp3)/6;

tmpX2=xi12*(1-tmp3.^2+3*tmp3.*sqrt(T).*sigma-3*T.*(sigma.^2))./(24*sqrt(T));
option_price_BSM=tmp1.*tmp5-K.*exp(-r.*T).*tmp6;

option_price_GC=option_price_BSM+tmp1.*tmp7.*sigma.*(tmpX1-tmpX2);


end

