load ex1data2.txt

DATA_47 = 47;
ARGS = 2;

% ------- Input Section -------
X = ex1data2(:, 1:ARGS);
Y = ex1data2(:, end);


X = [ones(DATA_47, 1) X];
Xt = transpose(X);
% X = zscore(X);
% -----------------------------

% --------- Training ----------
W = inv(Xt * X) * Xt * Y;
Wt = transpose(W);
Yp = transpose(Wt * Xt);
% -----------------------------

% Error
EQM = 0;
ERRList = [];
for i = 1 : DATA_47
	Ei = Y(i) - Yp(i);
	ERRList = [ERRList; Ei];
	EQM += Ei^2;
end

EQM /= DATA_47;

% Plotting
errorbar(Y, ERRList, '-g.');
hold on;

legend({'Error Bars'});
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)