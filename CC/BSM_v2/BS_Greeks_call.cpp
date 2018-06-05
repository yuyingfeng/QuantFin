#include <cmath>
#include "normdist.h"               
using namespace std;

void BS_Greeks_call( const double& S,     // spot price
				  const double& K,     // Strike (exercise) price,
				  const double& r,     // interest rate
				  const double& sigma, // volatility
				  const double& TT,  
				  double& tt,
				  double& Delta, 
				  double& Gamma, 
				  double& Kappa,
				  double& Theta, 
				  double& Vega,  
				  double& Rho){  
  	double time_sqrt = sqrt(TT-tt);
  	double d1 = (log(S/K)+r*(TT-tt))/(sigma*time_sqrt) + 0.5*sigma*time_sqrt; 
  	double d2 = d1-(sigma*time_sqrt);
  	Delta = norm_cdf(d1);
  	Gamma = norm_pdf(d1)/(S*sigma*time_sqrt);
  	Kappa = (norm_cdf(-d2)-1)*exp(-r*(TT-tt));
  	Theta =-(S*sigma*norm_pdf(d1))/(2*time_sqrt)-r*K*exp(-r*(TT-tt))*norm_cdf(d2);
  	Vega = K*norm_cdf(d1)*time_sqrt;
  	Rho   = K*(TT-tt)*exp(-r*(TT-tt))*norm_cdf(d2);
};