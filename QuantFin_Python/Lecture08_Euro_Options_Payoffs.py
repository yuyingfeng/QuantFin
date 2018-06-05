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

def european_opt_payoff(typ,S, K):
#typ ="type" when "c"=call, "p=put"
    if (typ=='c'):
        payoff=(abs(S-K)+(S-K))/2
    else:
        payoff=(abs(K-S)+(K-S))/2

    return payoff

S=np.arange(1,10,0.01) #underlying asset prices
K=5.0 #strike price
typ='c'
pay_off_c= european_opt_payoff(typ,S, K)

typ='p'
pay_off_p= european_opt_payoff(typ,S, K)

#xmin=min(S)
#xmax=max(S)
#ymin=min(-pay_off_c)
#ymax=max(pay_off_c)

plt.figure(figsize=(10,8))
plt.subplot(2,2,1)
#plt.axis([xmin,xmax,ymin,ymax])
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off_c,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Call')
plt.grid(True)

plt.subplot(2,2,3)
plt.axhline(0, color='black', lw=2)
plt.plot(S,-pay_off_c,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Call')
plt.grid(True)

plt.subplot(2,2,2)
plt.axhline(0, color='black', lw=2)
plt.plot(S,pay_off_p,color = '#1B9E77', linewidth=1.5)
plt.title('Long a Put')
plt.grid(True)

plt.subplot(2,2,4)
plt.axhline(0, color='black', lw=2)
plt.plot(S,-pay_off_p,color = '#1B9E77', linewidth=1.5)
plt.title('Short a Put')
plt.grid(True)
