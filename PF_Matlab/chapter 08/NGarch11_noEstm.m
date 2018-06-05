function [cvars,zs,log_rets] = NGarch11_noEstm(Prices,params)
% NGarch11 but without estimation step
% OutPut: cvars: volatilites^2
%               zs : standarialized returns
%               log_rets: log returns
if length(params)~=4
    display('Not enough parameters... ')
    return
else
    alpha=params(1);
    beta=params(2);
    omega=params(3);
    theta=params(4);

log_rets=diff(log(Prices));
len=length(log_rets);
cvars(1)=var(log_rets);

for i=2:len
    cvars(i)=omega+alpha*((log_rets(i-1)-theta*sqrt(cvars(i-1)))^2)+beta*cvars(i-1);
end %end for-loop
cvars=cvars';%chance to column vector
zs=log_rets./sqrt(cvars);

end %end if-else

end

