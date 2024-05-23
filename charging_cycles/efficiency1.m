function [eithysix,ninety,ninethree,ninefour,ninefive] = efficiency()
% these variables are for plotting the efiency map torque will be on y axis
% rpm will be on x axis
% nintysix effeciency is so precise a point nt wotyh modelling
eithysix = [
    3000    50
    1000    50
    375   100
    250   200
    275   300
    450   400
    625   500
    1000   575
    4500   575
    4500   250
    4000   140
    3500    75
    3000    50
    ];
% Extract x and y coordinates
xeightysix = eithysix(:, 1);
yeightysix = eithysix(:, 2);

ninety = [
    3000 100
    1250 100
    750 125
    600 200
    625 300
    750 400
    850 500
    1250 550
    4500 550
    4500 300
    4125 200
    3500 125
    3000 100
    ];
% Extract x and y coordinates
xninety = ninety(:, 1);
yninety = ninety(:, 2);
ninethree = [
    3000 150
    1500 150
    750 200
    750 300
    1000 400
    1250 450
    1500 475
    2000 490
    4500 490
    4500 350
    3750 200
    3500 160
    3000 150
    ];
% Extract x and y coordinates
xninethree = ninethree(:, 1);
yninethree = ninethree(:, 2);

ninefour = [
    2000 170
    1750 175
    1500 175
    1250 225
    1150 300
    1100 370
    1250 385
    1500 400
    2000 410
    2500 405
    3000 400
    3500 375
    3800 300
    3500 225
    3100 200
    2500 175
    2000 170
    ];
% Extract x and y coordinates
xninefour = ninefour(:, 1);
yninefour = ninefour(:, 2);

ninefive =[
    2000 175
    1650 200
    1300 290
    1300 310
    1500 310
    2500 300
    3000 290
    3200 260
    3000 225
    2700 200
    2000 175
    ];
% Extract x and y coordinates
xninefive = ninefive(:, 1);
yninefive = ninefive(:, 2);
% % Plot both shapes
% figure;
% plot(xeightysix, yeightysix, 'o-', 'DisplayName', '86%');
% hold on;
% plot(xninety, yninety, 's-', 'DisplayName', '90%');
% plot(xninethree, yninethree, 's-', 'DisplayName', '93%');
% plot(xninefour, yninefour, 's-', 'DisplayName', '94%');
% plot(xninefive, yninefive, 's-', 'DisplayName', '95%');
% 
% hold off;
% 
% xlabel('RPM');
% ylabel('Torque');
% title('Efficiency Curves');
% legend('Location', 'Best');
% grid on;
% end