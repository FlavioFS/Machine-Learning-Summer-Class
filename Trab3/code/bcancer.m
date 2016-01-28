%%%% =========================================================================== %%%%
%%%%                               Initial Settings                              %%%%
%%%% =========================================================================== %%%%

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




%%%% =========================================================================== %%%%
%%%%                                  Definitions                                %%%%
%%%% =========================================================================== %%%%

%% Wgen: Creates a new weight array with random elements  (reused in hidden layers for M)
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

% %% Yp: Predicted value of Y
% function output = Yp(Zi, Mi)
% 	output = Phi(Wi * Xi);
% end	

% % Error: Yreal - Ypredicted
% function output = Error(Yr, Yp)
% 	output = (Yr - Yp);
% end


%%%% =========================================================================== %%%%
%%%%                                    Tests                                    %%%%
%%%% =========================================================================== %%%%
	
% X1 = training_X(:,1)
% W1 = Wgen(COLUMNS_X)
% U1 = Ui(W1, X1)
% Z1 = Phi(U1)
% dZ1 = DPhi(U1)


%%%% =========================================================================== %%%%
%%%%                                  Training                                   %%%%
%%%% =========================================================================== %%%%

%% Creating several perceptrons
PERCEPTRON_COUNT = 10;

%% Input Layer
W = Wgen(PERCEPTRON_COUNT, COLUMNS_X);
Ui = W * training_X(:, 1);
Z = PhiArray(Ui);

%% Hidden Layer 1
M = Wgen(1, PERCEPTRON_COUNT);
Uk = M * Z;
Yp = PhiArray(Uk);
DYp = DPhiArray(Uk);

% for i = 1:PERCEPTRON_COUNT
% 	W(i,:) = Wgen(COLUMNS_X);
% 	Z(i,1) = W(i,:) * training_X(:,i);
% 	Yp = Phi(M * Z)
% end
