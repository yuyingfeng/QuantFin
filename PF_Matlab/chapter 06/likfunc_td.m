function loglik=likfunc_td(d,zs)
% inputs: d - t(d) degrees of freedom
%             zs - standardarized returns
% output loglik
    if d<=0
        loglik=intmax;
    else 
       tmp=gammaln((d+1)/2)-gammaln(d/2)-log(pi)/2-log(d-2)/2-0.5*(1+d)*log(1+zs.^2/(d-2));
       loglik=-sum(tmp);
    end
end
