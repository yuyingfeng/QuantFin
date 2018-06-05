# Readme
## Demo01 Run "test_european_option_payoff.m" and then you gain: 
## ![Mou](/utils/four_diagram_euro.png)

## Demo02 Run "test_BAWAericanCallApprox.m", we demo BAW america call option pricing formula
```matlab
clear 
close all
format long;
S=50;%underlying asset price
T=0.5;%contract maturity
vol=0.35;%anually volatility
X=60;%strike price
r=0.2;%risk-free rate
q=0.1;%compounded discount rate
b=r-q;% carry cost rate
t=.0;

C_am=BAWAericanCallApprox(S,X,T,t,r,b,vol)
C_bsm=bsm_call(S,X,T,t,r,b,vol)
```
