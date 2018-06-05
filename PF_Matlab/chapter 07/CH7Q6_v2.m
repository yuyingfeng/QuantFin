%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn
%  Description: using CH7Q4's results and extend CH7Q5's model, we demonstrate 
%  bivariate DCC-Garch(1,1) and its VaR DCC

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

tn_cvar=var(tn_returns);
for i=2:NN
    tn_cvar(i)=omega+alpha*(tn_returns(i-1)-theta*sqrt(tn_cvar(i-1)))^2+beta*tn_cvar(i-1);
end
tn_cvar=tn_cvar';
tn_z=tn_returns./sqrt(tn_cvar);

%%% -------------------------------------------------------
% Now we move to  Q6
clear theta
alpha=0.05;
beta=0.9;

theta0=[alpha,beta];
all_data=[sp_z,tn_z];
options=optimset('MaxFunEvals',100000000,'Maxiter',1000000000,'Display','iter','LargeScale','off');
[theta,likelihood_val]=fminsearch(@(theta)likfunc_dccgarch(theta,all_data),theta0)

alpha=theta(1);
beta=theta(2);

display('|----------------------CH7Q6 Estimated Results------------------|')
display(['|estimated alpha----------------|',num2str(theta(1)),'|'])
display(['|estimated beta----------------|',num2str(theta(2)),'|'])
display(['|Log likelihood-----------------|',num2str(-likelihood_val),'|'])

qdata(1,1)=1;
qdata(1,2)=corr(all_data(:,1),all_data(:,2));
qdata(1,3)=1;

cq1=qdata(1,1);%constant check PF's excel tabel--> F4
cq2=qdata(1,2);%constant check PF's excel tabel--> G4
cq3=qdata(1,3);%constant check PF's excel tabel--> H4

for j=2:length(all_data(:,1))
    qdata(j,1)=cq1+alpha*(all_data(j-1,1)^2-cq1)+beta*(qdata(j-1,1)-cq1);
    qdata(j,2)=cq2+alpha*(all_data(j-1,1)*all_data(j-1,2)-cq2)+beta*(qdata(j-1,2)-cq2);
    qdata(j,3)=cq3+alpha*(all_data(j-1,2)^2-cq3)+beta*(qdata(j-1,3)-cq3);
end
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

