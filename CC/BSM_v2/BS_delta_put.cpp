#include <cmath>
#include "normdist.h"               

double BS_delta_put(const double& S, // spot price
					    const double& K, // Strike (exercise) price,
					    const double& r,  // interest rate
					    const double& sigma,
					    const double& TT,
					    double& tt) {
	double time = TT-tt;
    double time_sqrt = sqrt(time);
    double d1 = (log(S/K)+r*time)/(sigma*time_sqrt) + 0.5*sigma*time_sqrt; 
    double delta = -norm_cdf(-d1);
    return delta;
}
