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

function loglik=dccgarch(theta,data)
%
alpha=theta(1);
beta=theta(2);
qdata(1,1)=1;
qdata(1,2)=corr(data(:,1),data(:,2));
qdata(1,3)=1;

cq1=qdata(1,1);%a constant term check PF's excel tabel--> F4
cq2=qdata(1,2);%a constant term check PF's excel tabel--> G4
cq3=qdata(1,3);%a constant term check PF's excel tabel--> H4

for j=2:length(data(:,1))
    qdata(j,1)=cq1+alpha*(data(j-1,1)^2-cq1)+beta*(qdata(j-1,1)-cq1);
    qdata(j,2)=cq2+alpha*(data(j-1,1)*data(j-1,2)-cq2)+beta*(qdata(j-1,2)-cq2);
    qdata(j,3)=cq3+alpha*(data(j-1,2)^2-cq3)+beta*(qdata(j-1,3)-cq3);
end
sptn_rho=qdata(:,2)./sqrt(qdata(:,1).*qdata(:,3));

tmp1=log(1-sptn_rho.^2);
tmp2=data(:,1).^2+data(:,2).^2-2*sptn_rho.*data(:,1).*data(:,2);
tmp3=1-sptn_rho.^2;
loglik=0.5*sum(tmp1+tmp2./tmp3);
   