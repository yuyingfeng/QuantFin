%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2016, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

%clear all
nums=readtable('CH6Q1.csv');
stk_prs=nums.Prices;
dd=nums.Date;

%initialized three parameters
vals(1)=0.07;%alpha
vals(2)=0.85;%beta
vals(3)=0.000005;%omega
vals(4)=0.5;%theta

[cvars,zs,log_rets,stock_params,likelihood_val] = NGarch11_yyf(stk_prs,dd,vals);
volatilities=sqrt(cvars);

d0=10; %initial d value
options=optimset('MaxFunEvals',100000,'Maxiter',100000,'Display','iter','LargeScale','off');
[d,likelihood_val]=fminsearch(@(d)likfunc_td(d,zs),d0);

display(['Estimated d=',num2str(d),'|| Log=Likelihood Value=-',num2str(likelihood_val)]);

%The statistical properties of Standardized Returns, zt
NN=length(zs);% num of obs
zs_mean=mean(zs); %mean
zs_std=std(zs);%std deviation
zs_skewness=skewness(zs);%skewness
zs_kurtosis= kurtosis(zs);% kurtosis

display('|--------------Statistical Properties-----------|')
display('|name---------------|mean-----|standard dev-|skewness|excess kurtosis|')
display(['|Standardized Return|',num2str(zs_mean),'|',num2str(zs_std),'|',num2str(zs_skewness),'|',num2str(zs_kurtosis-3),'|'])

d=11.2628734672119
clear zs
load zs_PFresults.mat
 td_quant=td_quantile(zs,d);
 
 [sorted_std_rets,ranking]=sort(zs);

hold on
grid on
scatter(td_quant,sorted_std_rets)
MMax=8;
MMin=-8;
plot(MMin:MMax,MMin:MMax)
title('QQ Plot of S&P500 NGARCH(1,1) Shocks Against the Standardized t-distribution');
xlabel('t(d) Quantitle');
ylabel('Return Quantitle');

