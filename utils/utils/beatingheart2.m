n=300;
x=linspace(-3,3,n);
y=linspace(-3,3,n);
z=linspace(-3,3,n);
[X,Y,Z]=ndgrid(x,y,z);
F=((-(X.^2) .* (Z.^3) -(9/80).*(Y.^2).*(Z.^3)) + ((X.^2) + (9/4).* (Y.^2) + (Z.^2)-1).^3);
isosurface(F,0)
lighting phong
caxis
axis equal
colormap('flag');
view([55 34]);