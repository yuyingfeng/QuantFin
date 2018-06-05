clear
%Two-period Binominal-tree
S0=50;      %Underlying Asset
X=45;       %Strike price
R=7/100;    %Risk-free
T=2;        %Two-periods
DT=1;       %The length of interval
u=1.25;     %Upper size
SIG=log(u); %Volatility
FLAG=1;     %Matlab default set, when "1" means call
Q=0;        %Dividend rate
DIV=0;      %Dividend payment
EXDIV=0;    %Specified div in number of peridos

[prices,calls] = binprice(S0,X,R,T,DT,SIG,FLAG);


%One-period Binominal-tree
S0=30;      %Underlying Asset
X=30;       %Strike price
R=7/100;    %Risk-free
T=2;        %Two-periods
DT=1;       %The length of interval
u=1+1/3;     %Upper size
SIG=log(u); %Volatility
FLAG=1;     %Matlab default set, when "1" means call
Q=0;        %Dividend rate
DIV=0;      %Dividend payment
EXDIV=0;    %Specified div in number of periods

[prices,c_bin] = binprice(S0,X,R,T,DT,SIG,FLAG);

DT=1/100;
[prices,c_bin] = binprice(S0,X,R,T,DT,SIG,FLAG);
c_bin(1,1)
DT=1/1000;
[prices,c_bin] = binprice(S0,X,R,T,DT,SIG,FLAG);
c_bin(1,1)

DT=1/10000;
[prices,c_bin] = binprice(S0,X,R,T,DT,SIG,FLAG);
c_bin(1,1)

[cc,pp]=blsprice(S0,X,R,T,SIG);
cc

