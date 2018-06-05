function C0=EuroCallBinomial(S0,X,r,T,sigma,M)
% S0    -underlying asset price
% X     -Strike price
% r     -risk-free rate
% T     -the num of Periods
% sigma -volatility
% M     -the num of interval
    fs=     1;
    dt=     T/M;
    u=      exp(sigma*sqrt(dt));
    d=      1/u;
    pi_u=   (exp(r*dt)-d)/(u-d);
    pi_d=   1-pi_u;

    S=      zeros(M+1,1);
    S(fs+0)=S0*d^M;
for j=1:M
        S(fs+j)=S(fs+j-1)*u/d;
end

    C=max(S-X,0);

for i=M-1:-1:0
    for j=0:i
            C(fs+j)=exp(-r*dt)*(pi_u*C(fs+j+1)+pi_d*C(fs+j));
    end
end
    C0=C(fs+0);
end