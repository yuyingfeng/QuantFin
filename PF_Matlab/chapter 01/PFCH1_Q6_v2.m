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

N=100; %as the question request
NN=length(log_return(:,2));


cond_var=var(log_return(:,2)); %initialize the first conditional variance
cond_std=sqrt(cond_var);

beta=0.94;
alpha=1-beta;

for i=2:NN
    cond_var(i)=beta*cond_var(i-1)+alpha*(log_return(i-1,2)^2);
    %cond_std(i)=sqrt(cond_var(i));
end
%condition variance in PF Q1_5 and Q1_6 colE
cond_std=sqrt(cond_var); 
cond_std=cond_std';
stdzed_return=log_return(1:end,2)./cond_std;




display('|--------------Statistical Properties-----------|')
display('|name---------------|mean-----|standard dev-|skewness|excess kurtosis|')
display(['|RAW----------------|',num2str(mean(log_return(:,2))),'|',num2str(std(log_return(:,2))),'|',num2str(skewness(log_return(:,2))),'|',num2str(kurtosis(log_return(:,2))-3),'|'])
display(['|Standardized Return|',num2str(mean(stdzed_return)),'|',num2str(std(stdzed_return)),'|',num2str(skewness(stdzed_return)),'|',num2str(kurtosis(stdzed_return)-3),'|'])
