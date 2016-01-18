%% Loading
load wdbc.data;

%% Sizes
TOTAL   = size(wdbc(:,1))(1,1);	 % Number of lines of the first column
COLUMNS = size(wdbc(1,:))(1,2);  % Number of columns of the first line
breakpoint = floor(TOTAL*0.7);	 % Separating the trainin from the prediction

%% Creating the Xt matrix
training_X = wdbc(1:breakpoint, 3:COLUMNS); % 3rd to last columns
training_X = zscore(training_X);            % Standard Score of Columns ("Normalizing")

%% Creating the Yt matrix
training_Y = wdbc(1:breakpoint, 2);         % 2nd column