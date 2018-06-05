function var_vals= VaR_norm(volats, pp )
%Calculate VaR when we assume zt follows N(0,1)
    var_vals=-volats*norminv(pp);
end

