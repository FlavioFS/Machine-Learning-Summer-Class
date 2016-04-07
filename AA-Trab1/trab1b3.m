load ex1data3.txt

DATA_47 = 47;
ARGS = 5;
BREAKPOINT = 30;

% ------- Input Section -------
X = ex1data3(1:BREAKPOINT, 1:ARGS);
Y = ex1data3(1:BREAKPOINT, end);
LAMBDA = [0 1 1 1 1 1] * 5;

X = [ones(BREAKPOINT, 1) X];
Xt = transpose(X);
% X = zscore(X);
% -----------------------------

% --------- Training ----------
W = inv(Xt * X + (LAMBDA * eye(6))) * Xt * Y;
Wt = transpose(W);
Yp = transpose(Wt * Xt);
% -----------------------------

% Error
Xtest = ex1data3(BREAKPOINT+1:end, 1:ARGS);
Xtest = [ones(DATA_47 - BREAKPOINT, 1) Xtest];
Ytest = ex1data3(BREAKPOINT+1:end, end);
Ypred = transpose(Wt * transpose(Xtest));
EQM = 0;
ERRList = [];
for i = 1 : (DATA_47 - BREAKPOINT)
	Ei = Ytest(i) - Ypred(i);
	ERRList = [ERRList; Ei];
	EQM += Ei^2;
end

EQM /= DATA_47;
disp('------------------------------')
LAMBDA
W
EQM

% Plotting
% errorbar(Ytest, ERRList, '-c.');
% hold on;

% legend({'Error Bars'});
% set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
% set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)