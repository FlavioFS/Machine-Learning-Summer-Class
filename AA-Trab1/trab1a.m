load ex1data1.txt

% ------- Input Section -------
X = ex1data1(:, 1);
Y = ex1data1(:, 2);

DATA_97 = 97;
ARGS_2 = 2;

W0 = 0.1;
W1 = 0.1;
% X = zscore(X);
% -----------------------------

% Constants
ALPHA = 0.001;
PASSES = 1000;

% --------- Training ----------
EQMList = [];
for pass_it = 1 : PASSES
	% Shuffle
	newOrder = randperm(DATA_97);

	Xs = X(newOrder);
	Ys = Y(newOrder);

	% Error
	EQM = 0;

	% Practice
	for i = 1 : DATA_97

		Ypi = W1 * Xs(i) + W0;
		Ei = Ys(i) - Ypi;

		W0 += ALPHA * Ei;
		W1 += ALPHA * Ei * Xs(i);
		EQM += Ei^2;
	end

	EQM /= DATA_97;

	EQMList = [EQMList EQM];
end

% Plots Samples
ERRList = [];
for i = 1 : DATA_97
	Ypi = W1 * X(i) + W0;
	ERRList = [ERRList; (Y(i) - Ypi)];
end

% Plotting Samples
range = 5:0.100:30;
figure
plot(X, Y, 'rd',...
     'LineWidth', 1,...
     'MarkerSize', 5,...
     'MarkerEdgeColor', 'w',...
     'MarkerFaceColor', 'r');
hold on;
plot(range, W1*(range) + W0, 'c' , 'LineWidth', 1);

daLegend = legend({'Estimated Values', 'Real Values'});
set(daLegend,'color', 'none');
set(daLegend,'FontSize', 10);
set(daLegend,'FontWeight', 'bold');

set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)

% Plotting
figure
bar(EQMList, 'c');
hold on;

legend({'Sample Error'});
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)