%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

clear all;
close all;

load PFQ1_1_raw_data.mat

%%%I will explain what does that mean in my class-yyf
cc=693960;

%transform to matlab data formate
tmp(:,1)=PFQ1_1_raw_data(:,1)+cc;
tmp(:,2)=PFQ1_1_raw_data(:,2);
%test
datestr(tmp(end,1));
if tmp(end,1)~=datenum('31-Dec-2010')
    'wrong'
else
    'right'
end
%test end

raw_data(1,:)=tmp(1,:);
n=2;
for i=2:length(tmp(:,1))
    if tmp(i,2)~=tmp(i-1,2)
        raw_data(n,:)=tmp(i,:);
        n=n+1;
    else
    end
end
%raw_data has the exact same result as PF excel's column P

%calculate log return


log_return(:,1)=raw_data(2:end,1); % date info, discarding the first date 
log_return(:,2)=diff(log(raw_data(:,2)));

%plot close price and log return
subplot(2,1,1)
%plot SP500
plot(raw_data(:,2));
grid on
N=length(raw_data(:,1));
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(raw_data(1:intval:N,:),11))
title('SP 500 prices')
legend('SP500 price'); 

subplot(2,1,2)
%plot sp500 log return
plot(log_return(:,2));
grid on
N=length(log_return(:,1));
intval=360;%interval, set as 1 year
xlim([0 N]);
set(gca,'XTick',[1:intval:N])
set(gca,'XTickLabel',datestr(log_return(1:intval:N,:),11))
title('SP 500 log return')
legend('SP500 log return'); 

save 'PFQ1_1_result.mat' log_return raw_data

