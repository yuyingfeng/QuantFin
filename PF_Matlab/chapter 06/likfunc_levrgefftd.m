%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

%  Description:% computes maximum likelhood estimates for a GARCH(1,1) process give
% timeseries "log_return(:,1)" using function fminsearch

function loglik=likfunc_levrgefftd(phi,log_return)
%load PFQ1_1_result.mat
alpha=phi(1);
beta=phi(2);
omega=phi(3);
theta=phi(4);
dd = phi(5);

% retrieve length of return series
NN=length(log_return(:,1));
    denum=alpha*(1+theta^2)+beta;
% parameter restrictions: omega>0 alpha,beta>=0
 if omega<=0 || min(alpha,beta)<0||dd<=0||denum>1
        loglik=intmax;
 else
    cond_var(1)=var(log_return(:,1)); %initialize the first conditional variance
 % calculate squared returns
    log_return2=log_return.^2;
    for i=2:NN    
        cond_var(i)=omega+alpha*(log_return(i-1,1)-theta*sqrt(cond_var(i-1)))^2+beta*cond_var(i-1);
    end
    zs2=log_return2./cond_var';
    tmp1=sum(log(cond_var)/2);
    tmp2=gammaln((dd+1)/2)-gammaln(dd/2)-log(pi)/2-log(dd-2)/2-0.5*(1+dd)*log(1+zs2/(dd-2));
    loglik=-(sum(tmp2)-tmp1);
 end
    
   
end 