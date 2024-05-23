function [nineseven,ninesix,ninetwo,eighteight,eightthree] = efficiency()
% these variables are for plotting the efiency map torque will be on y axis
% rpm will be on x axis
% nintysix effeciency is so precise a point nt wotyh modelling
load("nineseven.mat");
load("ninesix.mat");
load("ninetwo.mat");
load("eighteight.mat");
load("eightthree.mat");
% eithysix = eightysixone;
% ninety = ninetyone;
% ninefour = ninefourone;
% ninefive = ninefiveone;
% ninethree = ninethreeone;

% Extract x and y coordinates
% xeightysix = eightysix(:, 1);
% yeightysix = eightysix(:, 2);
% 
% 
% % Extract x and y coordinates
% xninety = ninety(:, 1);
% yninety = ninety(:, 2);
% 
% 
% % Extract x and y coordinates
% xninethree = ninethree(:, 1);
% yninethree = ninethree(:, 2);
% 
% 
% % Extract x and y coordinates
% xninefour = ninefour(:, 1);
% yninefour = ninefour(:, 2);
% 
% 
% % Extract x and y coordinates
% xninefive = ninefive(:, 1);
% yninefive = ninefive(:, 2);
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
