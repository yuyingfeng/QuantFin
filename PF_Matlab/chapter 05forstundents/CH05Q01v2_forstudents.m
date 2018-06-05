clear all
close all
load dataCH05Q01.mat

Rt_square=dataCH05Q01(:,2).^2;
Vola=dataCH05Q01(:,3);
const=1;
[b, tstat, s2, vcv, vcvwhite, R2, Rbar, yhat] = ols(Rt_square,Vola,const);
len=length(Vola);
X=[ones(len,1),Vola];
results=fols(Rt_square,X);

display('Display Coefficients')
results.beta

display('Show Standard Errors')
standard_errors=results.beta./results.tstat;

display('Show R_squared')
results.rbar



