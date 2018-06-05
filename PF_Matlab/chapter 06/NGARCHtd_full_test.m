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

%initialized three parameters
vals(1)=0.07;%alpha
vals(2)=0.85;%beta
vals(3)=0.000005;%omega
vals(4)=0.5;%theta
vals(5)=10;

[cvars,zs,log_rets,stock_params,likelihood_val] = NGarch11td_yyf(stk_prs,dd,vals);

%Using the estimated NGARCH11-td to calculate zs
NN=length(zs);% num of obs
zs_mean=mean(zs); %mean
zs_std=std(zs);%std deviation
zs_skewness=skewness(zs);%skewness
zs_kurtosis= kurtosis(zs);% kurtosis
% 
display('|--------------Statistical Properties-----------|')
display('|name---------------|mean-----|standard dev-|skewness|excess kurtosis|')
display(['|Standardized Return|',num2str(zs_mean),'|',num2str(zs_std),'|',num2str(zs_skewness),'|',num2str(zs_kurtosis-3),'|'])

d=stock_params(5);
td_quant=td_quantile(zs,d);
%  
[sorted_std_rets,ranking]=sort(zs);

%calculate VaR 
pp=0.01;
VaR_vals = VaR_td(sqrt(cvars),d,pp);
ES_vals= ES_td(sqrt(cvars),d,pp);
plot(log(VaR_vals));
hold on
plot(log(ES_vals));
legend('ln(VaR)','ln(ES)')

% 
figure
subplot(2,1,1)
hold on
grid on
scatter(td_quant,sorted_std_rets)
MMax=8;
MMin=-8;
plot(MMin:MMax,MMin:MMax)
title('QQ Plot of S&P500 NGARCH(1,1) Shocks Against the Standardized t-distribution');
xlabel('t(d) Quantitle');
ylabel('Return Quantitle');
% 
subplot(2,1,2)
N=100; %100 lags
acf_zs=autocorr(zs,N);
acf_LR=acf_zs(2:end);

plot(acf_LR)
title('ACF of Standardized Return z_t')
grid on

