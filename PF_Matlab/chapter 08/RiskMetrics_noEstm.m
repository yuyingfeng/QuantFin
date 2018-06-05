function [cvars,zs,log_rets] = RiskMetrics_noEstm(Prices,lambda)
% RiskMetris but without estimation step
% OutPut: cvars: volatilites
%               zs : standarialized returns
%               log_rets: log returns
log_rets=diff(log(Prices));
len=length(log_rets);
cvars(1)=var(log_rets);

for i=2:len
    cvars(i)=lambda*cvars(i-1)+(1-lambda)*(log_rets(i-1)^2);
end
cvars=cvars';%chance to column vector
zs=log_rets./sqrt(cvars);

end

