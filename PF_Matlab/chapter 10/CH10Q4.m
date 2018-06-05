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
sigma=0.01006356;
xi11=-4.9366195;
xi12=0;

option_price_GC= GC_price_calculator(St, rf, q,DTM,K,sigma,xi11,xi12);

theta0(1)=0.01;%sigma
theta0(2)=0; %xi11
theta0(3)=0;%xi12
[theta, MSE_GC, GC_prices ] = estimated_GC_theta(St,rf,q,DTM,K,theta0,OptionPrice);
