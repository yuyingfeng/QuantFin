function [fhs_cvars,fhs_return] = FHSNGarch_simulation(sigma0, zs, params,dd, nn, indictor)
% FHS NGarch11 simulation based on PF's excel results
% Input: sigma0- initial volatility
%           params-parameters
%           dd - days we want to simulate
%           NN -Monte_Carlo Simulations' time
%           indictor: when indictor=0, using PF's RND table
%                         when indictor=1, let computer samples RND shocks
% OutPut: fhs_cvars: volatilites
%               fhs_return : FHS returns
if length(params)~=4
    display('Not enough parameters... ')
    return
else
    alpha=params(1);
    beta=params(2);
    omega=params(3);
    theta=params(4);
end

if indictor ==0
    tmp=readtable('FHSRNDSHOCKS_table.csv');
    fhsrndshocks=table2array(tmp);
else
        fhsrndshocks=length(2517)*abs(randn(nn,dd));%not confirm
end

    alpha=params(1);
    beta=params(2);
    omega=params(3);
    theta=params(4);
    
for i=1:dd
    fhs_std_rets(:,i)=zs(fhsrndshocks(:,i));
    
    if i==1
    fhs_return(:,i)=sigma0*fhs_std_rets(:,i);
    fhs_cvars(:,i)=omega+alpha*((fhs_return(:,i)-theta*sigma0).^2)+beta*(sigma0^2);
    else
    fhs_return(:,i)=fhs_std_rets(:,i).*sqrt(fhs_cvars(:,i-1));
    fhs_cvars(:,i)= omega+alpha*((fhs_return(:,i)-theta*sqrt(fhs_cvars(:,i-1))).^2)+beta*fhs_cvars(:,i-1);      
    end    
end
end

