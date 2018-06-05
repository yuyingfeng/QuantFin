%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2016, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

dd=10;%the length of simulation days
nn=10000;%the number of monte carlo sim times
alpha=0.0676077250447349;
beta=0.895472849691596;
uncond_var=-0.306838867178967;
rho0=0.5;

indicator=0;
[avg_sim_corr, q11,q12,q22,rho12] = DCC_sim( alpha, beta, uncond_var, rho0,dd,nn, indicator );
%comfirm the results shown in PF' CH8Q4 Column E3:E13 and F3:F13
avg_sim_corr

%comfirm the results shown in PF's CH8Q4 B15:F27
%rho0=[-0.5,-0.25,0.25,0.5];
rho0=[-1:0.01:1];
for i=1:length(rho0)
    [avg_sim_corr(:,i), q11,q12,q22,rho12] = DCC_sim( alpha, beta, uncond_var, rho0(i),dd,nn, indicator );
end
hold on
grid on
plot(1:dd+1,avg_sim_corr);
xlabel('Horizon')
ylabel('Correlation')
%legend('-0.50','-0.25','0.25','0.5')