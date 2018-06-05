%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn
%  Description: demonstrate how to use ML to estimate Garch model's
%               parameters. This is a garch model includin explainary
%               variable which is VIX index.

clear all
close all

%using Q1_1's result
load PFQ1_1_result.mat
load vix_Q4_3.mat %when I perpare this data I dont include date info, 
%this dataset shares the same data info as log_return

NN=length(log_return(:,2));

cond_var=var(log_return(:,2)); %initialize the first conditional variance

%initialized five parameters
alpha=0.04;
beta=0.5;
omega=0.000005;
theta=2.0;
gamma=0.07
phi0=[alpha,beta,omega,theta,gamma];
options=optimset('MaxFunEvals',100000,'Maxiter',100000,'Display','iter','LargeScale','off');
[phi,likelihood_val]=fminsearch(@(phi)likfunc_vix(phi,log_return,vix),phi0);

%be careful, you will realize that the estimated results here are not
%the exactly same as PF's results....The discrepancy comes from the numerical errors 
%because different soft wares using different optimal routine algorithms 

alpha=phi(1);
beta=phi(2);
omega=phi(3);
theta=phi(4);
gamma=phi(5);
for i=2:NN
        cond_var(i)=omega+alpha*(log_return(i-1,2)-theta*sqrt(cond_var(i-1)))^2+beta*cond_var(i-1)+gamma*(vix(i-1)^2)/252;
end
 cond_std=sqrt(cond_var);
 persistence=alpha*(1+theta^2)+beta;
 
 
display('|--------------------------Results------------------|')
display('|-----Names---------------------|Values-----|')
display(['|initial alpha------------------|',num2str(phi0(1)),'|'])
display(['|initial beta-------------------|',num2str(phi0(2)),'|'])
display(['|initial omega------------------|',num2str(phi0(3)),'|'])
display(['|initial theta------------------|',num2str(phi0(4)),'|'])
display(['|initial gamma------------------|',num2str(phi0(5)),'|'])
display('|----------------------------------------------------|')
display(['|estimated alpha----------------|',num2str(phi(1)),'|'])
display(['|estimated beta-----------------|',num2str(phi(2)),'|'])
display(['|estimated omega----------------|',num2str(phi(3)),'|'])
display(['|estimated theta----------------|',num2str(phi(4)),'|'])
display(['|estimated gamma----------------|',num2str(phi(5)),'|'])
display(['|Log likelihood-----------------|',num2str(-likelihood_val),'|'])
display(['|Persistence--------------------|',num2str(persistence),'|'])

 log_return2=log_return.^2; %PF Q4_2 col J
 z2=log_return2(:,2)./cond_var'; %PF Q4_2 col K
 z=log_return(:,2)./sqrt(cond_var');
 [h,p,jbstat,critval] = jbtest(z) %z is not a norm dist, if norm jbtest=1.1676
 
 N=100; %100 lag order 
 acf_LR2=autocorr(log_return2(:,2),N);
 acf_LR2=acf_LR2(2:end);%discard log 0 which always equals to ONE
 
 acf_z2=autocorr(z2,N);
 acf_z2=acf_z2(2:end);%discard log 0 which always equals to ONE
 

plot(acf_LR2)
hold on
plot(acf_z2,'r') %show curve in red 
grid on
legend('Autocorrelation of Squared Returns','Autocorr of Squared Shocks(VIX-NGARCH)')
ylabel('Autocorrelations');
xlabel('Lag Order');
title(' PF CH4Q3')