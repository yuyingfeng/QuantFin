%% Those codes are copy-pasted from the following link:
%% http://stackoverflow.com/questions/1526898/how-do-i-reproduce-this-heart-shaped-mesh-in-matlab
%% I modified a little bit for fun and try my best to motive students' passion
% to learn Matlab and other scientific computing languages.

% volume data
[X,Y,Z] = meshgrid(linspace(-3,3,101));
F = -X.^2.*Z.^3 - (9/80).*Y.^2.*Z.^3 + (X.^2 + (9/4).*Y.^2 + Z.^2 - 1).^3;

% initialize figure
hFig = figure('Menubar','none', 'Color','w');
pos = get(hFig, 'Position');
set(hFig, 'Position', [pos(1)-0.3*pos(3) pos(2) 1.3*pos(3) pos(4)]);

% initialize axes
hAxes = axes('Parent',hFig, 'DataAspectRatio',[1 1 1], ...
    'XLim',[30 120], 'YLim',[35 65], 'ZLim',[30 75]);
view(-30,30);
axis off

% Fill the inside of the mesh with an isosurface to
% block rendering of the back side of the heart
patch(isosurface(F,-1e-3), 'FaceColor','w', 'EdgeColor','none')
hidden on    % hidden surface removal

% contours in the y-z plane
for iX = [35 38 41 45 48 51 54 57 61 64 67]
    plane = reshape(F(:,iX,:), [101 101]);
    cData = contourc(plane, [0 0]);
    xData = iX.*ones(1,cData(2,1));
    line(xData, cData(2,2:end), cData(1,2:end), ...
        'Color','r', 'Parent',hAxes)
    pause(.1)
end

% contours in the x-z plane
for iY = [41 44 47 51 55 58 61]
    plane = reshape(F(iY,:,:), [101 101]);
    cData = contourc(plane, [0 0]);
    yData = iY.*ones(1,cData(2,1));
    line(cData(2,2:end), yData, cData(1,2:end), ...
        'Color','r', 'Parent',hAxes)
    pause(.1)
end

% contours in the x-y plane
for iZ = [36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 69 71]
    plane = F(:,:,iZ);
    cData = contourc(plane, [0 0]);
    startIndex = 1;
    if size(cData,2) > (cData(2,1)+1)
        startIndex = cData(2,1)+2;
        zData = iZ.*ones(1,cData(2,1));
        line(cData(1,2:(startIndex-1)), cData(2,2:(startIndex-1)), zData, ...
            'Color','r', 'Parent',hAxes)
    end
    zData = iZ.*ones(1,cData(2,startIndex));
    line(cData(1,(startIndex+1):end), cData(2,(startIndex+1):end), zData, ...
        'Color','r', 'Parent',hAxes)
    pause(.1)
end

% text
props = {'FontWeight','bold', 'FontAngle','italic', 'FontSize',80};
pause(.2)
text(7,50,70, 'I', props{:})
pause(.5)
text(80,50,43, 'CUEB', props{:})
pause(.2)

% xyz axes
line([20 80], [50 50], [52.5 52.5], 'Color','k')
line([50 50], [20 80], [52.5 52.5], 'Color','k')
line([50 50], [50 50], [30 80], 'Color','k')
text(20,50,50, 'x')
text(48,20,50, 'y')
text(45,50,80, 'z')
drawnow

% equation
props = {'FontSize',10, 'Interpreter','latex'};
text(20,65,30, '$(x^2+9/4y^2+z^2-1)^3 - x^2z^3-9/80y^2z^3=0$', props{:});
text(30,45,30, '$-3 \leq x,y,z \leq 3$', props{:});
drawnow
