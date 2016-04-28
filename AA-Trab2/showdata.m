% Loading
load ex2data1.data;

% Sizes
TOTAL   = size(ex2data1(:,1))(1,1);
COLUMNS = size(ex2data1(1,:))(1,2);
breakpoint = 70;% floor(TOTAL/2);

% Adding the one for the constant term
X = ex2data1(:, 1:COLUMNS-1);
Y = ex2data1(:, COLUMNS);

% Plotting
figure
bar(X(:,1), 'g');
legend({'Nota 1'});
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)

figure
bar(X(:,2), 'c');
legend({'Nota 2'});
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)

% Plotting
% figure
% bar(X(:,1), 'ko',...
%      'LineWidth', 1,...
%      'MarkerSize', 5,...
%      'MarkerEdgeColor', 'k',...
%      'MarkerFaceColor', 'r');
% hold on;
% bar(X(:,2), 'ko',...
%      'LineWidth', 2,...
%      'MarkerSize', 5,...
%      'MarkerEdgeColor', 'k',...
%      'MarkerFaceColor', 'g');

% daLegend = legend({'Nota 1', 'Nota2'});
% set(daLegend,'color', 'none');
% set(daLegend,'FontSize', 10);
% set(daLegend,'FontWeight', 'bold');
% set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
% set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)
