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
format long;
nums=readtable('CH10Q1.csv');
St=nums.S_t_ ;
rf=nums.r;
q=nums.q;
DTM=nums.DTM;
K=nums.X;
OptionPrice=nums.OptionPrice;

sigm=0.009799;
BSM.tmp1=St.*exp(-q.*DTM);%PF col H
BSM.tmp2=St./K;%PF col I
BSM.tmp3=(log(St./K)+DTM.*(rf-q+0.5*(sigm^2)))./(sigm.*sqrt(DTM));%PF col J
BSM.tmp4=BSM.tmp3-sqrt(DTM).*sigm;%PF col K
BSM.tmp5=normcdf(BSM.tmp3,0,1);%PF col L
BSM.tmp6=normcdf(BSM.tmp4,0,1);%PF col M
BSM.price=BSM.tmp1.*BSM.tmp5-K.*exp(-rf.*DTM).*BSM.tmp6;


sigma0=0.01;
[sigma, MSE, BSM_prices ] = estimated_BSM_sigma(St,rf,q,DTM,K,sigma0,OptionPrice);

display('|--------------------------Results------------------|')

display(['|initial sigma------------------|',num2str(sigma0),'|'])
display(['|estimated sigma-------------------|',num2str(sigma),'|'])
display(['|Mean Squared Pricing Error------------------|',num2str(MSE),'|'])

%%%%CH10Q2
LL=45;
Moneyness_44=BSM.tmp2(1:LL);
PriceingErr_44=-BSM.price(1:LL)+OptionPrice(1:LL);

Moneyness_71=BSM.tmp2(LL+1:LL+29);
PriceingErr_71=-BSM.price(LL+1:LL+29)+OptionPrice(LL+1:LL+29);

Moneyness_99=BSM.tmp2(75:90);
PriceingErr_99=-BSM.price(75:90)+OptionPrice(75:90);

Moneyness_162=BSM.tmp2(end-11:end);
PriceingErr_162=-BSM.price(end-11:end)+OptionPrice(end-11:end);
figure
hold on
grid on
plot(Moneyness_44,PriceingErr_44,'.-')
plot(Moneyness_71,PriceingErr_71,'r.-')
plot(Moneyness_99,PriceingErr_99,'g.-')
plot(Moneyness_162,PriceingErr_162,'c.-')
title('Pricing Error vs Moneyness for Different Maturities')
legend('DTM=43','DTM=71','DTM=99','DTM=162')
xlabel('Moneyness');
ylabel('Pricing Error');
hold off

%%CH10Q3
initial_IV=0.01;
for i=1:length(St)
    [imp_vol(i), MSE(i), BSM_p(i) ] = estimated_BSM_sigma(St(i),rf(i),q(i),DTM(i),K(i),initial_IV,OptionPrice(i));
end
imp_vol=imp_vol';%daily, check PF col R
MSE=MSE';
BSM_p=BSM_p';

yearly_imp_vol=sqrt(365)*imp_vol;

display('|---------------CH10Q3------Results------------------|')
display(['|Mean Squared Pricing Error------------------|',num2str(sum(MSE)),'|'])

figure
hold on
grid on
impvol_44=imp_vol(1:LL);
impvol_71=imp_vol(LL+1:LL+29);
impvol_99=imp_vol(75:90);
impvol_162=imp_vol(end-11:end);

plot(Moneyness_44,impvol_44,'.-')
plot(Moneyness_71,impvol_71,'r.-')
plot(Moneyness_99,impvol_99,'g.-')
plot(Moneyness_162,impvol_162,'c.-')
title('Daily Volatilites vs Moneyness for Different Maturities')
legend('DTM=43','DTM=71','DTM=99','DTM=162')
xlabel('Daily Volatilites');
ylabel('Pricing Error');
hold off

%%%------------Q5
YY=imp_vol;
x0=ones(length(St),1);
x1=St./K;
x2=x1.^2;
x3=DTM/365;
x4=x3.^2;
x5=x1.*x3;
XX=[x0,x1,x2,x3,x4,x5];

const=0;
[b, tstat, s2, vcv, vcvwhite, R2, Rbar, yhat] = ols(YY,XX,const);
yhat=max(yhat,0.0001);
BSM_IVF_prices= BSM_price_calculator(St, rf, q,DTM, K,yhat);%PF Col AC
Sqaured_Pricing_Error=(BSM_IVF_prices-OptionPrice).^2;%PF Col AD
MSE=mean(Sqaured_Pricing_Error); %PF Col AF

%%Q6
alpha0=b;
[alpha, MIVF_MSE, MIVF_prices ] = estimated_MIVF(St,rf,q,DTM,K,alpha0,OptionPrice);


%%Q7
LL=45;
%Moneyness_44=BSM.tmp2(1:LL);
PriceingErr_44=-MIVF_prices(1:LL)+OptionPrice(1:LL);

%Moneyness_71=BSM.tmp2(LL+1:LL+29);
PriceingErr_71=-MIVF_prices(LL+1:LL+29)+OptionPrice(LL+1:LL+29);

%Moneyness_99=BSM.tmp2(75:90);
PriceingErr_99=-MIVF_prices(75:90)+OptionPrice(75:90);

%Moneyness_162=BSM.tmp2(end-11:end);
PriceingErr_162=-MIVF_prices(end-11:end)+OptionPrice(end-11:end);
figure
hold on
grid on
%PF's answer is wrong, the negative sign
plot(Moneyness_44,-PriceingErr_44,'.-')
plot(Moneyness_71,-PriceingErr_71,'r.-')
plot(Moneyness_99,-PriceingErr_99,'g.-')
plot(Moneyness_162,-PriceingErr_162,'c.-')
title('MIVF Pricing Error vs Moneyness for Different Maturities')
legend('DTM=43','DTM=71','DTM=99','DTM=162')
xlabel('Moneyness');
ylabel('Pricing Error');
hold off
