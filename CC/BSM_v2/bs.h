#ifndef _BS_H_
#define _BS_H_

#include <cmath>
#include "math.h"
#include "stdio.h"
#include "stdlib.h"
#include "normdist.h" 
using namespace std;

double BS_call_Price(const double& S,       // spot (underlying) price
				       const double& K,       // strike (exercise) price,
				       const double& r,       // interest rate
				       const double& sigma,   // volatility 
				       const double& TT,
				       double& tt);

double BS_put_Price(const double& S,      // spot price
				  const double& K,      // Strike (exercise) price,
				  const double& r,      // interest rate
				  const double& sigma,  // volatility
				  const double& TT,
				  double& tt);

double BS_delta_call(const double& S,     // spot price
				  const double& K,     // Strike (exercise) price,
				  const double& r,     // interest rate
				  const double& sigma, // volatility
				  const double& TT,
				  double& tt);

double BS_delta_put(const double& S,     // spot price
				  const double& K,     // Strike (exercise) price,
				  const double& r,     // interest rate
				  const double& sigma, // volatility
				  const double& TT,
				  double& tt);

void BS_Greeks_call(const double& S,     // spot price
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
				  double& Rho);

void BS_Greeks_put( const double& S,     // spot price
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
				  double& Rho);
#endif