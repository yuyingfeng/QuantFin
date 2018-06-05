# -*- coding:utf-8 -*-
__version__ = '0.0.1'
__author__ = 'Dr. Yingfeng, Yu'

from call_option import *

def main():
    S0=100.00   #the price of underlying asset
    K=105.00    #the strike price
    T=1.0       #the length of call option contract
    t=0.1       #the initial time
    r=0.05      #risk-free rate
    sigma=0.20  #the volatility
    call_price=call_option(S0, K, T, t, r, sigma)
    call_price.prt_option_info()
    #del call_price

if __name__ == "__main__":
    main()