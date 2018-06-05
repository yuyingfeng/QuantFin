%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

clear 
close
nums=readtable('Q1Q3.csv');
SP_prs=nums.Close;
prs_date=nums.Date;
clear nums
lambda=0.94;
%from PF's colume D and E, RiskMetrics(1,1)
[cvars1,zs1,log_rets1] = RiskMetrics_noEstm(SP_prs,lambda);

%from PF's colume F and G, NGARCH(1,1)
params=[0.0544581;0.8347475;1.714e-6;1.3738769];
[cvars2,zs2,log_rets2] = NGarch11_noEstm(SP_prs,params);

%Last Day Values of sigam_t
RiskMetrics_lastday_sigma_t=sqrt(cvars1(end));
NGarch11_lastday_sigma_t=sqrt(cvars2(end));

sigma0=NGarch11_lastday_sigma_t;
dd=10;
nn=10000;
indictor=0;
[simu_cvars,simu_log_rets] = NGarch11_simulation(sigma0, params,dd, nn,indictor);

[fhs_cvars,fhs_return] = FHSNGarch_simulation(sigma0, zs2, params,dd, nn, indictor);
%10-day return NGARCH11
TenDayReturn=sum(simu_log_rets,2)*100;

%10-day return FHS NGARCH11
TenDayReturnFHS=sum(fhs_return,2)*100;

%100 Largetst Losses NGARCH 11
tmp2=sort(TenDayReturn);
OneHundredLargestLosses=tmp2(1:100);

%100 Largetst Losses FHS NGARCH
tmp3=sort(TenDayReturnFHS);
OneHundredLargestLossesFHS=tmp3(1:100);

%1%VaRs
pp=0.01;
VaR_RiskMetrics=-100*sqrt(dd)*norminv(pp,0,1)*RiskMetrics_lastday_sigma_t
VaR_MonteCarlo=-prctile(TenDayReturn,1-pp)
VaR_FHS=-prctile(TenDayReturnFHS,1-pp)

%1%ES
ES_RiskMetrics=100*sqrt(dd)*RiskMetrics_lastday_sigma_t*normpdf(norminv(pp,0,1),0,1)/pp
ES_MonteCarlo=-mean(OneHundredLargestLosses)
ES_FHS=-mean(OneHundredLargestLossesFHS)

