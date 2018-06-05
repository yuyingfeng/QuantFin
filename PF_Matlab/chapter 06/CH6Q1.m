%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2016, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

clear all
nums=readtable('CH6Q1.csv');
stk_prs=nums.Prices;
dates=nums.Date;
log_rets=diff(log(stk_prs)); %find log-returns

NN=length(log_rets);% num of obs
rets_mean=mean(log_rets); %mean
rets_std=std(log_rets);%std deviation
rets_skewness=skewness(log_rets);%skewness
rets_kurtosis= kurtosis(log_rets);% kurtosis

Normalized_rets=log_rets/rets_std;
[sorted_std_rets,ranking]=sort(Normalized_rets);

tmp1=1:NN;
tmp2=(tmp1-0.5)/NN;
Normal_Quantile=norminv(tmp2,0,1);

subplot(2,1,1)
hold on
grid on
scatter(Normal_Quantile,sorted_std_rets)
MMax=8;
MMin=-8;
plot(MMin:MMax,MMin:MMax)
title('Manually QQ Plot of S&P500 Returns');
xlabel('Normal Quantitle');
ylabel('Return Quantitle');

subplot(2,1,2)
qqplot(Normalized_rets)
title('QQ Plot of S&P500 Returns by Matlab');