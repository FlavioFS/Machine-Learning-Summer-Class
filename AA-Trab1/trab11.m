load ex1data1.txt

% ------- Input Section -------
X = ex1data1(:, 1);
Y = ex1data1(:, 2);

DATA_AMOUNT = size(X)(1,1);
ARGS_AMOUNT = size(X)(1,2);

W = ones(1, ARGS_AMOUNT+1)*0.1
X = zscore(X);
X = [ones(DATA_AMOUNT, 1) X];
% -----------------------------


% Constants
ALPHA = 0.001;
PASSES = 5;


% --------- Functions ---------
%% Yp: Estimates Y(i)
function outputs = Yp(i, W, Xt)
	outputs = W*Xt(:, i);
end

%% e: Error
function outputs = e(i, W, Xt, Y)
	outputs = Y(i) - Yp(i, W, Xt);
end
% -----------------------------


% --------- Training ----------
EQMList = [];
for pass_it = 1 : PASSES
	% Shuffle
	newOrder = randperm(DATA_AMOUNT, DATA_AMOUNT);

	Xs = X(newOrder, :);
	Ys = Y(newOrder, :);

	Xt = transpose(Xs);

	% Error
	EQM = 0;

	% Practice
	for sample_it = 1 : DATA_AMOUNT
		Ei = e(sample_it, W, Xt, Y);

		% ALPHA * e(sample_it, W, Xt, Yt) * X(sample_it, :)
		W = W + ALPHA * Ei * X(sample_it, :);
		EQM += Ei^2;
	end

	EQMList = [EQMList EQM];
end

% Plots Samples
YpList = [];
ERRList = [];
for sample_it = 1 : DATA_AMOUNT
	Ypi = Yp(sample_it, W, Xt);
	YpList = [YpList; Ypi];
	ERRList = [ERRList; e(sample_it, W, Xt, Y)];
end

% Plotting Samples
figure
plot(Y, '-gp',...
     'LineWidth', 1,...
     'MarkerSize', 8,...
     'MarkerEdgeColor', 'w',...
     'MarkerFaceColor', 'c');
hold on;
plot(YpList, '-ko',...
     'LineWidth', 1,...
     'MarkerSize', 5,...
     'MarkerEdgeColor', 'k',...
     'MarkerFaceColor', 'r');

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
