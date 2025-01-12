function [SOC, cruiseUsage, Reserve] = cycles()
    % Diversion mission is 25 miles cruise
    [ResLoss, usedPower, wireMass, current, WLWing, WLRear, WLfront, Areaw, densityCU, ...
        RearRes, wingRes, frontRes, L, K, A, A2, A3, A4, voltage] = variables2();
    
    totalEnergy = 270 * 500 * 3600; % The total energy the batteries are capable of
    output = usedPower * -1;
    
    SOC = zeros(12400, 1);
    SOC(1) = 0.8;
    
    var = ones(12400, 1);
    charge = var * (240 * 10^3); % Instantaneous power gain
    
    for i = 2:12400
        if i <= 700
            SOC(i) = SOC(i-1) + (output(i) / totalEnergy);
        elseif i > 700 && i <= 1300
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 1300 && i <= 2000
            SOC(i) = SOC(i-1) + (output(i-1300) / totalEnergy);
        elseif i > 2000 && i <= 2600
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 2600 && i <= 3300
            SOC(i) = SOC(i-1) + (output(i-2600) / totalEnergy);
        elseif i > 3300 && i <= 3900
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 3900 && i <= 4600
            SOC(i) = SOC(i-1) + (output(i-3900) / totalEnergy);
        elseif i > 4600 && i <= 5200
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 5200 && i <= 5900
            SOC(i) = SOC(i-1) + (output(i-5200) / totalEnergy);
        elseif i > 5900 && i <= 6500
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 6500 && i <= 7200
            SOC(i) = SOC(i-1) + (output(i-6500) / totalEnergy);
        elseif i > 7200 && i <= 7800
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 7800 && i <= 8500
            SOC(i) = SOC(i-1) + (output(i-7800) / totalEnergy);
        elseif i > 8500 && i <= 9100
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 9100 && i <= 9800
            SOC(i) = SOC(i-1) + (output(i-9100) / totalEnergy);
        elseif i > 9800 && i <= 10400
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 10400 && i <= 11100
            SOC(i) = SOC(i-1) + (output(i-10400) / totalEnergy);
        elseif i > 11100 && i <= 11700
            SOC(i) = SOC(i-1) + (charge(i) / totalEnergy);
        elseif i > 11700 && i <= 12400
            SOC(i) = SOC(i-1) + (output(i-11700) / totalEnergy);
        end
    end
    
    cruiseUsage = SOC(45) - SOC(655);
    
    Rez = ones(length(SOC), 1);
    Reserve = 100 * Rez * cruiseUsage * (25/25);
    
    rez2 = 100 * cruiseUsage * 25/25;
    
    time = 1:length(SOC);
    time = time / 60.0 / 23.5 / 0.922;
    
    SOCperc = SOC * 100;
    
    % Plot SOC and Reserve
    figure;
    set(gcf, 'Position', [100, 100, 600, 400]);
    
    plot(time, SOCperc, 'b', 'LineWidth', 1.2);
    hold on;
    
    fill([min(time), 10, 10, min(time)], [100, 100, 80, 80], 'm', 'FaceAlpha', 0.2);
    text(mean(time), 90, 'Maximum SOC 80%', 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', 'Color', [0.25 0.25 0.25], 'FontName', 'Times New Roman', 'FontSize', 10);
    
    fill([min(time), 10, 10, min(time)], [30, 30, 0, 0], 'r', 'FaceAlpha', 0.2);
    text(mean(time), (15+rez2)/2, 'Minimum SOC 30% & Reserve', 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', 'Color', [0.25 0.25 0.25], 'FontName', 'Times New Roman', 'FontSize', 10);
    
    % Labeling the axes and title
    xlabel('Operational Cycles', 'FontName', 'Times New Roman', 'FontSize', 12);
    ylabel('State of Charge %', 'FontName', 'Times New Roman', 'FontSize', 12);
    
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 10);
    
    grid on;
    set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.7, 'GridColor', [0.8 0.8 0.8], 'GridLineWidth', 0.4);
    
    box on;
    ax = gca;
    ax.LineWidth = 1.2;
    ax.XColor = 'black';
    ax.YColor = 'black';
    
    ax.FontName = 'Times New Roman';
    ax.FontSize = 10;
    
    set(gcf, 'Renderer', 'painters');
    print(gcf, 'cycles_plot.eps', '-depsc', '-r600');
end