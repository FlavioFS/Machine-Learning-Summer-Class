% Loading
load ex2data1.data;

% Sizes
TOTAL   = size(ex2data1(:,1))(1,1);
COLUMNS = size(ex2data1(1,:))(1,2);
breakpoint = 70;% floor(TOTAL/2);

% Adding the one for the constant term
X = [ones(TOTAL, 1) ex2data1(:, 1:COLUMNS-1)];
Y = ex2data1(:, COLUMNS);

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
		A = A + learningFactor * ( training_Y(i) - hXi )  * hXi * ( 1 - hXi ) * Xi;
		% A = A + learningFactor * ( training_Y(i) - hXi ) * Xi;
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

X10 = []; 
X20 = [];

X11 = [];
X21 = [];
for i=1:TOTAL
	if Y(i) == 0
		X10 = [X10 X(2,i)];
		X20 = [X20 X(3,i)];
	else
		X11 = [X11 X(2,i)];
		X21 = [X21 X(3,i)];
	end
end

figure
plot (X10, X20, 'r.');
hold on;
plot (X11, X21, 'g.');
hold on;

daLegend = legend({'Reproved', 'Approved'});
set(daLegend,'color', 'none');
set(daLegend,'FontSize', 10);
set(daLegend,'FontWeight', 'bold');
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)

horiz = -2:0.2:2;
tangent = (A(1) + A(2))/A(3);
plot (horiz, horiz * tangent);
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)

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


% a0 + a1.x + a2.y = 0
% y = (a0 + a1.x) / a2