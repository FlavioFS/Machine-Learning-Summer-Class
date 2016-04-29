% Loading
load ex2data2.data;
load featuredX.mat;

% Sizes
TOTAL   = size(featuredX(:,1))(1,1);
COLUMNS = size(featuredX(1,:))(1,2);
breakpoint = 50;% floor(TOTAL/2);

% Adding the one for the constant term
X = featuredX(:, 1:COLUMNS);
Y = ex2data2(:, 3);

% Standard Score of Columns
% for i=2:COLUMNS
% 	X = [X(:,1) zscore(X(:, 2:end))];
% end;

X = transpose(X);

% ---------------------------------------------------
%% Training Assets
training_X  = X(:, 1:breakpoint);
training_Y  = Y(1:breakpoint, 1);
W = ones(1, COLUMNS);   % Starting value of A

% Hypothesis function
% h: Estimates Yi for Xi
function outputs = h(Xi, W)
	outputs = 1.0 / (1.0 + exp(-W * Xi));
end;

% SQErrorTraining: Calculates the squared error so far during the training phase
function outputs = SQErrorTraining(training_X, training_Y, A, breakpoint)
	outputs = 0.0;
	for i=1:breakpoint
		delta = ( training_Y(i) - h(training_X(:,i), W) ).^2;
		outputs += delta;
	end;
end;

%% Training
MAX_ATTEMPTS = 1000;
MAX_SQERROR = breakpoint * 0.1;
learningFactor = 0.01;
LAMBDA = 0;
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
		hXi = h(Xi, W);
		ERRi = ( training_Y(i) - hXi );
		dHi = hXi * ( 1 - hXi );
		% W = W + learningFactor * ( training_Y(i) - hXi )  * hXi * ( 1 - hXi ) * Xi;
		W1 = W(1) + learningFactor * ERRi * hXi * dHi * Xi(1);
		Wi = W(1, 2:end);
		Wi = Wi + learningFactor * (ERRi * hXi * dHi * transpose(Xi(2:end)) - LAMBDA * Wi);
		W = [W1 Wi];
		% learningFactor = 1000 / (1000 + (i + attempts*breakpoint)/2);
	end;
	
	Ytp = transpose(W * training_X);
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


% ---------------------------------------------------
%% Prediction Assets
prediction_X = X(:, breakpoint+1:end);
real_Y       = Y(breakpoint+1:end, :);

% SQErrorFinal: Calculates the squared error for the final sample
function [matches, percent, prediction_Y] = SQErrorFinal(prediction_X, real_Y, W)
	matches = 0;
	TOTAL = size(real_Y(:,1));
	prediction_Y = zeros(TOTAL, 1);
	
	guessTemp = W * prediction_X;

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
	end;

	percent = 1 - (matches/TOTAL(1));

end;


[matches, percent, prediction_Y] = SQErrorFinal(prediction_X, real_Y, W);
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

% figure
% plot (X10, X20, 'wo');
% hold on;
% plot (X11, X21, 'go');
% hold on;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% mapFeature: function description
function output = mapFeature(X1, X2)
    degree = 30;
    output = ones(size(X1(:,1)));
    for i = 1:degree
        for j = 0:i
            output(:, end+1) = (X1.^(i-j)).*(X2.^j);
        end
    end
end


function plotDecisionBoundary(theta, X, y)
%PLOTDECISIONBOUNDARY Plots the data points X and y into a new figure with
%the decision boundary defined by theta
%   PLOTDECISIONBOUNDARY(theta, X,y) plots the data points with + for the 
%   positive examples and o for the negative examples. X is assumed to be 
%   a either 
%   1) Mx3 matrix, where the first column is an all-ones column for the 
%      intercept.
%   2) MxN, N>3 matrix, where the first column is all-ones

    % Plot Data
    tmp1 = find(y==1);
    tmp0 = find(y==0);
    plot(X(tmp1,2),X(tmp1,3), '.');
    hold on
    plot(X(tmp0,2),X(tmp0,3), 'r.');

if size(X, 2) <= 3
    % Only need 2 points to define a line, so choose two endpoints
    plot_x = [min(X(:,2))-2,  max(X(:,2))+2];

    % Calculate the decision boundary line
    plot_y = (-1./theta(3)).*(theta(2).*plot_x + theta(1));

    % Plot, and adjust axes for better viewing
    plot(plot_x, plot_y)
    
    % Legend, specific for the exercise
    legend('Admitted', 'Not admitted', 'Decision Boundary');
    set(daLegend,'color', 'none');
	set(daLegend,'FontSize', 10);
	set(daLegend,'FontWeight', 'bold');
	set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
	set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)
    axis([30, 100, 30, 100])
else
    % Here is the grid range
    u = linspace(-1, 1.5, 50);
    v = linspace(-1, 1.5, 50);

    z = zeros(length(u), length(v));
    % Evaluate z = theta*x over the grid
    for i = 1:length(u)
        for j = 1:length(v)
            z(i,j) = mapFeature(u(i), v(j))*theta;
        end
    end
    z = transpose(z); % important to transpose z before calling contour
    
    % Plot z = 0
    % Notice you need to specify the range [0, 0]
    contour(u, v, z, [0, 0], 'LineWidth', 2)
end
hold off

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% the = [-0.4231159, -0.0049772, -0.0737387];
plotDecisionBoundary(transpose(W), transpose(X), Y);
% daLegend = legend({'Reproved', 'Approved'});
% set(daLegend,'color', 'none');
% set(daLegend,'FontSize', 10);
% set(daLegend,'FontWeight', 'bold');
% set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
% set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)