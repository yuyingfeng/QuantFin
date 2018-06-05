function [cvars,log_rets] = NGarch11_simulation(sigma0, params,dd, nn, indictor)
% NGarch11 simulation based on PF's excel results
% Input: sigma0- initial volatility
%           params-parameters
%           dd - days we want to simulate
%           NN -Monte_Carlo Simulations' time
%           indictor: when indictor=0, using PF's RND table
%                         when indictor=1, let computer samples RND shocks
% OutPut: cvars: volatilites
%               log_rets: log returns
if length(params)~=4
    display('Not enough parameters... ')
    return
else
    alpha=params(1);
    beta=params(2);
    omega=params(3);
    theta=params(4);
    
if indictor==0
    tmp=readtable('NormalRNDShocks_Table.csv');
    rnd_shocks=table2array(tmp);
else
    rnd_shocks=randn(nn,dd);
end
    

for i=1:dd
    if i==1
        log_rets(:,i)=rnd_shocks(:,i)*sigma0;
        cvars(:,i)=omega+alpha*((log_rets(:,i)-theta*sigma0).^2)+beta*(sigma0^2);
    else
        log_rets(:,i)=rnd_shocks(:,i).*sqrt(cvars(:,i-1));
        cvars(:,i)=omega+alpha*((log_rets(:,i)-theta*sqrt(cvars(:,i-1))).^2)+beta*cvars(:,i-1);
    end
    
end %end for-loop


end %end if-else
end

