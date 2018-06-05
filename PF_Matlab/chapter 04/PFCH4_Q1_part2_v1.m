%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn
%  Description: demonstrate how to use ML to estimate Garch(1,1) model's
%               parameters

clear all
close all

%using Q1_1's result
load PFQ1_1_result.mat

NN=length(log_return(:,2));

cond_var=var(log_return(:,2)); %initialize the first conditional variance

%initialized two parameters
alpha=0.1;
beta=0.85;

theta0=[alpha,beta];
omega0=var(log_return(:,2))*(1-alpha-beta);
options=optimset('MaxFunEvals',10000,'Maxiter',10000,'Display','iter','LargeScale','off');
[theta,likelihood_val]=fminsearch(@(theta)likfunc_vartarg(theta,log_return),theta0);

%Generally speaking, you will realize that the estimated results here are not
%the exactly same as PF's results....The discrepancy comes from the numerical errors 
%because different soft wares using different optimal routine algorithms 
%Luckily, this question we obtain the exact same results as PF's does.

alpha=theta(1);
beta=theta(2);
omega=var(log_return(:,2))*(1-alpha-beta)
for i=2:NN
    cond_var(i)=omega+beta*cond_var(i-1)+alpha*(log_return(i-1,2)^2);
end
 cond_std=sqrt(cond_var);
 persistence=alpha+beta ;
 
 display('|--------------------------Results------------------|')
display('|-----Names---------------------|Values-----|')
display(['|initial alpha------------------|',num2str(theta0(1)),'|'])
display(['|initial beta-------------------|',num2str(theta0(2)),'|'])
display(['|initial omega------------------|',num2str(omega0),'|'])
display('|----------------------------------------------------|')
display(['|estimated alpha----------------|',num2str(theta(1)),'|'])
display(['|estimated beta-----------------|',num2str(theta(2)),'|'])
display(['|estimated omega----------------|',num2str(omega),'|'])
display(['|Log likelihood-----------------|',num2str(-likelihood_val),'|'])
display(['|Persistence--------------------|',num2str(persistence),'|'])
