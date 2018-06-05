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

%load raw data
load raw_dataCH7_Q1Q4Q5Q6.mat

sp_returns=diff(log(Price_sp));%find log returns of SP500 %PF Col C
tn_returns=diff(log(Price_tnote));%find log returns of T-notes %PF Col D
NN=length(sp_returns);

%sp_cvar=SP500_Conditional_VARiance
sp_cvar=var(sp_returns); %initialize the first conditional variance

%initialized four parameters
alpha=0.05;
beta=0.80;
omega=0.0000015;
theta=1.25;

phi0=[alpha,beta,omega,theta];
options=optimset('MaxFunEvals',100000,'Maxiter',100000,'Display','iter','LargeScale','off');
[phi,likelihood_val]=fminsearch(@(phi)likfunc_levrgeff(phi,sp_returns),phi0);

alpha=phi(1);
beta=phi(2);
omega=phi(3);
theta=phi(4);

persistence=alpha*(1+theta^2)+beta;

format compact
display('|----------------------SP500 Results------------------|')
display('|-----Names---------------------|Values-----|')
display(['|initial alpha------------------|',num2str(phi0(1)),'|'])
display(['|initial beta-------------------|',num2str(phi0(2)),'|'])
display(['|initial omega------------------|',num2str(phi0(3)),'|'])
display(['|initial theta------------------|',num2str(phi0(4)),'|'])
display('|----------------------------------------------------|')
display(['|estimated alpha----------------|',num2str(phi(1)),'|'])
display(['|estimated beta-----------------|',num2str(phi(2)),'|'])
display(['|estimated omega----------------|',num2str(phi(3)),'|'])
display(['|estimated theta----------------|',num2str(phi(4)),'|'])
display(['|Log likelihood-----------------|',num2str(-likelihood_val),'|'])
display(['|Persistence--------------------|',num2str(persistence),'|'])



%initialized four parameters
alpha=0.03;
beta=0.97;
omega=0.000005;
theta=0.0000000000000000001; %for some reasons, we can not set initial theta to 0.

phi0=[alpha,beta,omega,theta];
options=optimset('MaxFunEvals',100000000,'Maxiter',1000000000,'Display','iter','LargeScale','off');
[phi,likelihood_val]=fminsearch(@(phi)likfunc_levrgeff(phi,tn_returns),phi0);

alpha=phi(1);
beta=phi(2);
omega=phi(3);
theta=phi(4);

persistence=alpha*(1+theta^2)+beta;

display('|----------------------T-notes Results------------------|')
display('|-----Names---------------------|Values-----|')
display(['|initial alpha------------------|',num2str(phi0(1)),'|'])
display(['|initial beta-------------------|',num2str(phi0(2)),'|'])
display(['|initial omega------------------|',num2str(phi0(3)),'|'])
display(['|initial theta------------------|',num2str(phi0(4)),'|'])
display('|----------------------------------------------------|')
display(['|estimated alpha----------------|',num2str(phi(1)),'|'])
display(['|estimated beta-----------------|',num2str(phi(2)),'|'])
display(['|estimated omega----------------|',num2str(phi(3)),'|'])
display(['|estimated theta----------------|',num2str(phi(4)),'|'])
display(['|Log likelihood-----------------|',num2str(-likelihood_val),'|'])
display(['|Persistence--------------------|',num2str(persistence),'|'])
