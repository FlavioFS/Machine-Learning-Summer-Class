% Loading
first = 1;
last  = 506;
half = 253;
[X, Y]  = dataLoader('data/housing.data', first, last);

% Calculating A
B = ones(half, 1);
Xtraining = [B X(1:half, :)];
Ytraining = Y(1:half, :);
XtrainingT = transpose(Xtraining);
A = inv(XtrainingT*Xtraining)*XtrainingT*Ytraining;
At = transpose(A);

% Checking Error
EQM = 0;
Xe = [ones(last-half, 1) X(half+1:end, :)]; % Provided data for prediction
Ye = At*transpose(Xe);                      % Values estimated
Yr = Y(half+1:end, :);                      % Real values

% Error calculation
for i = 1:(last-half)
	EQM += (Yr(i)-Ye(i)).^2;
end
EQM /= last-half;

% Displaying results
printf('EQM: %ld\n', EQM);
figure
plot(Yr, '-cp',...
     'LineWidth', 2,...
     'MarkerSize', 10,...
     'MarkerEdgeColor', 'k',...
     'MarkerFaceColor', 'g');            % Real values in red points
hold on;
plot(Ye, '-yo',...
     'LineWidth', 2,...
     'MarkerSize', 7,...
     'MarkerEdgeColor', 'k',...
     'MarkerFaceColor', 'r');            % Real values in red points
% plot(Ye, '-k.');               % Estimated values in black circles