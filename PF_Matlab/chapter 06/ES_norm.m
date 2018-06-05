function es_vals= ES_norm(volats, pp )
%Calculate Expected Shortfall when 
% we assume zt follows N(0,1)
% volats=volatilities
    es_vals=volats*normpdf(norminv(pp))/pp;
end

