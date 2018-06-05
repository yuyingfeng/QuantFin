%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

clear all
close all

%using Q1_1's result
load PFQ1_1_result.mat

%LR represents 'log-return'
mean_LR=mean(log_return(:,2))
std_LR=std(log_return(:,2))
skws_LR=skewness(log_return(:,2))
kur_LR=kurtosis(log_return(:,2))-3;

scl=[-inf,-0.070:0.005:0.070,inf];
freq_num=histc(log_return(:,2),scl);

freq_num=freq_num(1:end-1);%the same as PF Q1_2 ColJ
freq_totalObs=freq_num/sum(freq_num);%the same as PF Q1_2 ColK
Norm_dist=normpdf(scl(1:end),mean_LR,std_LR)/sum(normpdf(scl(1:end-1),mean_LR,std_LR));
Norm_dist=Norm_dist(1:end-1);%ColL


%plot 
bar(freq_totalObs)
hold on
plot(Norm_dist,'r')
legend('Frequency','Normal');
