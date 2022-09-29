
x0 = -10; xN = 10;
y0 = -10; yN = 10;

eps = 0.05;

xj = -2;

yj = (xj - 3)/(xj - 1);

xL = linspace(x0, xj -eps, 50);

xM = linspace(xj + eps, 0.9, 50);

xR = linspace(1.1, xN, 50);

x = linspace(x0, xN, 100);

y = (x - 3)./(x - 1);
% some random comment just to see how git branches work

figure(1), clf, hold on

plot(x, y, 'k.', 'linewidth', 2)

plot(xj, yj, 'ro', 'markersize', 5)

xa = 0.2;
ya = 0.2;

patch([xN -ya; xN ya; xN+3*xa 0], ...
      [-xa yN; xa yN; 0, yN+3*ya], 'k', 'clipping', 'off')

yL = (xL - 3)./(xL - 1);
yM = (xM - 3)./(xM - 1);
yR = (xR - 3)./(xR - 1);
grid on
grid minor
plot([x0, xN], [0, 0], '-k', 'linewidth', 2)
plot([0, 0], [y0, yN], '-k', 'linewidth', 2)
plot([x0, xN], [1, 1], '--r', [1, 1], [y0, yN], '--r', xL, yL, '-b', xM, yM, '-b', xR, yR, '-b', 'linewidth', 2)
% text()

xlim([x0-xa, xN+xa])
ylim([y0-ya, yN+ya])
axis equal
