% Loading
[X, Y]  = dataLoader('data/pima-indians-diabetes.data', ',', 'shuffle');
total = size(X(:,1))(1,1);
breakpoint = floor(total/2);

% Converts the string elements to numbers
X = cellfun(@str2double, X);
Y = cellfun(@str2num   , Y);

% Adding the one for the constant term
B = ones(total, 1);
X = [B X];

% ---------------------------------------------------
%% Training Assets
training_X  = X(1:breakpoint, :);
training_Y  = Y(1:breakpoint, :);
A = transpose(zeros(size(X(1,:))));   % Starting value of A

% Hypothesis function
% h: Estimates Yi for Xi
function outputs = h(Xi, A)
	outputs = 1.0 / (1.0 + exp(-transpose(A) * Xi));
end

% SQErrorTraining: Calculates the squared error so far during the training phase
function outputs = SQErrorTraining(training_X, training_Y, A, breakpoint)
	outputs = 0.0;
	for i=1:breakpoint
		delta = ( training_Y(i) - h(transpose(training_X(i,:)), A) ).^2;
		outputs += delta;
	end
	printf('Error: %d\n', outputs);
end

%% Training
MAX_ATTEMPTS = 10;
MAX_SQERROR = breakpoint * 0.1;
learningFactor = 0.000104;
attempts = 0;
while ((attempts < MAX_ATTEMPTS))
	% Shuffle
	newOrder = randperm(size(training_Y,1));
	shuffled_X = training_X(newOrder, :);
	shuffled_Y = training_Y(newOrder, :);

	for i=1:breakpoint
		Xi = transpose(shuffled_X(i,:));
		hXi = h(Xi, A);
		A = A + learningFactor * ( training_Y(i) - hXi)  * hXi * ( 1 - hXi ) * Xi;
	end
	attempts++;
end


% ---------------------------------------------------
%% Prediction Assets
prediction_X = X(breakpoint+1:end, :);
real_Y       = Y(breakpoint+1:end, :);

% SQErrorFinal: Calculates the squared error for the final sample
function [matches, percent, prediction_Y] = SQErrorFinal(prediction_X, real_Y, A)
	matches = 0;
	total = size(real_Y(:,1));
	prediction_Y = zeros(total, 1);
	
	guessTemp = transpose(A) * transpose(prediction_X);

	% disp(guessTemp);
	guessTemp = transpose(guessTemp);

	for i=1:total
		if guessTemp(i,1) < 0 
			prediction_Y(i,1) = 0;
		else
			prediction_Y(i,1) = 1;
		end

		if real_Y(i,1) == prediction_Y(i,1)
			matches++;
		end
	end

	percent = 1 - (matches/total(1));

end


[matches, percent, prediction_Y] = SQErrorFinal(prediction_X, real_Y, A);
percent *= 100;
printf('Error: %d%% (Score: %d/%d)\n', percent, matches, total-breakpoint);

% Plotting
figure
plot(real_Y, 'wp',...
     'LineWidth', 1,...
     'MarkerSize', 10,...
     'MarkerEdgeColor', 'w',...
     'MarkerFaceColor', 'c');
hold on;
plot(prediction_Y, 'ko',...
     'LineWidth', 2,...
     'MarkerSize', 5,...
     'MarkerEdgeColor', 'k',...
     'MarkerFaceColor', 'r');

daLegend = legend({'Real Values', 'Estimated Values'});
set(daLegend,'color', 'none');
set(daLegend,'FontSize', 10);
set(daLegend,'FontWeight', 'bold');
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)