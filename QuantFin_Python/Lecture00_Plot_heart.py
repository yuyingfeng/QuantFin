import matplotlib.pylab          as plt
import numpy                     as np
import math                      as mm

llen=1000;
x=np.zeros(llen);
y=np.zeros(llen);


for i in range(0,llen):
   t=2*i*(mm.pi)/llen;
   x[i]=16*mm.pow(mm.sin(t),3);
   y[i]=13*mm.cos(t)-5*(mm.cos(t*2))-2*mm.cos(3*t)-mm.cos(4*t);

plt.figure(1)
#plt.plot(x,y,color='#7570B3',linewidth=4.5)
plt.plot(x,y,color='r',linewidth=4.5)
plt.show()
