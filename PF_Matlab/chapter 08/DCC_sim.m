function [avg_sim_corr, q11,q12,q22,rho12] = DCC_sim( alpha, beta, uncond_var, rho0,dd,nn, indicator )
%DCC simulation 
%  Chech PF's CH8Q4
if indicator==0
    tmp=readtable('DCCSHOCKS1.csv');
    z_tlide1=table2array(tmp);
    clear tmp
    tmp=readtable('DCCSHOCKS2.csv');
    z_tlide2=table2array(tmp);
    clear tmp
else
    z_tlide1=randn(nn, dd);
    z_tlide2=randn(nn, dd);
end
    

for i=1:dd
    if i==1
        q11(:,i)=(1-alpha-beta)+alpha*(z_tlide1(:,i).^2)+beta*1;
        q12(:,i)=(1-alpha-beta)*uncond_var+alpha*z_tlide1(:,i).*z_tlide2(:,i)+beta*rho0;
        q22(:,i)=(1-alpha-beta)+alpha*(z_tlide2(:,i).^2)+beta*1;
        rho12(:,i)=q12(:,i)./(sqrt(q11(:,i).*q22(:,i)));
    else
         q11(:,i)=(1-alpha-beta)+alpha*(z_tlide1(:,i).^2)+beta*q11(:,i-1);
         q12(:,i)=(1-alpha-beta)*uncond_var+alpha*z_tlide1(:,i).*z_tlide2(:,i)+beta*q12(:,i-1);
         q22(:,i)=(1-alpha-beta)+alpha*(z_tlide2(:,i).^2)+beta*q22(:,i-1);
         rho12(:,i)=q12(:,i)./(sqrt(q11(:,i).*q22(:,i)));
    end
end

%average simulated correlation
avg_sim_corr=rho0;
avg_sim_corr(2:dd+1,1)=mean(rho12,1)';



end

