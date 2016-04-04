load ex1data1.txt

% ------- Input Section -------
X = ex1data1(:, 1);
Y = ex1data1(:, 2);

DATA_AMOUNT = size(X)(1,1);
ARGS_AMOUNT = size(X)(1,2);
W = ones(1, ARGS_AMOUNT+1) * 0.1;
X = [X(:,1) zscore(X(:, 2:end))];
X = [ones(DATA_AMOUNT, 1) X];
% -----------------------------


% Constants
ALPHA = 0.001;
PASSES = 1;


% --------- Functions ---------
%% Yp: Estimates Y(i)
function outputs = Yp(i, W, Xt)
	outputs = W*Xt(:, i);
end

%% e: Error
function outputs = e(i, W, Xt, Yt)
	outputs = Yp(i, W, Xt) - Yt(i);
end
% -----------------------------


% --------- Training ----------
for pass_it = 1 : PASSES
	% Shuffle
	newOrder = randperm(DATA_AMOUNT, DATA_AMOUNT);

	Xs = X(newOrder, :);
	Ys = Y(newOrder, :);

	Xt = transpose(Xs);
	Yt = transpose(Ys);

	% Practice
	for sample_it = 1 : DATA_AMOUNT
		W
		ALPHA * e(sample_it, W, Xt, Yt) * X(sample_it, :)
		W = W + ALPHA * e(sample_it, W, Xt, Yt) * X(sample_it, :);
	end
end