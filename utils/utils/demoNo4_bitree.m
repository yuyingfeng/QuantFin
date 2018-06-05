clear
%One-period Binominal-tree
S0=30;      %Underlying Asset
X=30;       %Strike price
R=7/100;    %Risk-free
T=1;        %Two-periods
DT=0.125;   %The length of interval
u=1+1/3;    %Upper size
SIG=log(u); %Volatility
FLAG=1;     %Matlab default set, when "1" means call
Q=0;        %Dividend rate
DIV=0;      %Dividend payment
EXDIV=0;    %Specified div in number of periods

[prices1,c_bin1] = binprice(S0,X,R,T,DT,SIG,FLAG);

display('One-Period Call Optoion result using Binonial Tree model')
display(['Matlab built-in function binomial-tree result=',num2str(c_bin1(1,1))])

M=1/DT;

C0= EuroCallBinomial(S0,X,R,T,SIG,M);

display(['My result of binomial-tree result=',num2str(C0)]);
