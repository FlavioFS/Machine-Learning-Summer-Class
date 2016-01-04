% Loading
first = 1;
last  = 253;
[X, Y]  = dataLoader('data/housing.data', first, last);

% Calculating A
B = ones(size(X)(1), 1);
X = [B X];
Xt = transpose(X);
A = inv(Xt*X)*Xt*Y;
At = transpose(A);

% Checking Error
EQM = 0;
Ye = At*Xt;
for i = 1:(last-first + 1)
	EQM = EQM + (Y(i)-Ye(i)).^2;
end

plot(Y, '--or');
hold on;
plot(Ye, '--.k');


disp('---- SIZES ----');
printf('X: (%d, %d)\n', size(X)(1), size(X)(2));
printf('Y: (%d, %d)\n', size(Y)(1), size(Y)(2));
printf('Ye: (%d, %d)\n', size(Ye)(1), size(Ye)(2));
printf('A: (%d, %d)\n', size(A)(1), size(A)(2));
printf('B: (%d, %d)\n\n', size(B)(1), size(B)(2));


% X -> matriz -> mxn
% Y -> coluna -> 1xn
% 
%
%