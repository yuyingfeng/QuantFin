#############################################################################
#
# Examples from Elements of Financial Risk Management, Second Edition 2nd Edition
# by Peter Christoffersen
# The examples come from its Chapter 1 Q1-Q5
#  Written by 2016 Yingfeng Yu < yuyingfeng (at) cueb.edu.cn >
#  Capital University of Economics and Business(CUEB),Beijing, China
#  School of Finance, Dept. of International Finance
#  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
##############################################################################
# Import some libraries

import matplotlib.pylab          as plt
import numpy                     as np
#import pandas                    as pd
import scipy.stats               as stats
#import csv

##############################################################################
# Load data
##############################################################################

d = np.genfromtxt("./yyfQFdata/testyyfsp500.csv")
y = 100 * np.diff(np.log(d))

##############################################################################
# Define the model
##############################################################################
nIter           =len(y);

alpha           =0.94;
beta            =0.06;
vol             = np.zeros((nIter,1));
std_ret         =np.zeros((nIter,1));
mu              =1-alpha-beta;
vol[0]          =np.std(y)+mu;
std_ret[0]      =y[0]/vol[0];

for tt in range(1, nIter):
        tmp1            =mu+alpha*(vol[tt-1]**2)+beta*(y[tt-1]**2);
        vol[tt]         =np.sqrt(tmp1);
        std_ret[tt]     =y[tt]/vol[tt];
#End of for-loop

print("==Vairables======|======Mean========|======Std=======|======Skewness====|====Kurtosis======|")
print("Stock Prices:",stats.describe(d)[2:])
print("Log-Returns :",stats.describe(y)[2:])
print("St~ized Rets :",stats.describe(std_ret)[2:])

dLen=2499;#
plt.figure(1);
# Plot Stock Prices
plt.subplot(3,2,(1,2));
plt.grid()
plt.plot(d[0:dLen],color = '#D95F02', linewidth=1.5);
plt.xlabel("time"); plt.ylabel("Stock Prices")

# Plot the log-returns
plt.subplot(3,2,3);
plt.grid()
plt.plot(y[0:dLen],color = '#1B9E77', linewidth=1.5);
plt.xlabel("time"); plt.ylabel("Log-returns")

# Plot the volatility
plt.subplot(3,2,5);
plt.grid()
plt.plot(vol[0:dLen],color = '#E7298A', linewidth=1.5);
plt.xlabel("time"); plt.ylabel("Volatility")

# plot the standardized returns
plt.subplot(3,2,4);
plt.grid()
plt.plot(std_ret[0:dLen],color = '#7570B3', linewidth=1.5);
plt.xlabel("time"); plt.ylabel("Standardized Returns")

# Histogram of the standardized returns
plt.subplot(3,2,6);
plt.grid()
plt.hist(std_ret[0:dLen],bins=40,normed=1, facecolor='#E7298A')
plt.ylabel("frequency"); plt.xlabel("Standardized Returns density")
plt.axvline(np.mean(std_ret[0:dLen]), linewidth=1.5, color = 'k' )

plt.show()
###############################################################################
# End of file
##############################################################################
