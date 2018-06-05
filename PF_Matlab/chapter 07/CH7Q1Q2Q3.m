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


nums=readtable('CH7Q1Q2Q3.csv');
SP_prs=nums.SP500ClosedPrices;
TN_prs=nums.USTNoteClosedPrices;
log_SPrets=diff(log(SP_prs)); %find SP500 log-returns
log_TNrets=diff(log(TN_prs)); %find 10-yr T-notes log-returns

cc=693960;
MatlabDateFMT=nums.Date+cc;
subplot(2,1,1)
hold on
grid on
plot(log_SPrets);
title('S&P 500 log-returns')
%reformat x-axis to the right time-horizon
N=length(MatlabDateFMT);
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(MatlabDateFMT(1:intval:N,:),11))

subplot(2,1,2)
hold on
grid on
plot(log_TNrets);
title('US Treasury Note log-returns')
%reformat x-axis to the right time-horizon
N=length(MatlabDateFMT);
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(MatlabDateFMT(1:intval:N,:),11))

correlation_result=corr(log_TNrets,log_SPrets)
covariance_result=corr(log_TNrets,log_SPrets)*std(log_TNrets)*std(log_SPrets)

pp=1/100;
%VaR_SP500=-norminv(pp,0,1)*std(log_SPrets)*0.5
%VaR_TN=-norminv(pp,0,1)*std(log_TNrets)*0.5

