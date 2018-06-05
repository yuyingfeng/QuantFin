#  Written by 2018 Yingfeng Yu < yuyingfeng (at) cueb.edu.cn >
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
#==========================================================================

import numpy as np
import pandas as pd
import scipy.stats as ss
import matplotlib.pyplot as plt
from scipy.optimize import fmin_slsqp

def gjr_garch_likelihood(parameters, data, sigma2, out = None):
        mu = parameters[0]
        omega = parameters[1]
        alpha = parameters[2]
        gamma = parameters[3]
        beta = parameters[4]

        T = np.size(data,0)
        #print('What is T=',T)
        eps = data - mu
        # Data and Sigma2 are T by 1 vectors
        for t in range(1,T):
            sigma2[t]=(omega+alpha*eps[t-1]**2+gamma*eps[t-1]**2 * (eps[t-1]<0)+beta*sigma2[t-1])

        logliks = 0.5*(np.log(2*np.pi)+np.log(sigma2)+eps**2/sigma2)
        loglik = np.sum(logliks)

        if out is None:
            return loglik
        else:
            return loglik, logliks, np.copy(sigma2)

def gjr_constraint(parameters, data, sigma2, out=None):
        alpha = parameters[2]
        gamma = parameters[3]
        beta = parameters[4]
        return np.array([1-alpha-gamma/2-beta])

def garch_likelihood(parameters, data, sigma2, out = None):
        mu = parameters[0]
        alpha = parameters[1]
        beta = parameters[2]

        T = np.size(data,0)
        eps = data - mu
        # Data and Sigma2 are assumed as T by 1 vectors
        for t in range(1,T):
            sigma2[t]=(alpha*eps[t-1]**2+beta*sigma2[t-1])

        logliks = 0.5*(np.log(2*np.pi)+np.log(sigma2)+eps**2/sigma2)
        loglik = np.sum(logliks)

        if out is None:
            return loglik
        else:
            return loglik, logliks, np.copy(sigma2)

def garch_constraint(parameters, data, sigma2, out=None):
        alpha = parameters[1]
        beta = parameters[2]
        return np.array([1-alpha-beta])
