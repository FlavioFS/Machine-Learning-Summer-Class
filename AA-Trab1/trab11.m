load ex1data1.txt

% ------- Input Section -------
X = ex1data1(:, 1);
Y = ex1data1(:, 2);

DATA_AMOUNT = size(X)(1,1);
ARGS_AMOUNT = size(X)(1,2);
W = ones(1, ARGS_AMOUNT+1) * 0.1;
X = [ones(DATA_AMOUNT, 1) X];
X = transpose(X);
Y = transpose(Y);
% -----------------------------

% -------- Definitions --------
ALPHA = 0.0001;

%% Yp: Estimates Y(i)
function outputs = Yp(i, W, X)
	outputs = W*X(:, i);
end

%% e: Error
function outputs = e(i, W, X, Y)
	outputs = Yp(i, W, X) - Y(i);
end

Yp(1, W, X)
e(1, W, X, Y)