load ex1data2.txt

% ------- Input Section -------
X1 = ex1data2(:, 1);
X2 = ex1data2(:, 2);
Y = ex1data2(:, 3);

DATA_47 = 47;
ARGS_2 = 2;

W0 = 0.1;
W1 = 0.1;
W2 = 0.1;
% X = zscore(X);
% -----------------------------

% Constants
ALPHA = 0.01;
PASSES = 100;

% --------- Training ----------
EQMList = [];
for pass_it = 1 : PASSES
	% Shuffle
	newOrder = randperm(DATA_47);

	X1s = X1(newOrder);
	X2s = X2(newOrder);
	Ys = Y(newOrder);

	% Error
	EQM = 0;

	% Practice
	for i = 1 : DATA_47

		Ypi = W2 * X2s(i) + W1 * X1s(i) + W0;
		Ei = Ys(i) - Ypi;

		W0 += ALPHA * Ei;
		W1 += ALPHA * Ei * X1s(i);
		W2 += ALPHA * Ei * X2s(i);
		EQM += Ei^2;
	end

	EQM /= DATA_47;

	EQMList = [EQMList EQM];
end

% Plots Samples
ERRList = [];
for i = 1 : DATA_47
	Ypi = W2 * X2(i) + W1 * X1(i) + W0;
	ERRList = [ERRList; (Y(i) - Ypi)];
end

% Plotting Samples
% range = 5:0.100:30;
% figure
% plot(X, Y, 'rd',...
%      'LineWidth', 1,...
%      'MarkerSize', 5,...
%      'MarkerEdgeColor', 'w',...
%      'MarkerFaceColor', 'r');
% hold on;
% plot(range, W1*(range) + W0, 'c' , 'LineWidth', 1);

% daLegend = legend({'Estimated Values', 'Real Values'});
% set(daLegend,'color', 'none');
% set(daLegend,'FontSize', 10);
% set(daLegend,'FontWeight', 'bold');

% set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
% set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)

% Plotting
figure
bar(EQMList, 'c');
hold on;

legend({'Sample Error'});
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)