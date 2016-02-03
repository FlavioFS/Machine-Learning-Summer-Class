%%%% =========================================================================== %%%%
%%%%                               Initial Settings                              %%%%
%%%% =========================================================================== %%%%

%% Loading
load wdbc.data;

%% Sizes
TOTAL   = size(wdbc(:,1))(1,1);			% Number of lines of the first column
COLUMNS_LOAD = size(wdbc(1,:))(1,2);	% Number of columns of the first line
COLUMNS_X = COLUMNS_LOAD - 1;			% Excluding the ID and the Y column, but adding he column of one's
BREAKPOINT = floor(TOTAL*0.7);			% Separating the trainin from the prediction

%% Creating the Xt matrix
training_X = wdbc(1:BREAKPOINT, 3:COLUMNS_LOAD);					% 3rd to last columns
training_X = zscore(training_X);									% Standard Score of Columns ("Normalizing")
training_X = [ones(BREAKPOINT, 1) training_X(1:end, 1:end)];		% 1's for constant term
training_X = transpose(training_X);									% Real X is based on columns, not lines

%% Creating the Yt matrix
training_Y = wdbc(1:BREAKPOINT, 2); % 2nd column




%%%% =========================================================================== %%%%
%%%%                                  Definitions                                %%%%
%%%% =========================================================================== %%%%

%% Wgen: Creates a new weight array with random elements inside [0, 0.1] (reused in hidden layers for M)
function output = Wgen(arrayCount, fieldCount)
	output = rand(arrayCount, fieldCount) / 10;
end

%% Ui: Multiplies a weight matrix W (or M) for an input array X
function output = Ui(Wi, Xi)
	output = Wi(1, :) * Xi(:, 1);
end

%% Phi: Error (evaluation function)
function output = Phi(Ui)
	output = 1 / (1 + exp(-Ui));
end

%% DPhi: Error derivative
function output = DPhi(Ui)
	phi = Phi(Ui);
	output = phi * (1 - phi);
end

%% Phi: Error (evaluation function) for an array U of values
function output = PhiArray(U)
	samples = size(U(:,1))(1,1);	% Amount of elements in first column
	for i = 1:samples
		output(i,1) = Phi(-U(i,1));
	end
end

%% DPhi: Error derivative for an array U of values
function output = DPhiArray(U)
	samples = size(U(:,1))(1,1);	% Amount of elements in first column
	for i = 1:samples
		phi = Phi(-U(i,1));
		output(i,1) = phi * (1-phi);
	end
end




%%%% =========================================================================== %%%%
%%%%                                  Training                                   %%%%
%%%% =========================================================================== %%%%

PERCEPTRON_COUNT = 4;						%ç Creating several perceptrons
ALPHA = 0.2;								%ç Learning factor

W = Wgen(PERCEPTRON_COUNT, COLUMNS_X);
M = Wgen(1, PERCEPTRON_COUNT + 1);

YpList = zeros(BREAKPOINT, 1);

for age = 1:5
	reordered = randperm(size(training_Y,1));
	training_X = training_X(:, reordered);
	training_Y = training_Y(reordered, :);

	for j = 1:BREAKPOINT
		sample = training_X(:, j);				%ç The column shown

		% Input Layer
		Ui = W * sample;						%ç Array from W * X
		Zi = PhiArray(Ui);						%ç Array of intermediate results: [Phi(Ui)]
		Zi = zscore(Zi);						%ç Standardizing the sample
		Zi = [1;Zi];							%ç Added linear coefficient
		dZi = DPhiArray(Ui);					%ç Array of Zi's derivatives

		% Hidden Layer 1
		Uk = M * Zi;							%ç Float from M * Z
		Yp = Phi(Uk);							%ç Predicted Y: Phi(Uk)
		dYp = DPhi(Uk);							%ç Yp's derivative

		YpList(j, 1) = Yp;

		% Updating M
		Errk = training_Y(j, 1) - Yp;			%ç Error
		DeltaK = Errk * dYp;					%ç Float
		M += ALPHA * DeltaK * transpose(Zi);

		% Error Backpropagation
		for i = 1:PERCEPTRON_COUNT
			DeltaI = dZi(i, 1) * DeltaK * M(1, i);
			W(i, :) += ALPHA * DeltaI * transpose(sample);
		end

		% ALPHA = 2/(10 + (j-1) + (age-1)*BREAKPOINT);
	end
end




%%%% =========================================================================== %%%%
%%%%                                  Predicting                                 %%%%
%%%% =========================================================================== %%%%
PREDICTION_START = BREAKPOINT + 1;
PREDICTION_AMOUNT = TOTAL-BREAKPOINT;

%% Creating the Xp matrix
prediction_X = wdbc(PREDICTION_START:TOTAL, 3:COLUMNS_LOAD);			%ç 3rd to last columns
prediction_X = zscore(prediction_X);									%ç Standard Score of Columns ("Normalizing")
prediction_X = [ones(PREDICTION_AMOUNT, 1) prediction_X(1:end, 1:end)];	%ç 1's for constant term
prediction_X = transpose(prediction_X);									%ç Real X is based on columns, not lines

%% Creating the Yp matrix
real_Y = wdbc(PREDICTION_START:TOTAL, 2); % 2nd column
guess_Y = zeros(PREDICTION_AMOUNT, 1);

correct = 0;

for j = 1:PREDICTION_AMOUNT	
	sample = prediction_X(:, j);	%ç The input data

	% Input Layer
	Ui = W * sample;				%ç Array from W * X
	Zi = PhiArray(Ui);				%ç Array of intermediate results: [Phi(Ui)]
	Zi = zscore(Zi);				%ç Standardizing the sample
	Zi = [1;Zi];					%ç Added linear coefficient
	dZi = DPhiArray(Ui);			%ç Array of Zi's derivatives

	% Hidden Layer 1
	Uk = M * Zi;					%ç Float from M * Z
	Yp = Phi(Uk);					%ç Predicted Y: Phi(Uk)

	if Yp > 0.5
		guess_Y(j, 1) = 1;
	else
		guess_Y(j, 1) = 0;
	end

	if (guess_Y(j,1) == real_Y(j,1))
		correct++;
	end

	% printf('(%d, %d) - equal? %d\n', guess_Y(j,1), real_Y(j,1), (guess_Y(j,1) == real_Y(j,1)));

	% guess_Y(j, 1) = Yp;			%ç Predicted Values
end

printf ('Result: %4f%% (%3d/%3d)\n', correct/PREDICTION_AMOUNT, correct, PREDICTION_AMOUNT);