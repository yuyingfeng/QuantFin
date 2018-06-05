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
import pandas as pd
import scipy.stats as ss
import matplotlib.pyplot as plt
import statsmodels.api as sm

from statsmodels.tsa.stattools import acf


def riskmetrics_volatilities(parameters, data, sigma2):
        alpha = parameters[0]
        beta = parameters[1]
        T=len(data)

        for t in range(1,T):
            sigma2[t]=(alpha*data[t-1]**2+beta*sigma2[t-1]) #yyf v2
        
        return np.copy(sigma2)
    
def VaR_norm(vols, p):
    #T=len(vols)
    invpdf=ss.norm.ppf(p)
    VaR =-invpdf*vols
    return VaR
    

#%matplotlib inline
df = pd.read_excel("./yyfQFdata/PF_data.xlsx",parse_dates=[0])
df.describe()
df.index=df.pop('Date')
df.describe()
df.describe()
new_df=df.drop_duplicates(subset=['Close'])
new_df.describe()
df[570:589].drop_duplicates(subset=['Close'])
#dfrets = 100* new_df.pct_change().dropna()
#dfrets.describe()
df_log_rets = 100*np.log(new_df/new_df.shift(1)).dropna()

df_log_rets.describe()

df_log_rets.info()
new_df.plot(subplots=(2,1,1),grid=True,figsize=(10,6),color='#009CD1',title='SP500 Prices')
df_log_rets.plot(subplots=(2,1,2),grid=True,figsize=(10,6),color='#8E008D',title='SP500 Log Returns')
print(df_log_rets.kurt())
print(df_log_rets.skew())



SP_acf=acf(df_log_rets.Close, nlags=200)
SP_acf2=acf(df_log_rets.Close**2, nlags=200)

plt.figure(figsize=(10,6),dpi=980)

p1 = plt.subplot(2,1,1)
p1.grid(True)
p1.plot(SP_acf[1:],color='#009CD1')
p1.set_title('ACF of Returns',fontsize=10)

p2 = plt.subplot(2,1,2)
p2.grid(True)
p2.plot(SP_acf2[1:],color='#8E008D')
p2.set_title('ACF of Returns$^{2}$',fontsize=10)

plt.figure()
sm.qqplot(df_log_rets.Close,line='s')
plt.grid(True)
plt.xlabel('theoretical quantiles')
plt.ylabel('sample quantiles')
plt.title('SP500 returns',fontsize=10)

df_log_rets.hist(bins=200,figsize=(10,6))

tmpdata= df_log_rets.Close

mean_rts = tmpdata.mean()
var_rts  = tmpdata.var()
std_rts = tmpdata.std()

T=tmpdata.count()

sigma2 = np.ones(T)*(var_rts) #initialized volatilities
analized=1 # or we should set to 252
startingVals = np.array([mean_rts,.06,.94]) ##change

sigma2final = riskmetrics_volatilities(startingVals[1:],np.array(tmpdata), sigma2)

rm_vol=np.sqrt(analized*sigma2final)

CH01_results = pd.DataFrame(new_df.Close,index=new_df.index,columns=['Close'])

CH01_results.loc[1:,'Log Returns'] = tmpdata
CH01_results.loc[1:,'RMVolatilities'] = rm_vol

#CH01_results = pd.DataFrame(rm_vol,index=new_df.index,columns=['Conditional Std Deviation'])

CH01_results.RMVolatilities.plot(figsize=(12,7),grid=True)


normalized_new_rts=np.asarray(tmpdata)/rm_vol

CH01_results.loc[1:,'Standerized Returns'] = normalized_new_rts

#CH01_results.loc[:,'Close'] = new_df.Close



VaR = np.zeros(T) #initialized VaR
p=0.01
VaR = VaR_norm(rm_vol,p)
CH01_results.loc[1:,'VaR'] = VaR

# call our function ‘mynormqqplot’
#gr_vol

ttmp=normalized_new_rts/(normalized_new_rts.std())
plt.figure()
sm.qqplot(ttmp,line='s')
plt.grid(True)
plt.xlabel('theoretical quantiles')
plt.ylabel('sample quantiles')
plt.title('SP500 riskmetrics standarized rets',fontsize=10)


#calculate FOUR MOMENTS of standerized returns using Garch 11
a1=ttmp.mean()
a2=ttmp.std()
a3=ss.skew(ttmp)
a4 =ss.kurtosis(ttmp)

std_rts=tmpdata.std()
normalized_log_rts=np.asarray(tmpdata)/std_rts

#calculate FOUR MOMENTS of original log returns
b1=normalized_log_rts.mean()
b2=normalized_log_rts.std()
b3=ss.skew(normalized_log_rts)
b4 =ss.kurtosis(normalized_log_rts)

print('Type     ||','mean||','std||','skew||','kurt||')
print('Original data:  ',b1,b2,b3,b4)
print('After riskmetrics:  ',a1,a2,a3,a4)

CH01_results.to_csv("./yyfQFdataout/PF_yyf_CH01_results.csv",index_label='date')
CH01_results.to_excel("./yyfQFdataout/PF_yyf_CH01_results.xls",index_label='date')

df.to_excel("yyfdataout/PF_SP_pdrd2wrt.xls",index_label='date')
