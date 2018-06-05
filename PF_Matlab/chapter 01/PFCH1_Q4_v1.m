%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

clear all
close all

%using Q1_1's result
load PFQ1_1_result.mat

N=100; %as the question request

acf_LR=autocorr((log_return(:,2).^2),N);
acf_LR=acf_LR(2:end);

plot(acf_LR)
grid on
