%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

%  Description:% computes maximum likelhood estimates for a GARCH(1,1) process give
% timeseries "log_return(:,2)" using function fminsearch

function loglik=likfunc_lambda(lambda,data)
%
qdata(1,1)=1;
qdata(1,2)=corr(data(:,1),data(:,2));
qdata(1,3)=1;

for j=2:length(data(:,1))
    qdata(j,1)=(1-lambda)*(data(j-1,1)^2)+lambda*qdata(j-1,1);
    qdata(j,2)=(1-lambda)*(data(j-1,1)*data(j-1,2))+lambda*qdata(j-1,2);
    qdata(j,3)=(1-lambda)*(data(j-1,2)^2)+lambda*qdata(j-1,3);    
end
sptn_rho=qdata(:,2)./sqrt(qdata(:,1).*qdata(:,3));

tmp1=log(1-sptn_rho.^2);
tmp2=data(:,1).^2+data(:,2).^2-2*sptn_rho.*data(:,1).*data(:,2);
tmp3=1-sptn_rho.^2;

loglik=0.5*sum(tmp1+tmp2./tmp3);

