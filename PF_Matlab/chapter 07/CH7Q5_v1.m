%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn
%  Description: using CH7Q4's results to demonstrate dynamic correlations
%  and VaR DCC

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

sp_cvar=var(sp_returns);
for i=2:NN
    sp_cvar(i)=omega+alpha*(sp_returns(i-1)-theta*sqrt(sp_cvar(i-1)))^2+beta*sp_cvar(i-1);
end
sp_cvar=sp_cvar';
sp_z=sp_returns./sqrt(sp_cvar);

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

% now we work on Q5

tn_cvar=var(tn_returns);
for i=2:NN
    tn_cvar(i)=omega+alpha*(tn_returns(i-1)-theta*sqrt(tn_cvar(i-1)))^2+beta*tn_cvar(i-1);
end
tn_cvar=tn_cvar';
tn_z=tn_returns./sqrt(tn_cvar);

lambda0=0.94;
all_data=[sp_z,tn_z];
options=optimset('MaxFunEvals',100000000,'Maxiter',1000000000,'Display','iter','LargeScale','off');
[lambda,likelihood_val]=fminsearch(@(lambda)likfunc_lambda(lambda,all_data),lambda0);

display('|----------------------CH7Q5 Estimated Results------------------|')
display(['|estimated lambda----------------|',num2str(lambda),'|'])
display(['|Log likelihood-----------------|',num2str(-likelihood_val),'|'])


qdata(1,1)=1;
qdata(1,2)=corr(all_data(:,1),all_data(:,2));
qdata(1,3)=1;

for j=2:length(all_data(:,1))
    qdata(j,1)=(1-lambda)*(all_data(j-1,1)^2)+lambda*qdata(j-1,1);
    qdata(j,2)=(1-lambda)*(all_data(j-1,1)*all_data(j-1,2))+lambda*qdata(j-1,2);
    qdata(j,3)=(1-lambda)*(all_data(j-1,2)^2)+lambda*qdata(j-1,3);    
end

%dynamic correlations of two financial assets which are SP500 logreturns
%and T-notes log returns
sptn_rho=qdata(:,2)./sqrt(qdata(:,1).*qdata(:,3));

%Vat-at-Risk of SP500 and T-notes
VaR_DCC=-norminv(0.01)*(0.5)*sqrt(sp_cvar+tn_cvar+2*sptn_rho.*sqrt(sp_cvar.*tn_cvar));
subplot(2,1,1)
plot(VaR_DCC)
grid on
ndd=dd(2:end); %dd represents date info, VaR_DCC and dynanic rho are both based on log-return scale.
%it means that we have to discard the first date of dd.
N=length(ndd(1:end,1));
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(ndd(1:intval:N,:),1))
title('VaR DCC')
legend('VaR DCC'); 
xlabel('Return Date');
ylabel('VaR DCC');


subplot(2,1,2)
plot(sptn_rho)
grid on
N=length(ndd(1:end,1));
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(ndd(1:intval:N,:),1))
title('Dynamic Correlations')
legend('rho'); 
xlabel('Return Date');
ylabel('Correlations');

