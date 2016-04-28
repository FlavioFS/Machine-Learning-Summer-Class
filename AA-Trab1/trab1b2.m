load ex1data2.txt

DATA_47 = 47;
ARGS = 2;
BREAKPOINT = 30;

% ------- Input Section -------
X = ex1data2(1:DATA_47, 1:ARGS);
Y = ex1data2(1:DATA_47, end);


X = [ones(DATA_47, 1) X];

Xl = X(1:BREAKPOINT, 1:ARGS);
Xlt = transpose(Xl);
Yl = Y(1:BREAKPOINT);
% X = zscore(X);
% -----------------------------

% --------- Training ----------
W = inv(Xlt * Xl) * Xlt * Yl;
Wt = transpose(W);
% -----------------------------

% Error
EQM = 0;
ERRList = [];
Xc = X(BREAKPOINT+1:end, 1:ARGS);
Yc = Y(BREAKPOINT+1:end);
Yp = transpose(Wt * transpose(Xc));
for i = 1 : DATA_47 - BREAKPOINT
	Ei = Yc(i) - Yp(i);
	ERRList = [ERRList; Ei];
	EQM += Ei^2;
end

EQM /= DATA_47;

% Plotting
errorbar(Yc, ERRList, '-g.');
hold on;

legend({'Error Bars'});
set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)