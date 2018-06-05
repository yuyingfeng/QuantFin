# -*- coding: utf-8 -*-
"""
Created on Wed Sep  6 09:18:34 2017
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
@author: yuyingfeng
"""

import numpy as np
import matplotlib.pyplot as plt
#%matplotlib inline

Nsim=15000;
aa=np.random.randn(Nsim,1)

accum_a= np.zeros((Nsim, 1))
accum_a[0]=aa[0]
for i in range(1,Nsim):
    accum_a[i]=np.sum(aa[0:i])

plt.plot(accum_a,color = '#1B9E77', linewidth=1.5)
plt.title('Winner Process')
plt.grid(True)
plt.xlabel("time")
plt.ylabel("magnitude")
