function es_vals = ES_td(volats,d,pp)
%Calculate t(d) version ES 
%   Inputs: volats-volatilities;d-degrees of freedom 
Cd=gamma(0.5*(d+1))/(gamma(0.5*d)*sqrt(pi*(d-2)));
%%%%PF's formula
QQ=tinv(pp,d);
aa=1/(d-2);
bb=(2-d)/2;
cc=(d-2)/(1-d);
tmp1=((1+aa*(QQ^2))^bb)*cc;
%tmp2=((1+QQ/(d-2))^(1-d))*cc;
EStdp=Cd*tmp1/pp;
es_vals=-volats*EStdp;

end

