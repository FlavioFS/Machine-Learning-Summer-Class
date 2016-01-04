% Loading
first = 1;
last  = 253;
[X, Y]  = dataLoader('data/housing.data', first, last);

% Calculating A
Xt = transpose(X);
A = inv(Xt*X)*Xt*Y;
disp('A:');
disp(A);

% Checking Error
EQM = 0;
for i = 1:(last-first)
	EQM = EQM + Y(i)-A*X(i);
end
disp('');
disp('EQM:');
disp(EQM);