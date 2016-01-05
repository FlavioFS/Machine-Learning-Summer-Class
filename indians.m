% Loading
[X, Y]  = dataLoader('data/pima-indians-diabetes.data', ',');
total = size(X(:,1))(1,1);
breakpoint = floor(total/2);

% Converts the string elements to numbers
X = cellfun(@str2double, X);
Y = cellfun(@str2num   , Y);

% Adding the one for the constant term
B = ones(total, 1);
X = [B X];

% Training

% % Training
% Xtraining = X(1:breakpoint, :);
% Ytraining = Y(1:breakpoint, :);
% XtrainingT = transpose(Xtraining);
% A = inv(XtrainingT*Xtraining)*XtrainingT*Ytraining;
% At = transpose(A);

% % Checking Error
% EQM = 0;
% prediction_X = X(breakpoint+1:end, :);     % Provided data for prediction
% prediction_Y = At*transpose(prediction_X); % Values estimated
% real_Y       = Y(breakpoint+1:end, :);     % Real values

% % Error calculation
% for i = 1:(total-breakpoint)
% 	EQM += (real_Y(i)-prediction_Y(i)).^2;
% end
% EQM /= total-breakpoint;

% % Displaying results
% printf('EQM: %ld\n', EQM);

% % Plotting
% figure
% plot(real_Y, '--wp',...
%      'LineWidth', 1,...
%      'MarkerSize', 10,...
%      'MarkerEdgeColor', 'w',...
%      'MarkerFaceColor', 'c');
% hold on;
% plot(prediction_Y, '--ko',...
%      'LineWidth', 2,...
%      'MarkerSize', 7,...
%      'MarkerEdgeColor', 'k',...
%      'MarkerFaceColor', 'r');

% daLegend = legend({'Real Values', 'Estimated Values'});
% set(daLegend,'color', 'none');
% set(daLegend,'FontSize', 10);
% set(daLegend,'FontWeight', 'bold');
% set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
% set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)