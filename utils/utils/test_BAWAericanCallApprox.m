%--------------------------------------------------------------------------
% DESCRIPTION: demo the result of Barone-Adesi and Whaley(BAW) model
% Approximation of American call due to Barone-Adesi and Whaley(1987)
% Reference:
% Barone-Adesi,G.,and R.E.Whaley(1987): 
%Efficeint Analytic Approximation of American Option Values, 
%Jounral of Finance, 42(2).301-320.
%--------------------------------------------------------------------------
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
