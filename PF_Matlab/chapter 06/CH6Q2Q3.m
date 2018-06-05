%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2016, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

clear 
close 
nums=readtable('CH6Q1.csv');
stk_prs=nums.Prices;
dd=nums.Date;
%log_rets=diff(log(stk_prs)); %find log-returns

%initialized three parameters
vals(1)=0.07;%alpha
vals(2)=0.85;%beta
vals(3)=0.000005;%omega
vals(4)=0.5;%theta

[cvars,zs,log_rets,stock_params,likelihood_val] = NGarch11_yyf(stk_prs,dd,vals);
volatilities=sqrt(cvars);

display('|-----------Estimated NGarch parameters Results------------------|')
display('|-----Names---------------------|Values-----|')
display(['|initial alpha------------------|',num2str(vals(1)),'|'])
display(['|initial beta-------------------|',num2str(vals(2)),'|'])
display(['|initial omega------------------|',num2str(vals(3)),'|'])
display(['|initial theta------------------|',num2str(vals(4)),'|'])
 
display('|----------------------------------------------------|')
display(['|estimated alpha----------------|',num2str(stock_params(1)),'|'])
display(['|estimated beta-----------------|',num2str(stock_params(2)),'|'])
display(['|estimated omega----------------|',num2str(stock_params(3)),'|'])
display(['|estimated theta------------------|',num2str(stock_params(4)),'|'])
display(['|Log likelihood-----------------|',num2str(-likelihood_val),'|'])

%The statistical properties of Standardized Returns, zt
NN=length(zs);% num of obs
zs_mean=mean(zs); %mean
zs_std=std(zs);%std deviation
zs_skewness=skewness(zs);%skewness
zs_kurtosis= kurtosis(zs);% kurtosis

display('|--------------Statistical Properties-----------|')
display('|name---------------|mean-----|standard dev-|skewness|excess kurtosis|')
display(['|Standardized Return|',num2str(zs_mean),'|',num2str(zs_std),'|',num2str(zs_skewness),'|',num2str(zs_kurtosis-3),'|'])

subplot(3,1,1)
qqplot(zs)
title('QQ Plot of S&P500 Returns with NGarch(1,1) Shocks')

subplot(3,1,2)
%Test VaR and ES when zt assumes as N(0,1)
pp=0.01;
%the following two formulas coming from
% Chinese version textbook P.27
VaR_vals=VaR_norm(volatilities,pp);
ES_vals=ES_norm(volatilities,pp);
plot(VaR_vals);
hold on
plot(ES_vals);
legend('VaR','ES')
title('Normal VaR and ES')

subplot(3,1,3)
%Test VaR and ES when zt assumes as t(0,1)
pp=0.01;
d=11.26;
VaR_vals = VaR_td(volatilities,d,pp);
ES_vals= ES_td(volatilities,d,pp);
plot(VaR_vals);
hold on
plot(ES_vals);
legend('VaR','ES')
title('t(d) VaR and ES')

VaRtd_vs_VaRnorm=sqrt((d-2)/d)*tinv(pp,d)/norminv(pp);
display(['VaR t(d)/ VaR norm=',num2str(VaRtd_vs_VaRnorm)]);
