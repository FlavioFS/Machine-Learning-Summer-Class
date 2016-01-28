%% Loading
load wdbc.data;

%% Sizes
TOTAL   = size(wdbc(:,1))(1,1);			% Number of lines of the first column
COLUMNS_LOAD = size(wdbc(1,:))(1,2);	% Number of columns of the first line
COLUMNS_X = COLUMNS_LOAD - 1;			% Excluding the ID and the Y column, but adding he column of one's
breakpoint = floor(TOTAL*0.7);			% Separating the trainin from the prediction

%% Creating the Xt matrix
training_X = wdbc(1:breakpoint, 3:COLUMNS_LOAD);					% 3rd to last columns
training_X = zscore(training_X);									% Standard Score of Columns ("Normalizing")
training_X = [ones(breakpoint, 1) training_X(1:breakpoint, 1:end)];	% 1's for constant term
training_X = transpose(training_X);									% Real X is based on columns, not lines

%% Creating the Yt matrix
training_Y = wdbc(1:breakpoint, 2); % 2nd column
training_Y = transpose(training_Y);

%% Wgen: Creates a new weight array with random elements
function outputs = Wgen(size)
	outputs = rand(1, size) / 10;
end

%% Ui: Multiplies a weight matrix W for an input array X
function outputs = Ui(Wi, Xi)
	outputs = Wi(1, :) * Xi(:, 1);
end


%% Phi: Error (evaluation function)
% function error = U(w, )
% 	error = 1 / (1 + exp());
% end

%% Phi: Error (evaluation function)
% function error = Phi(u)
% 	error = 1 / (1 + exp());
% end
