%%%% =========================================================================== %%%%
%%%%                               Initial Settings                              %%%%
%%%% =========================================================================== %%%%

%% Loading
load teste.data;

%% Sizes
TOTAL   = size(teste(:,1))(1,1);			% Number of lines of the first column
COLUMNS_LOAD = size(teste(1,:))(1,2);	% Number of columns of the first line




%%%% =========================================================================== %%%%
%%%%                                  Definitions                                %%%%
%%%% =========================================================================== %%%%

%% CenterGen: Creates <centerCount> centers of <coordCount> coordinates filled with random elements inside [0, 10]
function output = CenterGen(centerCount, coordCount)
	output = rand(centerCount, coordCount) * 10;
end




%%%% =========================================================================== %%%%
%%%%                                 Estimating                                  %%%%
%%%% =========================================================================== %%%%

%% How many groups?
CENTER_COUNT = 6;
centerPositions = CenterGen(CENTER_COUNT, COLUMNS_LOAD);		% Generatins centers
distances = zeros(TOTAL, CENTER_COUNT);
groups = zeros(TOTAL, 1);

for i=1:TOTAL													% For all samples
	for j=1:CENTER_COUNT										% Calculate distance to each center
		distances(i, j) = norm(centerPositions(j, :) - teste(i, :));
	end
end

distances






%%%% =========================================================================== %%%%
%%%%                                 Estimating                                  %%%%
%%%% =========================================================================== %%%%

%% Calculating squared distances
% for i=1:TOTAL
% 	for j=1:CENTER_COUNT
% 		SQRDistances(i, j) = ;
% 	end
% end

