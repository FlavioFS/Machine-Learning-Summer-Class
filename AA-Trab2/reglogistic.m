% Loading
load ex2data2.data;
load featuredX.mat;

% Sizes
TOTAL   = size(featuredX(:,1))(1,1);
COLUMNS = size(featuredX(1,:))(1,2);
breakpoint = 70;% floor(TOTAL/2);

% Adding the one for the constant term
X = featuredX(:, 1:COLUMNS);
Y = ex2data2(:, 3);

% Standard Score of Columns
for i=2:COLUMNS
	X = [X(:,1) zscore(X(:, 2:end))];
end;

X = transpose(X);

% ---------------------------------------------------
%% Training Assets
training_X  = X(:, 1:breakpoint);
training_Y  = Y(1:breakpoint, :);
A = ones(COLUMNS,1);   % Starting value of A

% Hypothesis function
% h: Estimates Yi for Xi
function outputs = h(Xi, A)
	outputs = 1.0 / (1.0 + exp(-transpose(A) * Xi));
	% disp('h(Xi, A):');
	% disp(Xi);
	% disp(A);
end;

% SQErrorTraining: Calculates the squared error so far during the training phase
function outputs = SQErrorTraining(training_X, training_Y, A, breakpoint)
	outputs = 0.0;
	for i=1:breakpoint
		delta = ( training_Y(i) - h(training_X(:,i), A) ).^2;
		outputs += delta;
	end;
	% disp('SQErrorTraining(training_X, training_Y, A, breakpoint)');
	% disp(training_X);
end;

%% Training
MAX_ATTEMPTS = 1000;
MAX_SQERROR = breakpoint * 0.1;
learningFactor = 0.01;
LAMBDA = 0.25;
% learningFactor = 0.000104;
attempts = 0;
ErrorHistory = [];
while (attempts < MAX_ATTEMPTS)
	% Shuffle
	newOrder = randperm(size(training_Y,1));
	shuffled_X = training_X(:, newOrder);
	shuffled_Y = training_Y(newOrder, :);

	

	for i=1:breakpoint
		Xi = shuffled_X(:,i);
		hXi = h(Xi, A);
		ERRi = ( training_Y(i) - hXi );
		dHi = hXi * ( 1 - hXi );
		% Aj = 
		% A = A + learningFactor * ( training_Y(i) - hXi )  * hXi * ( 1 - hXi ) * Xi;
		A1 = A(1) + learningFactor * ERRi * dHi * Xi(1);
		Ai = A(2:end);
		Ai = Ai + learningFactor * (ERRi * dHi * Xi(2:end) - LAMBDA * Ai);
		A = [A1; Ai];
		% learningFactor = 1000 / (1000 + (i + attempts*breakpoint)/2);
	end;
	
	Ytp = transpose(transpose(A) * training_X);
	Error = 0;
	for i = 1 : breakpoint
		Error += (Ytp(i) - training_Y(i)).^2;
	end
	Error /= breakpoint;
	ErrorHistory = [ErrorHistory Error];

	attempts++;
end;

figure
bar(ErrorHistory, 'r');
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)

% printf('----- %d (alfa: %f) -----\n', attempts, learningFactor);
% printf('A:  ');
% disp(transpose(A));

% ---------------------------------------------------
%% Prediction Assets
prediction_X = X(:, breakpoint+1:end);
real_Y       = Y(breakpoint+1:end, :);

% SQErrorFinal: Calculates the squared error for the final sample
function [matches, percent, prediction_Y] = SQErrorFinal(prediction_X, real_Y, A)
	matches = 0;
	TOTAL = size(real_Y(:,1));
	prediction_Y = zeros(TOTAL, 1);
	
	guessTemp = transpose(A) * prediction_X;

	% disp(guessTemp);
	guessTemp = transpose(guessTemp);

	for i=1:TOTAL
		if guessTemp(i,1) < 0
			prediction_Y(i,1) = 0;
		else
			prediction_Y(i,1) = 1;
		end;	

		if real_Y(i,1) == prediction_Y(i,1)
			matches++;
		end;

		% printf('\tguessTemp(%3d): %9f   real_Y: %d   prediction_Y: %d   result: %d\n', i, guessTemp(i,1), real_Y(i,1), prediction_Y(i,1), (real_Y(i,1) == prediction_Y(i,1)));
	end;

	percent = 1 - (matches/TOTAL(1));

end;


[matches, percent, prediction_Y] = SQErrorFinal(prediction_X, real_Y, A);
percent *= 100;
printf('\nError: %d%% (Score: %d/%d)\n', percent, matches, TOTAL-breakpoint);

% Plotting
% figure
% plot(real_Y, 'wp',...
%      'LineWidth', 1,...
%      'MarkerSize', 10,...
%      'MarkerEdgeColor', 'w',...
%      'MarkerFaceColor', 'c');
% hold on;
% plot(prediction_Y, 'ko',...
%      'LineWidth', 2,...
%      'MarkerSize', 5,...
%      'MarkerEdgeColor', 'k',...
%      'MarkerFaceColor', 'r');

% daLegend = legend({'Real Values', 'Estimated Values'});
% set(daLegend,'color', 'none');
% set(daLegend,'FontSize', 10);
% set(daLegend,'FontWeight', 'bold');
% set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
% set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)