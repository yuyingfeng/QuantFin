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
%condition variance in PF Q1_5 colD
cond_std=sqrt(cond_var);
%it is possible to apply loop aviodance method to enhance the program
%efficiency(sorry frogs, I havent have time to include it)
%be careful, generally, loops are slow. Loop method is not good style 
%for design efficient programming in matalb.

cond_date=log_return(2:end,1);
plot(cond_std)

grid on
NNN=length(cond_date);
intval=360;%interval, set as 1 year
xlim([0 NNN]);
set(gca,'XTick',[1:intval:NNN])
set(gca,'XTickLabel',datestr(cond_date(1:intval:NNN,1),26))
title('Conditional STD ')

