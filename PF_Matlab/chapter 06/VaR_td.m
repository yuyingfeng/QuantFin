function var_vals = VaR_td(volats,d,pp)
%Calculate t(d) version VaR
%   Inputs: volats-volatilities;d-degrees of freedom 
var_vals=-volats*sqrt((d-2)/d)*tinv(pp,d);



end

